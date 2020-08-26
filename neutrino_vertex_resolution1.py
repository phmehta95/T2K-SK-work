import ROOT
import os
from array import array
from ROOT import TMath
from ROOT import TH1, TH1F, TF1, TLine, TFile, TCanvas
import math
import numpy as np

file = ROOT.TFile('/user/pmehta/lentp_numu.ncgamma_flux13a_neut533.050.Gd.root')
tree = file.Get("h1")
nev = tree.GetEntries()
print nev

#for event in tree:
#   print(tree.posv)

VariableTree = ROOT.TTree("VariableTree","VariableTree")
#pos_recon = ROOT.std.vector('double')()             ; VariableTree.Branch("pos_recon",pos_recon)
#pos_true = ROOT.std.vector('double')()             ; VariableTree.Branch("pos_true",pos_true)
diff =  ROOT.std.vector('double')()             ; VariableTree.Branch("diff",diff)
#resolution = tree.Branch("xyzdiff",xyzdiff,"xyzdiff/F")
res = ROOT.TH1F("res","res",100, 0,800)
###Read pos and posv into two TTrees and extract x =[0], y=[1] and z = [2] coordinates, work out distance using 3D trig, fill in new histogram called res with the values
for i in np.arange(0,nev,1):
   tree.GetEntry(i)
   pos1 = tree.pos
   pos2 = tree.posv
   
   pos1x = pos1[0] 
   pos1y = pos1[1] 
   pos1z = pos1[2]
   
   pos2x = pos2[0]
   pos2y = pos2[1]
   pos2z = pos2[2]

   x_diff = abs(pos1x - pos2x)
   y_diff = abs(pos1y - pos2y)
   z_diff = abs(pos1z - pos2z)
   
   xyzdiff = math.sqrt((x_diff*x_diff)+(y_diff*y_diff)+(z_diff*z_diff))
   #print xyzdiff
   #print nev
   diff.push_back(xyzdiff)
   res.Fill(xyzdiff)
   

#VariableTree.Fill()
res.Draw()

####Work out 1sigma quantile of distribution and print x value
nq = 1
prob = np.array([0.68])
yq = np.array([0.])

#for i in xrange(nq):
#        prob[i] = float(i + 1) / nq

res.GetQuantiles(1,yq,prob)
print yq 

