f=$1

#first we sort the data wrt 1st column
echo $f
sortedf="$f".sorted
sort $f -o $sortedf -T $TMPDIR
rm $f

#split it into chunks of 10000 lines, could be customized
split -l 10000 $f

#this script will take the first column as the id space
#it will rename all chunks wrt the value in first row,first column 
#it will also make sure that all rows will be copied to the corresponding chunk, depending on which id space they belong to
sh rename_chunks.sh $f




