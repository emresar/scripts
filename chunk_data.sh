f=$1

#first we sort the data wrt 1st column
echo $f
sortedf="$f".sorted
sort $f -o $sortedf -T $TMPDIR
rm $f

#split it into chunks of 10000 lines, could be customized
split -l 10000 $f

#the following will take the first column as the id space
#it will rename all chunks wrt the value in first row,first column 
#it will also make sure that all rows will be copied to the corresponding chunk, depending on which id space they belong to

fname=$f
echo $fname

# as a result of calling split, all file names start with x
for f in x*;
do
        echo "++++++++++++++++"
        echo "$f";
        #rename file chunk based on the first 6 characters of the first line, but this can be customized
        newf=$fname.`sed -n '1p' $f | head -c 6` #| tail -c 6`
        existingf=$newf
        i=1
        #file exists, find the next id for it
        while [ -f $newf ]
        do
                existingf=$newf
                i=$((i+1))
                arg=$i"p"
                newf=$1.$( sed -n $( echo "$arg") $f | head -c 6 ) # | tail -c 6 ) 
                if [ $i -eq 10000 ]; then
                        break
                fi
        done

        #if the file is 10000 lines, copy it to the newly created file above that represents the id space
        if [ $i -eq 10000 ]; then
                cat $f  >> $newf
                rm $f
        else
        #if not, copy lines from the previous file which contains ids that should belong to this file
                mv $f $newf
                #rm $f
                if [ $i -gt 1 ]; then
                        echo "fetching "$i" entries from existing file"
                        echo "$existingf"
                        head -n $i $newf  >> $existingf
                        tail -n+$i $newf > tmp.dat
                        cat tmp.dat > $newf
                        rm tmp.dat

                fi
        fi

        echo "$newf "$( wc -l $newf )" lines"
        echo "$existingf "$( wc -l $existingf )" lines"

done




