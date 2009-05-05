syntax case ignore
syntax match Title		display /^\*.*$/ contains=Type
syntax match Special	display /^[ \t]\+\*.*$/ contains=Type
syntax match Function	/^[ \t]\+[a-z0-9].*/
syntax match Statement	/^[ \t]\+-.*/ contains=Type
syntax match Comment	/^[ \t]\+\/.*/
syntax match Type	/=.*/


let b:current_syntax = "todo"
