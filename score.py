import pandas as pd
import sys, random, argparse, os, imp
import os



def get_args():
    parser = argparse.ArgumentParser(description="...",
         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
   
    parser.add_argument("ID", type=str, help="Input data directory")
    parser.add_argument("recording", type=str, help="Input data directory")
    print(' '.join(sys.argv))
    args = parser.parse_args()
#     args = check_args(args)
    return args



args = get_args()
ID = args.ID   
recording = args.recording 

def labelExtraction(x):
    if x[1]=='-':
        y=int(x[0])
    else:
        y=int(x[0]+x[1])
    return y


path='/dataroot/experiments/exp/resnet5/far_epoch20/xvector_scores/%s+%s'%(ID,recording)
scores=pd.read_csv(path,sep=' ',header=None, names=['var1','var2','score'])
scores.sort_values(by=['var2'], inplace=True)
scores[['c1']]=scores[['var1']].applymap(lambda x: labelExtraction(x)) 
# scores=scores.drop(columns=['var1'])
# scores=scores.drop('var1', axis=1)
uniq=scores['var2'].unique()
output=pd.DataFrame(columns = ['sample', 'result']) 
for i in range(len(uniq)):
    value=uniq[i]
    scores_value=scores[scores['var2']==value]
    scores_value.sort_values(by=['score'], inplace=True,ascending=False)
    pre=scores_value.iloc[0:4]['c1'].min()
    output = output.append({'sample' : value, 'result' : pre},  
                    ignore_index = True) 
output.to_csv('5s/result_%s_%s.csv'%(ID,recording))