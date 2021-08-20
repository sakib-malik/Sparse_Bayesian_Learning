****About files****
'main_ogl.m' : It is the main file to run the program in case of no pruning of alpha's during 
learning phase.
'SBL_ogl.m': It is a function file used by 'main_ogl' to run the learning algorithm for MAP of weight vector
without pruning it.


'main_prun.m': It is the main file to run the program in case of pruning of alpha's during 
learning phase, as most of the alpha's becomes large during learning we forceffully make 
them zero, and mark as irrelevant.

'SBL_prun.m': it is the function file used by 'main_prun' to do the learning of MAP of weight.

****System req. and runtime****
Tested on 'MATLABR2020b'

Just Run 'main_ogl.m' (without pruning) or 'main_prun.m' (with pruning)

****output*****

- You will get an (M X 5) vector printed on console, where the i'th column represent the MAP of weight, when i'th noise variance is used.
- You will get a figure containing the plot for Average NMSE for each of the noise variance vs noise variance.  
