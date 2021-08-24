#!/bin/bash


for id in 'S6' 'S21' 
# for id in 'S1' 'S10' 'S12' 'S13' 'S14' 'S15' 'S16' 'S17' 'S18' 'S19' 'S2' 'S20' 
do
    for item in /dataroot/Baylor/$id/new-*
    do

        if [[ -d $item ]]
        then
            Dir=$item
            rm -rf $Dir/speech/5s
            for file in $Dir/speech/*.wav
            do

                # directory to store 5s segments
                IFS='/'
                read -a strarr <<< "$file"
                name=$(basename ${strarr[6]} .wav)
                IFS=' '
                mkdir -p $Dir/speech/5s
                chmod 777 $Dir/speech/5s

                python 5s.py $file $Dir/speech/5s $name

            done


        else
            echo 'skip'

        fi

    done

done


