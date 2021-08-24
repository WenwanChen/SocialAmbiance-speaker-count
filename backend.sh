. ./cmd.sh
. ./path.sh
set -e

fea_nj=40


lda_dim=200

dir=/dataroot/experiments/exp/resnet5/far_epoch20
dir1=/dataroot/experiments/exp/resnet5/far_epoch_20

for id in 'S6' 
do
    for item in /dataroot/Baylor/$id/new-*
    do 

    
        if [[ -d $item/speech ]]
        then
            IFS='/'
            read -a strarr <<< "$item"
            name=$(basename ${strarr[4]} .wav)
            IFS=' '
# #   ----------------------same-----------------------------
#             $train_cmd $dir1/voxceleb_train_combined/log/compute_mean.log \
#             ivector-mean scp:$dir1/voxceleb_train_combined/xvector.scp \
#             $dir1/voxceleb_train_combined/mean.vec || exit 1;
# # ---------------------------------------------------------
            if [[ -f /dataroot/Baylor-experiments/data/feature/$name/feats.scp ]]
            then
                start=$(date +%s.%N)
                
                $train_cmd $dir/$name/log/compute_mean.log \
                ivector-mean scp:$dir/$name/xvector.scp \
                $dir/$name/mean.vec || exit 1;
                echo 'mean done'
# # ----------------------------same---------------------------------
#             # LDA
#             $train_cmd $dir1/voxceleb_train_combined/log/lda.log \
#             ivector-compute-lda --total-covariance-factor=0.0 --dim=$lda_dim \
#             "ark:ivector-subtract-global-mean scp:$dir1/voxceleb_train_combined/xvector.scp ark:- |" \
#             ark:/dataroot/experiments/data/feature/voxceleb_train_combined/utt2spk $dir1/voxceleb_train_combined/transform.mat || exit 1;

#             echo 'lda done'

#             # PLDA
#             $train_cmd $dir1/voxceleb_train_combined/log/plda_lda${lda_dim}.log \
#             ivector-compute-plda --binary=false ark:/dataroot/experiments/data/feature/voxceleb_train_combined/spk2utt \
#             "ark:ivector-subtract-global-mean scp:$dir1/voxceleb_train_combined/xvector.scp ark:- | transform-vec $dir1/voxceleb_train_combined/transform.mat ark:- ark:- | ivector-normalize-length ark:- ark:- |" \
#             $dir1/voxceleb_train_combined/plda_lda${lda_dim}.txt || exit 1;
#             echo 'plda done'
# # -------------------------same----------------------------------------
                num_sample=$(wc -l < "/dataroot/Baylor-experiments/data/$name/wav.scp")

                python3 make_trials.py $dir1/voxceleb_train_combined/xvector.scp $dir/$name/xvector.scp /dataroot/Baylor/$id/$name/speech/trials.txt $num_sample


                echo 'trial produced'

                # Scoring

                $train_cmd $dir/xvector_scores/log/$id_$name.log ivector-plda-scoring --normalize-length=true "ivector-copy-plda --smoothing=0.0 $dir1/voxceleb_train_combined/plda_lda${lda_dim}.txt - |" "ark:ivector-subtract-global-mean $dir1/voxceleb_train_combined/mean.vec scp:$dir1/voxceleb_train_combined/xvector.scp ark:- | transform-vec $dir1/voxceleb_train_combined/transform.mat ark:- ark:- | ivector-normalize-length ark:- ark:- |" "ark:ivector-subtract-global-mean $dir/$name/mean.vec scp:$dir/$name/xvector.scp ark:- | transform-vec $dir1/voxceleb_train_combined/transform.mat ark:- ark:- | ivector-normalize-length ark:- ark:- |"  "cat '/dataroot/Baylor/$id/$name/speech/trials.txt' | cut -d\  --fields=1,2 |" $dir/xvector_scores/$id+$name || exit 1;

                echo 'scored'
                
                end=$(date +%s.%N)  
                runtime=$(python -c "print(${end} - ${start})")
                echo "Scoring runtime was $runtime for $item"

                start=$(date +%s.%N)

                                python3 score.py $id $name
                                
                end=$(date +%s.%N)  
                runtime=$(python -c "print(${end} - ${start})")
                echo "Final scores runtime was $runtime for $item"
                        
                            else
                                echo 'skip'
                            fi
                        
                        else
                            echo 'skip'
                            
                        fi
                    done
                done