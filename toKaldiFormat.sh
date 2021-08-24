#!/bin/bash



# #!/bin/bash
# start=$(date +%s.%N)

# # HERE BE CODE

# end=$(date +%s.%N)    
# runtime=$(python -c "print(${end} - ${start})")

# echo "Runtime was $runtime"





# for id in 'S12' 'S21' 'S22' 'S23' 'S24' 'S25' 'S6' 'S18'
for id in 'S6' 
do
    for file in /dataroot/Baylor/$id/new-*

    do
        if [[ -d $file/speech ]]
        then
            IFS='/'
                read -a strarr <<< "$file"
                item=$(basename ${strarr[4]} .wav)
                IFS=' '
                
                voxceleb1_path=$file/speech
                dir=/dataroot/Baylor-experiments
                data=$dir/data
                exp=$dir/exp
#                 echo $voxceleb1_path
#                 echo $data/$item

                start=$(date +%s.%N)
                recipe/voxceleb/prepare/o.pl $voxceleb1_path 16 $data/$item

# exit 1 
            ./newCopyData.sh $data feature $item
            

            ./makeFeatures.sh $data/feature/$item fbank conf/sre-fbank-40.conf $exp
            
            end=$(date +%s.%N)  
            runtime=$(python -c "print(${end} - ${start})")

            echo "Feature extraction runtime was $runtime"
            
            
            start=$(date +%s.%N)

            ./computeAugmentedVad.sh $data/feature/$item $data/feature/$item/utt2spk conf/vad-5.5.conf $exp 
            
            end=$(date +%s.%N)  
            runtime=$(python -c "print(${end} - ${start})")

            echo "Kaldi-format Feature runtime was $runtime"
            
            start=$(date +%s.%N)

            ./runPytorchLauncher.sh 
            python3 recipe/voxcelebSRC/Baylor.py  --gpu_id="7" --stage=4 --Data=/dataroot/experiments/data --Exp=/dataroot/experiments/exp --ep=20 --name=$item
            
            end=$(date +%s.%N)  
            runtime=$(python -c "print(${end} - ${start})")

            echo "Embedding extraction runtime was $runtime"

            # Embeddings of [ /dataroot/Baylor-experiments/data/feature/$item ] has been extracted to [ /dataroot/experiments/exp/resnet5/far_epoch20/$item ]

            # then go to sre19/Backends-for-SRE19/Baylor_backend.sh
        else
            echo 'skip'
        fi

    done
done