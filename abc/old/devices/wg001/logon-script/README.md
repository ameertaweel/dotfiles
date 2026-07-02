# Windows Logon Script

Sends a notification over Ntfy when the machine is unlocked.

## Setup

- Store the script locally on the computer.
- Open "Task Scheduler".
- Select "Task Scheduler Library" from the left pane.
- Click "Create Task" from the right pane.
- In the "Create Task" dialog:
  - In the "General" tab:
    - Set task name.
    - Enable "Run whether user is logged on or not".
    - Check "Run with highest privileges".
    - Check "Hidden".
    - Set "Configure for" to "Windows 10".
  - In the "Triggers" tab:
    - Create a new trigger.
    - Set "Begin the task" to "On workstation unlock".
  - In the "Actions" tab:
    - Create a new action.
    - Set "Action" to "Start a program".
    - Set "Program/script" to `"C:\Program Files\PowerShell\7\pwsh.exe"`.
    - Set "Add arguments" to `"C:\$PATH_TO_LOGON_SCRIPT\logon.ps1"`.
  - In the "Conditions" tab:
    - Uncheck "Start the task only if the computer is on AC power".
  - In the "Settings" tab:
    - Check "Allow task to be run on demand".
    - Set "If the task fails, restart every" to "1 minute".
    - Set "Attempt to restart up to" to "10 times".
    - Set "Stop the task if it runs longer than" to "1 hour".
    - Check "If the running task does not end when requested, force it to stop".
    - Set "If the task is already running, then the following rule applies" to "Run a new instance in parallel".

## Resources Used

- https://superuser.com/questions/15596/automatically-run-a-script-when-i-log-on-to-windows
- https://superuser.com/questions/478052/windows-7-task-scheduler-hidden-setting-doesnt-work
