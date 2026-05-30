#!/bin/bash

#Template script to clone, build and run NorESM CTSM on Betzy with the high-resolution NorwayRect_0.1x0l.1 grid for Norway and parts of Fennoscandia.
#
#This file was originally copied and modified from the following: <https://github.com/kjetilaas/Run_NorESM_script/blob/d2f48d99d68be7e3e87a5643841419d5da108ab2/Feb26/Fates_test_Nordic_region.sh>

dosetup1=1 #do first part of setup
dosetup2=1 #do second part of setup (after first manual modifications)
dosetup3=1 #do second part of setup (after namelist manual modifications)
dosubmit=1 #do the submission stage
forcenewcase=1 #scurb all the old cases and start again

echo "setup1, setup2, setup3, submit, forcenewcase:", $dosetup1, $dosetup2, $dosetup3, $dosubmit, $forcenewcase

USER="janko"  # Change this to your own user name
project='nn9188k' #nn8057k: EMERALD, nn2806k: METOS, nn9188k: CICERO, nn9560k: NorESM (INES2), nn9039k: NorESM (UiB: Climate predition unit?), nn2345k: NorESM (EU projects)
machine='betzy'  # Using with any other machine will require creating the same file structures on the new machine.

#Remote repo
remoterepourl="https://github.com/ciceroOslo/CTSM_norsink_hires_inputdata.git"

#NorESM dir
noresmversion="norsink_inputdata_main"   # Name of the branch or tag to use from the remote repo
noresmclonedir="${noresmversion}"  # Name of the directory that the script will clone the relevant tag of the NorESM repo. By default set equal to the ref that is checked out. You can set it to something else, but if you later change `noresmversion`, you must either set `noresmclonedir` also to a new value, or delete, move or rename the existing cloned directory. The code below will just use the directory if it exists, and not check whether the right branch, tag or commit is checked out.

resolution="a%NorwayRect_0.1x0.1_l%NorwayRect_0.1x0.1_r%r05_g%null_oi%null_w%null_z%null_m%NorwayRect_0.1x0.1"  # This resolution value directs NorESM to use the high-res grid for the land model, data atmosphere and for the mask, the default for the river model, and null (stubs) for the rest.
casename="i1850.Nordic.$noresmversion.intel.`date +"%Y-%m-%d"`"
echo "casename: $casename"
compset="1850_DATM%CLMERA5LAND-NORWAYRECT_CLM60%FATES-NOCOMP_SICE_SOCN_MOSART_SGLC_SWAV"  # Here, `DATM%CLMERA5LAND-NORWAYRECT` is needed to use the high-resolution forcing data set, and what the land model parth must start with either `CML60%` or `CLM50%` (only `CLM60`) has been properly tested. For the river model, only `MOSART` has been tested and confirmed to work. Adjust other parts as needed.

# aka where do you want the code and scripts to live?
workpath="/cluster/work/users/$USER/"

# some more derived path names to simplify scripts
scriptsdir="$workpath$noresmclonedir/cime/scripts/"

#case dir
casedir="$workpath$casename"

#where are we now?
startdr="$(pwd)"

#Download code and checkout externals
if [ $dosetup1 -eq 1 ]
then
    cd "$workpath"

    pwd
    #go to repo, or checkout code
    if [[ -d "$noresmclonedir" ]]
    then
        cd "$noresmclonedir"
        echo "Already have NorESM repo"
    else
        echo "Cloning NorESM"


        echo "Using CTSM version $noresmversion"
        git clone "$remoterepourl" "$noresmclonedir"
        cd "$noresmclonedir"
        git checkout "$noresmversion"
        ./bin/git-fleximod update
        echo "Built model here: $workpath$noresmclonedir"

    fi
fi

#Make case
if [[ $dosetup2 -eq 1 ]]
then
    cd $scriptsdir

    if [[ $forcenewcase -eq 1 ]]
    then
        if [[ -d "$workpath$casename" ]]
        then
        echo "$workpath$casename exists on your filesystem. Removing it!"
        rm -rf "$workpath$casename"
        rm -r "$workpath/noresm/$casename"
        rm -r "$workpath/archive/$casename"
        rm -r "$casename"
        fi
    fi
    if [[ -d "$workpath$casename" ]]
    then
        echo "$workpath$casename exists on your filesystem."
    else

        echo "making case:" $workpath$casename
        ./create_newcase --case "$workpath$casename" --compset "$compset" --res "$resolution" --project "$project" --run-unsupported --mach betzy --pecount 2048 --compiler intel --debug

        cd "$workpath$casename"
        #XML changes. Adjust this as needed for your case.
        echo 'updating settings'
        ./xmlchange --subgroup case.run JOB_WALLCLOCK_TIME=48:00:00
        ./xmlchange --subgroup case.st_archive JOB_WALLCLOCK_TIME=00:30:00
        ./xmlchange CLM_FORCE_COLDSTART=on
        ./xmlchange STOP_OPTION=nmonths
        ./xmlchange STOP_N=12
        ./xmlchange RUN_STARTDATE=2019-01-01
        ./xmlchange DATM_YR_START=2019
        ./xmlchange DATM_YR_ALIGN=2019
        ./xmlchange DATM_YR_END=2019
        ./xmlchange REST_OPTION=nmonths
        echo 'done with xmlchanges'
        
        ./case.setup
        echo ' '
        echo "Done with Setup. Update namelists in $workpath$casename/user_nl_*"

        #Add following lines to user_nl_clm

    fi
fi

#Build case case
if [[ $dosetup3 -eq 1 ]] 
then
    cd "$workpath$casename"
    echo "Currently in" $(pwd)
    ./case.build
    echo ' '    
    echo "Done with Build"
fi

#Submit job
if [[ $dosubmit -eq 1 ]] 
then
    cd "$workpath$casename"
    ./case.submit
    echo " "
    echo 'done submitting'       
fi

#After it has finised:
# - copy to NIRD: https://noresm-docs.readthedocs.io/en/noresm2/output/archive_output.html
# - run land diag: https://github.com/NorESMhub/xesmf_clm_fates_diagnostic 
    # python run_diagnostic_full_from_terminal.py /nird/datalake/NS9560K/kjetisaa/i1850.FATES-NOCOMP-coldstart.ne30pg3_tn14.alpha08d.20250130/lnd/hist/ pamfile=short_nocomp.json outpath=/datalake/NS9560K/www/diagnostics/noresm/kjetisaa/
#Useful commands: 
# - cdo -fldmean -mergetime -apply,selvar,FATES_GPP,TOTSOMC,TLAI,TWS,TOTECOSYSC [ n1850.FATES-NOCOMP-AD.ne30_tn14.alpha08d.20250127_fixFincl1.clm2.h0.00* ] simple_mean_of_gridcells.nc
