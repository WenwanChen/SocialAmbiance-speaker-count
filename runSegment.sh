#!/bin/bash

# run in docker2
# ------------1-------------
pre='new-'
ext='.wav'


for id in  'S6'
do

chmod 777 /dataroot/Baylor/$id

Dir=/dataroot/Baylor/$id/

# for file in /dataroot/Baylor/$id/*.wav
# do

# start=$(date +%s.%N)

# name=$(basename $file .wav)
# ffmpeg -y -i $file -vn -ar 16000 -ac 1 ${Dir}${pre}${name}${ext}

# end=$(date +%s.%N)  
# runtime=$(python -c "print(${end} - ${start})")

# echo "re-sample runtime was $runtime for $file"

# done


# ---------------2---------------
for text in /dataroot/Baylor/$id/new-*.wav
do

start=$(date +%s.%N)

size=$(soxi -D $text)


IFS='/'
read -a strarr <<< "$text"
name=$(basename ${strarr[4]} .wav)
IFS=' '
echo $name
mkdir /dataroot/Baylor/$id/$name
chmod 777 /dataroot/Baylor/$id/$name
mkdir /dataroot/Baylor/$id/$name/speech
chmod 777 /dataroot/Baylor/$id/$name/speech

python3 2h.py /dataroot/Baylor/$id $name /dataroot/Baylor/$id/$name $size

end=$(date +%s.%N)  
runtime=$(python -c "print(${end} - ${start})")

echo "segment runtime was $runtime for $text"
# --------------3----------------
start=$(date +%s.%N)
for f in /dataroot/Baylor/$id/$name/*.wav
do
echo $f
CUDA_VISIBLE_DEVICES='7' ina_speech_segmenter.py -i $f -o /dataroot/Baylor/$id/$name -d 'smn' -g 'false'
done

end=$(date +%s.%N)  
runtime=$(python -c "print(${end} - ${start})")
echo "VAD runtime was $runtime for $text"
# --------------4-------------
start=$(date +%s.%N)
python3 concat.py /dataroot/Baylor/$id $name /dataroot/Baylor/$id/$name /dataroot/Baylor/$id/$name/speech $size
end=$(date +%s.%N)  
runtime=$(python -c "print(${end} - ${start})")
echo "concat runtime was $runtime for $text"

done

done