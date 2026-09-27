fmt:
	find . \
		-name '*.nix' \
		-not -path './nix/tamal/*' \
		-exec nixfmt {} \;
