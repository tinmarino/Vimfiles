echo "use it like ./gitscript.sh \"my commited string\""
git init 
git add .
#git remote add origin https://github.com/tinmarino/Vimfiles.git
if [[ $1 == "" ]] 
then 
   echo "no first arg, taking auto commit " 
   git commit -m "auto commit"
else 
   git commit -m "$1"
fi 
git push -u origin master 
