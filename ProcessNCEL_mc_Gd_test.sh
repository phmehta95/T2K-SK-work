#!/bin/bash

neut_ver=533
flux_ver=13a
#mode=1  # 1: FHC, -1: RHC

export LANG=en_US
export num=$1
export particle=$2
export mode=$3

if [ "$mode" == "fhc" ]
then
   # export odir=/disk02/usr6/pmehta/lemc/flux.13anom.run1to9.fhc_neut.533.modified_skdetsim.dwallm50.gcalor
    export odir=/disk02/usr6/pmehta/lemc_Gd/flux.13anom.run1to9.fhc_neut.533.modified_skdetsim.dwallm50.gcalor_Gd #SKDETSIM GD output directory 
    #export odir=/home/kmtsui/test_dir
    export vecdir=/disk02/usr6/pmehta/neutfile/flux.13anom.run1to9.fhc_neut.533.modified/select
    
elif [ "$mode" == "rhc" ]
then
    #export odir=/disk02/usr6/pmehta/lemc/flux.13anom.run1to9.rhc_neut.533.modified_skdetsim.dwallm50.gcalor
    export odir=/disk02/usr6/pmehta/lemc_Gd/flux.13anom.run1to9.rhc_neut.533.modified_skdetsim.dwallm50.gcalor_Gd #SKDETSIM GD output directory
    export vecdir=/disk02/usr6/pmehta/neutfile/flux.13anom.run1to9.rhc_neut.533.modified/select
fi
     
#export odir=/disk01/usr5/assy/lemc/${neut_ver}
#export odir=/disk01/usr5/assy/lemc/flux.13anom.run1to9.fhc_neut.533.modified_skdetsim.dwallm50.gcalor
#export odir=/disk01/usr5/assy/lemc/flux.13anom.run1to9.rhc_neut.533.modified_skdetsim.dwallm50.gcalor
#export odir=/disk01/usr5/assy/lemc/flux.13anom.run1to9.rhc_neut.533.p3over2.increased_skdetsim.dwallm50.gcalor
#export odir=/disk01/usr5/assy/lemc/flux.13anom.run1to9.rhc_neut.533.others.as.p1over2_skdetsim.dwallm50.gcalor
#export odir=/disk01/usr5/assy/lemc/flux.13anom.run1to9.fhc_neut.533.modified.fsi0.7times_skdetsim.dwallm50.gcalor
#export odir=/disk01/usr5/assy/lemc/decaye_test
#export odir=/disk02/usr6/pmehta/lemc/flux.13anom.run1to9.fhc_neut.533.modified_skdetsim.dwallm50.gcalor

#export vecdir=/disk01/usr5/assy/neutfile/${neut_ver}/select
#export vecdir=/disk01/usr5/assy/neutfile/flux.13anom.run1to9.fhc_neut.533.modified/select
#export vecdir=/disk01/usr5/assy/neutfile/flux.13anom.run1to9.rhc_neut.533.modified/select
#export vecdir=/disk01/usr5/assy/neutfile/flux.13anom.run1to9.rhc_neut.533.p3over2.increased/select
#export vecdir=/disk01/usr5/assy/neutfile/flux.13anom.run1to9.rhc_neut.533.others.as.p1over2/select
#export vecdir=/disk01/usr5/assy/neutfile/flux.13anom.run1to9.fhc_neut.533.modified.fsi0.7times/select
#export vecdir=/disk02/usr6/pmehta/neutfile/flux.13anom.run1to9.fhc_neut.533.modified/select


#export ncgdir=/disk01/usr5/assy/ncgamma
export ncgdir=/disk02/usr6/pmehta/ncgamma
export soft=${ncgdir}/mc

# Make parent directories if they don't exist
for dir in log lowfit detsim lentuple; do
    [ ! -d $odir/$dir ] && mkdir -p $odir/$dir
done



export log=$odir/log/ncel_${particle}_${num}.log
if [ -e $log ]; then
    echo | tee -a  $log
    echo | tee -a  $log
    echo | tee -a  $log
    echo "!!!!!!Starting new job here!!!!!!" | tee -a  $log
else
    touch $log
fi

DO_DETSIM=true
DO_LOWFIT=true
DO_DUMMY=true
DO_NTUPLE=true
DO_NTAG=true
DO_RW=false


export id=$particle.ncgamma_flux${flux_ver}_neut${neut_ver}.$num






echo                   | tee -a  $log
echo "===============" | tee -a  $log
echo "==== Begin ====" | tee -a  $log
echo "===============" | tee -a  $log
date                   | tee -a  $log

export tmp="/work/pmehta/$id.$$"
[ ! -d $tmp ] && mkdir -p -v $tmp  | tee -a  $log
if [ ! -d $tmp ]; then
    echo "Cannot create $tmp:"     | tee -a  $log
    echo "ls -l /work"             | tee -a  $log
    ls -l /work                    | tee -a  $log
    export tmp="/home/pmehta/net/temp/$id"
    [ ! -d $tmp ] && mkdir -p -v $tmp | tee -a  $log
fi
cd $tmp
pwd                                | tee -a  $log
#source ~ahimmel/skenv.sh           | tee -a  $log
echo "here is processNCEL_mc_gd echo"
source ${ncgdir}/skenv_py.sh   | tee -a  $log

env
uname -a                           | tee -a  $log
echo $LANG                         | tee -a  $log


export part=""
[ $particle == "numu" ] && export part="num"
[ $particle == "numubar" ] && export part="nmb"
[ $particle == "nue" ] && export part="nue"
[ $particle == "nuebar" ] && export part="neb"
if [[ X$part == X ]]; then
    echo "Did not recognize particle=$particle, bailing."
    exit 1
fi





echo                    | tee -a  $log
echo "================" | tee -a  $log
echo "==== DetSim ====" | tee -a  $log
echo "================" | tee -a  $log
date                    | tee -a  $log

#export card=$soft/skdetsim/sample.card
export card=$soft/skdetsim-skgd/sample.card #SKDETSIM-SKGD CARD 

export f_ds_vec=$vecdir/$part.h2o.sk.flux${flux_ver}.neut_${neut_ver}.$num.dat
export f_ds_hbk=detsim_$id.hbk
export f_ds_out=detsim_$id.zbs
export f_ds_dir=$odir/detsim

if $DO_DETSIM; then
    [ ! -e $f_ds_vec ] && echo "Missing input file $f_ds_vec, bailing" && exit 2
    [ ! -d $f_ds_dir ] && mkdir -p $f_ds_dir

    source /usr/local/sklib_gcc4.8.5/geant4.9.6.p04/bin/geant4.sh
    source /usr/local/sklib_gcc4.8.5/geant4.9.6.p04/share/Geant4-9.6.4/geant4make/geant4make.csh 
    export G4NEUTRONHPDATA="/usr/local/sklib_gcc4.8.5/geant4.9.6.p04/share/Geant4-9.6.4/data/G4NDL4.2"
    #export G4WORKDIR=$soft/skdetsim-skgd//geant4_work/
    export G4WORKDIR=$soft/skdetsim-skgd/geant4_work/
    export G4TMPDIR="${G4WORKDIR}/tmp/"
    export G4NEUTRONHP_USE_ONLY_PHOTONEVAPORATION=1
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${G4TMPDIR}/Linux-g++/gtneut/
    export RANFILE="/home/atmpd/skdetsim/skdetsim-v13p90_for_atmnu_test/random.tbl.000"
    
    # Geant 4 data
    #export g4top=/usr/local/sklib_gcc4.8.5/geant4.9.6.p04
    #xport g4ver=Geant4-9.6.4
    #export G4LEDATA=${g4top}/share/${g4ver}/data/G4EMLOW6.32
    #export G4LEVELGAMMADATA=${g4top}/share/${g4ver}/data/PhotonEvaporation2.3
    ##export G4NEUTRONHPDATA=${g4top}/share/${g4ver}/data/G4NDL4.2
    #export G4NEUTRONXSDATA=${g4top}/share/${g4ver}/data/G4NEUTRONXS1.2
    #export G4PIIDATA=${g4top}/share/${g4ver}/data/G4PII1.3
    #export G4RADIOACTIVEDATA=${g4top}/share/${g4ver}/data/RadioactiveDecay3.6
    #export G4REALSURFACEDATA=${g4top}/share/${g4ver}/data/RealSurface1.0
    #export G4SAIDXSDATA=${g4top}/share/${g4ver}/G4SAIDDATA1.1
    # Geant 4 libraries
    #export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}/usr/local/sklib_gcc4.8.5/geant4.9.6.p04/lib64:
    #export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}/disk02/usr6/pmehta/ncgamma/mc/skdetsim-skgd/geant4_work/tmp/Linux-g++/gtneut:
    #export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}/usr/local/geant4.10/geant4.10.03.p02/lib64:
    #/disk02/usr6/pmehta/ncgamma/mc/skdetsim-skgd/geant4_work/tmp/Linux-g++/gtneut
    #echo "LD_LIBRARY_PATH = "$LD_LIBRARY_PATH
    


    cd $soft/skdetsim-skgd/

    
    echo "$soft/skdetsim-skgd/skdetsim $card $((num)) $f_ds_vec $f_ds_out $f_ds_hbk" | tee -a  $log
    #$soft/skdetsim/skdetsim $card $num $f_ds_vec $f_ds_out $f_ds_hbk        | tee -a  $log
    $soft/skdetsim-skgd/skdetsim $card $f_ds_out $f_ds_vec         | tee -a  $log #SKDETSIM SK-GD #standard skdetsim I/O
    echo | tee -a  $log

    mv $f_ds_hbk $tmp
    mv $f_ds_out $tmp
    cd $tmp
    cp -v $f_ds_hbk   $f_ds_dir | tee -a  $log
    cp -v $f_ds_out   $f_ds_dir | tee -a  $log
     
    
    
#else
#    echo "Restoring previous detsim"         | tee -a  $log
#    uenofile=t2k.flux${flux_ver}.neut_${neut_ver}.$part.piabs.$num.zbs
#    cp -v $f_ds_dir/$uenofile $f_ds_out      | tee -a  $log
fi







echo                    | tee -a  $log
echo "================" | tee -a  $log
echo "==== Lowfit ====" | tee -a  $log
echo "================" | tee -a  $log
date                    | tee -a  $log


export f_lf_in=$f_ds_out
export f_lf_out=lowfit_$id.zbs
export f_lf_dir=$odir/lowfit
export f_lf_hbk=$lowfit_$id.hbk

if $DO_LOWFIT; then
    [ ! -e $f_lf_in ] && echo "Missing input file $f_lf_in, bailing" && exit 3
    [ ! -d $f_lf_dir ] && mkdir -p $f_lf_dir

    echo $LD_LIBRARY_PATH
    echo $ROOTSYS
    
    #exe=$soft/lowfit/lowfit_sk4_zbs 
    exe=$ncgdir/lowfit/lowfit_t2k_mc
    
    #echo $exe $num $f_lf_hbk $f_lf_out $f_lf_in | tee -a  $log
    #$exe $num $f_lf_hbk $f_lf_out $f_lf_in      | tee -a  $log

    echo $exe $f_lf_in $f_lf_out | tee -a  $log
    $exe $f_lf_in $f_lf_out      | tee -a  $log

    echo                         | tee -a  $log

#    cp -v $f_lf_out $f_lf_dir    | tee -a  $log
#else
#    echo "Restoring previous lowfit"  | tee -a  $log
#    cp -v $f_lf_dir/$f_lf_out .       | tee -a  $log
fi


echo                    | tee -a  $log
echo "================" | tee -a  $log
echo "==== Dummy  ====" | tee -a  $log
echo "================" | tee -a  $log
date                    | tee -a  $log


# When dummy is after lowfit
export f_dds_dir=$odir/dummydetsim
export f_dds_idx=/disk02/usr6/pmehta/ncgamma/mccomb/work/index/${mode}/$particle.dummyidx.$num.txt
export tbkgduration=496000 # back-up safety useconds: 1 usec at bgn, 1 usec at end
export tbkginsert=18000
export f_dds_in=$f_lf_out
export f_dds_out=dumdetsim_$id.zbs
export f_dds_sbi=dumdetsim_$id.sbi
export exe=/disk02/usr6/pmehta/ncgamma/injedgedbl/dummyinj.csh
if $DO_DUMMY; then
    [ ! -e $f_dds_int ] && echo "Missing input file $f_dds_in, bailing" && exit 2
    [ ! -d $f_dds_dir ] && mkdir -p $f_dds_dir

    echo "$exe $f_dds_idx $tbkgduration $tbkginsert $f_dds_in $f_dds_out $f_dds_sbi" | tee -a $log
    $exe $f_dds_idx $tbkgduration $tbkginsert $f_dds_in $f_dds_out $f_dds_sbi | tee -a $log

    echo | tee -a  $log


    #    cp -v $f_ds_hbk   $f_ds_dir | tee -a  $log  # Not to be used in case of non-hbk output
    #cp -v $f_dds_out   $f_dds_dir | tee -a  $log  # Comment / uncomment for pipelined or not process
    #cp -v $f_dds_sbi  $f_dds_dir  | tee -a  $log
else
    # Commented 17/06/2019
    #echo "Restoring previous detsim"         | tee -a  $log
    #uenofile=t2k.flux${flux_ver}.neut_${neut_ver}.$part.piabs.$num.zbs
    #cp -v $f_ds_dir/$uenofile $f_ds_out      | tee -a  $log
    echo "Comment of 17/06/2019"
fi




echo                       | tee -a  $log
echo "===================" | tee -a  $log
echo "==== LE Ntuple ====" | tee -a  $log
echo "===================" | tee -a  $log
date                       | tee -a  $log


export f_ntp_in=$f_lf_out
export f_ntp_out=lentp_$id.root
export f_ntp_dir=$odir/lentuple

if $DO_NTUPLE; then
    [ ! -e $f_ntp_in ] && echo "Missing input file $f_ntp_in, bailing" && exit 3
    [ ! -d $f_ntp_dir ] && mkdir -p $f_ntp_dir
    
    #exe=$ncgdir/make_ntuple/make_t2klowe_ntuple
    #exe=/disk02/usr6/pmehta/ncqeana/tools/lentuple/make_t2klowe_ntuple
    exe=/disk02/usr6/pmehta/ncgamma/tq_lentuple/make_t2klowe_ntuple
    echo $RFLIST
    
    # proper way ... 
    #echo $exe -v -i $f_ntp_in -o $f_ntp_out | tee -a  $log
    #$exe -v -i $f_ntp_in -o $f_ntp_out      | tee -a  $log

    # temporary way to solve memory leak problem ...
    #valgrind --leak-check=full $exe -v -i $f_ntp_in -o $f_ntp_out | tee -a  $log
    $exe -i $f_ntp_in -o $f_ntp_out | tee -a  $log
    
    echo                                    | tee -a  $log
    cp -v $f_ntp_out $f_ntp_dir             | tee -a  $log
#else
   # echo "Restoring previous ntuple"        | tee -a  $log
   # cp -v $f_ntp_dir/$f_ntp_out .           | tee -a  $log   
fi




echo                         | tee -a  $log
echo "=====================" | tee -a  $log
echo "==== T2KReWeight ====" | tee -a  $log
echo "=====================" | tee -a  $log
date                         | tee -a  $log

#export f_banff=$HOME/ana/T2K/banff/postfit/postfit_banff_v7_osc_marg.root
#export f_banff=$HOME/ana/T2K/banff/postfit/postfit_banff_2013_appearance_v0.root

if $DO_RW; then
    #source ~ahimmel/skenv.sh
    #source ${ncgdir}/T2KReWeight/env.sh  
    source ${ncgdir}/skenv_py.sh
    source ${ncgdir}/T2KReWeight_v1r27p3/env.sh
    
    echo $LD_LIBRARY_PATH

    #exe=$ncgdir/T2KReWeight/genWeights_2012a.exe
    #exe=$ncgdir/T2KReWeight/genWeights_ncgamma.exe
    exe=$ncgdir/T2KReWeight_v1r27p3/app/genWeights_SK_2016.exe

    #BANFF=/home/ahimmel/ana/T2K/banff/postfit/postfit_banff_v7_osc_marg.root
    #BANFF=$ncgdir/mc/DataFit_Postfit_1p1h_mirror_MAQEH_PionSI_170614_sk.root
    BANFF=$ncgdir/mc/ncqe_run1to9_for_t2kreweight.root

    export f_rw_in=$f_ntp_out
    [ ! -e $f_rw_in ] && echo "Missing input file $f_rw_in, bailing" && exit 3

    #for wgt in flux_prefit xsec_prefit; do
    for wgt in xsec_prefit; do

        export f_rw_out=${wgt}.$f_rw_in

        #export f_rw_dir=$odir/weights_postfit_banff_v7/${wgt}
        export f_rw_dir=$odir/weights_prefit_banff/${wgt}
	
	[ ! -d $f_rw_dir ] && mkdir -p $f_rw_dir
        
        prefit=""
        drop=""
        [[ $wgt == *_prefit ]] && prefit="--use-prefit"
        [[ $wgt == flux* ]]    && drop="--drop-xsec"
        [[ $wgt == xsec* ]]    && drop="--drop-flux"
    
        #echo $exe -i $f_rw_in -o $f_rw_out -t 500 -p $BANFF $prefit $drop  | tee -a  $log
        #$exe -i $f_rw_in -o $f_rw_out -t 500 -p $BANFF $prefit $drop       | tee -a  $log
        echo $exe -i $f_rw_in -p $BANFF -o $f_rw_out -horn $mode -app 0 -t 500 $prefit $drop  | tee -a  $log
	$exe -i $f_rw_in -p $BANFF -o $f_rw_out -horn $mode -app 0 -t 500 $prefit $drop   | tee -a  $log
	echo                                                                              | tee -a  $log

        cp -v $f_rw_out $f_rw_dir                                                         | tee -a  $log
    done 

    #exe=$ncgdir/T2KReWeight/genWeightsNC_NIWG.exe 
    #wgt=niwg
    #export f_rw_out=${wgt}.$f_rw_in
    #export f_rw_dir=$odir/weights_postfit_banff_v7/${wgt}/
    #[ ! -d $f_rw_dir ] && mkdir -p $f_rw_dir
    #
    #echo $exe -i $f_rw_in -o $f_rw_out -t 500 | tee -a $log
    #$exe -i $f_rw_in -o $f_rw_out -t 500      | tee -a $log
    #echo                                      | tee -a $log
    #
    #cp -v $f_rw_out $f_rw_dir                 | tee -a  $log
fi


cd ..
rm -r $tmp

