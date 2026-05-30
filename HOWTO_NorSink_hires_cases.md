# How to create and run high-resolution NorESM/CTSM cases for NorSink

## Content and related documents

This document gives concise instructions on how to set up and run cases in
NorESM/CTSM to use the high-resolution grid and corresponding input data that
were created for the NorSink project in 2025/2026.

For a detailed description on how the grid and input data were created and can
be reproduced, see
[README\_NorSink\_hires\_inputdata.md](./README_NorSink_hires_inputdata.md).


## How to create and run a case

### Overall
To create and/or run a new case, make a copy of the example run script in
[NorSink\_hires\_runsript\_template.sh](NorSink_hires_runsript_template.sh),
rename and modify the content as needed, and run it in the parent directory
under which you want the new case directory to be placed.

### Items that should be reviewed and modified

You should review and potentially modify the following items in each new script
and for each run:

1. Variables `dosetup` through `forcenewcase` near the top: Set to the values
   you need based on what you want to do.
1. `USER`: Set to you own username
1. `project`: Change if needed
1. `remoterepourl`: Check that this is equal to the URL of the CTSM fork that
   you want to use (probably the repo that this file is in).
1. `noresmversion`: Change to the tag name in the CTSM repo that you want to run
   with.
1. `noresmclonedir`: Change this iff you need the cloned local repo directory to
   have a different name than the CTSM tag you want to run with.
1. `casename`: Change this if you use a setup that isn't reflected in the
   current casename template string (otherwise it gets set automatically based
   on `noresmversion`).
1. `workpath`: Change this if you need to put the cloned repos and case
   directories in a different location than the default.
1. Lines under `#XML changes` and `#Add following lines to user_nl_clm`: Change
   or add lines here to set the XML settings and namelist items that you need
   for your case.
