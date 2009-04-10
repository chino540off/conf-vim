syntax case ignore
syntax match Title		display /^\*.*$/ contains=Identifier
syntax match Special	display /^[ \t]\+\*.*$/ contains=Identifier
syntax match Comment	/^[ \t]\+[a-z0-9].*/
syntax match Statement	/^[ \t]\+-.*/ contains=Identifier
syntax match Question	/^[ \t]\+\/.*/
syntax match Identifier	/=.*/


let b:current_syntax = "todo"
