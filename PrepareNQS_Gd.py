#!/usr/local/bin/python2.7
#use ProcessNCEL_mc.sh

import os, sys, stat
from os.path import expandvars, join
from glob import glob
from collections import defaultdict
from optparse import OptionParser

#subfile = "nqs_list_allmc_fhc"
#scriptdir = expandvars("$PWD/nqs_fhc")
#here = os.environ["PWD"]

#if not os.path.exists(scriptdir):
#    os.makedirs(scriptdir)

#batchdir = "/disk01/usr5/assy/batchlogs"
#batchdir = "/disk02/usr6/pmehta/batchlogs_fhc"

#if os.path.exists(batchdir):
#    print "scriptdir is %s" %(batchdir)
#else :
#    cmd = "mkdir %s" %(batchdir)
#    print cmd
#    os.system(cmd)
#    print "scriptdir is %s" %(batchdir)

#print "Shell file is %s" %subfile
#fsub = open(subfile,'w')

permission = stat.S_IRWXU | stat.S_IRGRP | stat.S_IXGRP

#for particle in ["nuebar", "numubar"]:
#for particle in [ "numu", "numubar", "nue" ]:
for mode in ["fhc", "rhc"]:
    subfile = "nqs_list_allmc_"+mode+"_gd"
    fsub = open(subfile,'w')
    for particle in [ "numu", "numubar", "nue", "nuebar" ]:
        for n in range(100):
            num = "{0:03d}".format(n)
            #subfile = "nqs_list_allmc_"+mode
            scriptdir = expandvars("/disk02/usr6/pmehta/ncgamma/Processing/nqs_"+mode+"_gd")
            scriptname = "_".join(["nqs","ncel",particle,num,mode])+"_gd.sh"
            scriptname = join(scriptdir, scriptname)
            fscript = open(scriptname,'w')
            print >>fscript, "#!/bin/tcsh" 
            print >>fscript, "#" 
            print >>fscript, "# Batch mode using NQS" 
            print >>fscript, "#" 
            print >>fscript, ""
            #  print >>fscript, "source /disk01/usr5/assy/ncgamma/skenv_py.csh"
            print >>fscript, "source /disk02/usr6/pmehta/ncgamma/skenv_py.csh"
            print >>fscript, expandvars("$PWD/ProcessNCEL_mc_Gd_test.sh"),num,particle,mode
            #print >>fscript, expandvars("$PWD/ProcessNCEL.sh"),num,particle
            print >>fscript, ""
            fscript.close()
            os.chmod(scriptname, permission)
            log = expandvars("/disk02/usr6/pmehta/batchlogs_"+mode+"_gd/ncel_")+particle+"_"+num+"_"+mode+".log"
            print >>fsub, "qsub -q ALL -eo -o", log, scriptname
    fsub.close()
cmd = "chmod 751 %s" %(subfile)
os.system(cmd)
print "Finish......"
        
#fsub.close()

