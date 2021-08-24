from pydub import AudioSegment
from itertools import combinations
import sys, random, argparse, os, imp
import os

# input /dataroot/Baylor/S4/new-20180323051456/speech/0.wav 
# output /dataroot/Baylor/S4/new-20180323051456/speech/0


def get_args():
    parser = argparse.ArgumentParser(description="Generate 2h audio "
        "Usage: augment_data_dir.py  <in-data-dir> <in-data wav> <out-data-dir> "
        "E.g., python 2h.py '/dataroot/Baylor/S4' '20180328110801.wav' '/dataroot/Baylor/S4/speech' 5",
         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
   
    parser.add_argument("Input", type=str, help="Input wav name")
    parser.add_argument("OutDir", type=str,help='output dir')
    parser.add_argument("name", type=str,help='name')
    print(' '.join(sys.argv))
    args = parser.parse_args()
#     args = check_args(args)
    return args



args = get_args()
OutDir = args.OutDir                     
Input=args.Input
name=args.name
audio=AudioSegment.from_file(Input)
N=int(audio.duration_seconds)

# i=start time
for i in range(N):
    segment=audio[1000*i:1000*i+5000]
#     output=segment+segment+segment+segment+segment
#     output.export("%s/%s-%s.wav"%(OutDir,name,i), format="wav")
    segment.export("%s/%s-%s.wav"%(OutDir,name,i), format="wav")


