import ROOT
from array import array
from ROOT import TMath
from ROOT import TH1, TH1F, TF1, TLine, TFile, TCanvas
import math
import numpy as np

B1File = TFile.Open('/user/pmehta/lentp_numu.ncgamma_flux13a_neut533.050.root', 'READ')
B1Tree = B1File.h1
H1 = ROOT.TH1F()
B1Tree.Draw("pos>>H1")
B1Hist = ROOT.gDirectory.Get("H1")
B1Hist.GetXaxis().SetLimits(-2000, 2000)
B1Hist.GetYaxis().SetLimits(0, 45)
#B1Hist.DrawNormalized()

H2 = ROOT.TH1F()
B1Tree.Draw("posv>>H2")
B2Hist = ROOT.gDirectory.Get("H2")
B2Hist.GetXaxis().SetLimits(-2000,2000)
B2Hist.GetYaxis().SetLimits(0, 45)


B3Hist = B1Hist.Clone("B3Hist")
B3Hist.SetDirectory(0)
B3Hist.Add(B2Hist, -1)
B3Hist.SetTitle("pos - posv")
#B3Hist.Draw()


numbins = B3Hist.GetXaxis().GetNbins()
print numbins

binwidth = 4000/numbins
print binwidth

bincont = B3Hist.GetBinContent(93)
print bincont 

firstbin = B3Hist.FindFirstBinAbove(0)
print firstbin

lastbin = B3Hist.FindLastBinAbove(0)
print lastbin

B4Hist = ROOT.TH1F("B4Hist","|pos-posv|",numbins, -2000,2000)

c =  ROOT.TCanvas("c", "|pos-posv|")
for i in np.arange(0, 100, 1):

  v = B3Hist.GetBinContent(i)
  print v
  B4Hist.SetBinContent(i,abs(v))

B4Hist.Draw()
c.Update()
