#! /bin/zsh

ROUGE="\033[31;01m"
VERT="\033[32;01m"
JAUNE="\033[33;01m"
BLEU="\033[34;01m"
MAGENTA="\033[35;01m"
CYAN="\033[36;01m"
BLANC="\033[37;01m"
NEUTRE="\033[0m"

echo "Vim Install..."

if [ ! -d vim/backup ]; then
  echo -en "${VERT}*${NEUTRE}  backup created\t"
  echo -e "${BLEU}[${VERT}OK${BLEU}]${NEUTRE}"
  mkdir vim/backup
fi

if [ ! -d vim/temp ]; then
  echo -en "${VERT}*${NEUTRE}  temp created\t\t"
  echo -e "${BLEU}[${VERT}OK${BLEU}]${NEUTRE}"
  mkdir vim/temp
fi

rm ~/.vimrc
ln -s $PWD/vimrc ~/.vimrc
echo -en "${VERT}*${NEUTRE}  .vimrc linked\t"
echo -e "${BLEU}[${VERT}OK${BLEU}]${NEUTRE}"

rm ~/.vim
ln -s $PWD/vim ~/.vim
echo -en "${VERT}*${NEUTRE}  .vim linked\t\t"
echo -e "${BLEU}[${VERT}OK${BLEU}]${NEUTRE}"

rm ~/.viminfo
ln -s $PWD/viminfo ~/.viminfo
echo -en "${VERT}*${NEUTRE}  .viminfo linked\t"
echo -e "${BLEU}[${VERT}OK${BLEU}]${NEUTRE}"

echo -e "Done."
