_m = vim

$(_m)-dirs =	\
  backup	\
  temp

$(_m)-dir-backup	= $(CURDIR)/$(_m)/$(_m)/backup
$(_m)-dir-temp		= $(CURDIR)/$(_m)/$(_m)/temp

$(_m)-links =	\
  vimrc		\
  viminfo	\
  vim

$(_m)-link-vimrc	= ~/.vimrc
$(_m)-link-viminfo	= ~/.viminfo
$(_m)-link-vim		= ~/.vim
