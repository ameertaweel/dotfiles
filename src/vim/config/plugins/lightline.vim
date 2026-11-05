let g:lightline = {
	\	'active': {
	\		'left': [
	\			[ 'mode', 'paste' ],
	\			[ 'gitbranch', 'readonly', 'filename', 'modified' ]
	\		],
	\		'right': [
	\		[ 'lineinfo' ],
	\			[ 'percent' ],
	\			[ 'filetype' ]
	\		]
	\	},
	\	'component_function': {
	\		'gitbranch': 'FugitiveHead'
	\	}
	\}
