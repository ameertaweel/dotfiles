;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(add-to-list 'default-frame-alist '(undecorated . t))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Ameer Taweel"
      user-mail-address "ameertaweel2002@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq display-line-numbers-width-start t)
(setq display-line-numbers-grow-only t)

(use-package! org
  ; Code that runs before the package is loaded
  :init
  ;; If you use `org' and don't want your org files in the default location below,
  ;; change `org-directory'. It must be set before org loads!
  (setq org-directory "~/knowledge-base/org/")
  (setq org-log-done 'time)
  (setq org-agenda-files '("~/knowledge-base/org/" "~/knowledge-base/org/daily/"))
  (setq org-roam-directory "~/knowledge-base/org/")
  (setq org-roam-dailies-directory "daily")
  (setq org-hide-emphasis-markers t)
  ; Code that runs after the package is loaded
  :config
  (setq org-log-into-drawer "LOGBOOK")
  (setq org-todo-keywords
        '((sequenc
           "TODO(t!)"
           "PLNG(p!)" ; Planning Currently
           "FPLN(f!)" ; Planning Finished
           "WRKN(w!)" ; Working Currently (In-Progress)
           "HOLD(h!)" ; On-Hold
           "|"
           "DONE(d!)"
           "KILL(k!)")))
  (setq org-log-reschedule 'time)
  (setq org-log-redeadline 'time)
  (setq org-agenda-custom-commands
        '(("t" "Today's Agenda" agenda ""
           ((org-agenda-span 1)
            (org-agenda-start-day "0d")
            (org-agenda-start-on-weekday nil)))
          ("3" "Yesterday, Today, and Tomorrow" agenda ""
           ((org-agenda-span 3)
            (org-agenda-start-day "-1d")
            (org-agenda-start-on-weekday nil)))
          ("w" "Week's Agenda" agenda "" ((org-agenda-span 7)
                                          (org-agenda-start-day "-3d")
                                          (org-agenda-start-on-weekday nil)))
          ("e" "Eventual TODOs" alltodo "" ((org-agenda-skip-function '(or (kyouma/org-skip-subtree-if-habit)
                                                                           (org-agenda-skip-if nil '(scheduled deadline))))))
          ("a" "All TODOs" alltodo ""))))

(defun kyouma/org-skip-subtree-if-habit ()
  "Skip an agenda entry if it has a STYLE property equal to \"habit\".

Based On:
https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html"
  (let ((subtree-end (save-excursion (org-end-of-subtree t))))
    (if (string= (org-entry-get nil "STYLE") "habit")
        subtree-end
      nil)))

(defun kyouma/search-roam ()
 "Run consult-ripgrep on the org roam directory"
 (interactive)
 (consult-ripgrep org-roam-directory nil))

(defun kyouma/get-random-uuid ()
  "Generate a UUID.
This commands calls `uuidgen` on MacOS, Linux, and calls PowelShell on Microsoft
Windows.

Based On:
URL `http://xahlee.info/emacs/emacs/elisp_generate_uuid.html`"
  (string-trim
   (cond
    ((eq system-type 'windows-nt)
     (shell-command-to-string "pwsh.exe -Command [guid]::NewGuid().toString()"))
    ((eq system-type 'darwin) ; Mac
     (shell-command-to-string "uuidgen"))
    ((eq system-type 'gnu/linux)
     (shell-command-to-string "uuidgen"))
    (t
     ;; Code here by Christopher Wellons, 2011-11-18.
     ;; Editted further by Hideki Saito to generate all valid variants for "N" in
     ;; xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx format.
     (let ((xstr (md5 (format "%s%s%s%s%s%s%s%s%s%s"
                              (user-uid)
                              (emacs-pid)
                              (system-name)
                              (user-full-name)
                              (current-time)
                              (emacs-uptime)
                              (garbage-collect)
                              (buffer-string)
                              (random)
                              (recent-keys)))))
       (format "%s-%s-4%s-%s%s-%s"
               (substring xstr 0 8)
               (substring xstr 8 12)
               (substring xstr 13 16)
               (format "%x" (+ 8 (random 4)))
               (substring xstr 17 20)
               (substring xstr 20 32)))))))

(defun kyouma/org-generate-unique-custom-id ()
  "Generate a unique custom ID for Org mode heading."
  (interactive)
  (org-set-property "CUSTOM_ID" (kyouma/get-random-uuid)))

(defun kyouma/org-global-custom-ids ()
  "Find custom ID fields in all Org agenda files.

Based On:
https://blog.aaronbieber.com/2016/07/31/org-navigation-revisited.html"
  (let ((files (org-agenda-files))
        file
        kyouma/all-org-custom-ids)
    (while (setq file (pop files))
      (with-current-buffer (org-get-agenda-file-buffer file)
        (save-excursion
          (save-restriction
            (widen)
            (goto-char (point-min))
            (while (re-search-forward "^[ \t]*:CUSTOM_ID:[ \t]+\\(\\S-+\\)[ \t]*$"
                                      nil t)
              (let ((custom-id (match-string-no-properties 1)))
                (add-to-list 'kyouma/all-org-custom-ids
                             `(,(concat custom-id " :: " (org-entry-get nil "ITEM"))
                               ,(concat file ":" (number-to-string (line-number-at-pos)))))))))))
    kyouma/all-org-custom-ids))

(defun kyouma/org-goto-custom-id ()
  "Go to the location of a custom ID, selected interactively.

Based On:
https://blog.aaronbieber.com/2016/07/31/org-navigation-revisited.html"
  (interactive)
  (let* ((all-custom-ids (kyouma/org-global-custom-ids))
         (custom-id (completing-read
                     "Custom ID: "
                     all-custom-ids)))
    (when custom-id
      (let* ((val (cadr (assoc custom-id all-custom-ids)))
             (id-parts (split-string val ":"))
             (file (car id-parts))
             (line (string-to-number (cadr id-parts))))
        (pop-to-buffer-same-window (org-get-agenda-file-buffer file))
        (goto-char (point-min))
        (forward-line line)
        (org-up-element)
        (org-reveal t)
        (org-fold-show-subtree)))))

(defun kyouma/org-insert-custom-id-link ()
  "Insert an Org link to a custom ID selected interactively.

Based On:
https://blog.aaronbieber.com/2016/07/31/org-navigation-revisited.html"
  (interactive)
  (let* ((all-custom-ids (kyouma/org-global-custom-ids))
         (selection (completing-read
                     "Custom ID: "
                     all-custom-ids))
         (selection-parts (split-string selection " :: "))
         (custom-id (car selection-parts))
         (heading (mapconcat 'identity (cdr selection-parts) " :: ")))
    (when custom-id
      (org-insert-link nil (concat "custom:" custom-id) heading))))

; Register Custom Link Prefix.
;
; Based On:
; https://christiantietze.de/posts/2021/02/emacs-org-mode-zettel-link
(org-link-set-parameters
 "custom"
 :follow (lambda (searchterm)
           (let* ((all-custom-ids (kyouma/org-global-custom-ids))
                  (custom-ids (mapcar (lambda (x) (cons (car (split-string (car x) " :: ")) (cadr x))) all-custom-ids))
                  (fileline (cdr (assoc searchterm custom-ids)))
                  (file-parts (split-string fileline ":"))
                  (file (car file-parts))
                  (line (string-to-number (cadr file-parts))))
             (pop-to-buffer-same-window (org-get-agenda-file-buffer file))
             (goto-char (point-min))
             (forward-line line)
             (org-up-element))))

(map! :leader "n r S" 'kyouma/search-roam)
(map! :leader "n r c" 'kyouma/org-goto-custom-id)
(map! :leader "n r l" 'kyouma/org-insert-custom-id-link)
(map! :after org
      :map org-mode-map :localleader "l c" 'kyouma/org-generate-unique-custom-id)

(use-package! org-habit
  :after org
  :config
  (add-to-list 'org-modules 'org-habit))

(setq org-capture-templates
      '(("w" "Weight" table-line (file+headline "20241023085029-weight_control.org" "Tracking") "| %u | %? |")))

(use-package! beancount
  ; Code that runs before the package is loaded
  :init
  (setq beancount-number-alignment-column 60))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Fish (and possibly other non-POSIX shells) is known to inject garbage output
;; into some of the child processes that Emacs spawns. Many Emacs
;; packages/utilities will choke on this output, causing unpredictable issues.
(setq shell-file-name (executable-find "bash"))
