from pydub import AudioSegment
from itertools import combinations
import sys, random, argparse, os, imp
import os

# python 2h.py '/dataroot/Baylor/S4' '20180328110801' '/dataroot/Baylor/S4/20180328110801' $size

def get_args():
    parser = argparse.ArgumentParser(description="Generate 2h audio "
        "Usage: augment_data_dir.py  <in-data-dir> <in-data wav> <out-data-dir> "
        "E.g., python 2h.py '/dataroot/Baylor/S4' '20180328110801.wav' '/dataroot/Baylor/S4/speech' 5",
         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
   
    parser.add_argument("InDir", type=str, help="Input data directory")
    parser.add_argument("Input", type=str, help="Input wav name")
    parser.add_argument("OutDir", type=str,help='output dir')
    parser.add_argument("num", type=float,help='length')
    print(' '.join(sys.argv))
    args = parser.parse_args()
#     args = check_args(args)
    return args



args = get_args()
OutDir = args.OutDir                     
Input=args.Input
InDir=args.InDir
num=int(args.num/3600) 
audio=AudioSegment.from_file(InDir+'/'+Input+'.wav')

for i in range(num):
#     every 1 hours
#     print("done")
    segment=audio[3600000*i:3600000*i+3600000]
    segment.export("%s/%s.wav"%(OutDir,i), format="wav")


