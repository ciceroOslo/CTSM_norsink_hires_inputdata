# CTSM

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3739617.svg)](https://doi.org/10.5281/zenodo.3739617)

## Notice about fork for NorSink high-resolution grid and input data

**NB!** This repository is a fork of the CTSM component of NorESM, forked from
<https://github.com/NorESMhub/CTSM>. It was forked to contain custom changes
needed to create and use high-resolution grids for the NorSink project,
initially a 0.1x0.1 degree grid over Fennoscandia containing the Norwegian
mainland, referred to as "NorwayRect_0.1x0.1" or by similar names.

The main customizations are additions to XML files that enable using the grid
and associated data files in NorESM cases created with the `create_newcase`
command and subsequent commands in the CIME model run pipeline, and
configuration files and a small amount of custom code to create mesh and input
data files for the grid.

Step by step instructions that explain the changes that were made and how to use
the custom grid are given in the file
[README_NorSink_hires_inputdata.md](/README_NorSink_hires_inputdata.md).


## Overview and resources

The Community Terrestrial Systems Model.

This includes the Community Land Model of the Community Earth System Model.

For documentation, quick start, diagnostics, model output and
references, see

http://www.cesm.ucar.edu/models/cesm2.0/land/

and

https://escomp.github.io/CTSM/

For help with how to work with CTSM in git, see

https://github.com/ESCOMP/CTSM/wiki/Quick-start-to-CTSM-development-with-git

and

https://github.com/ESCOMP/ctsm/wiki/Recommended-git-setup

For support with model use, troubleshooting, etc., please use the [CTSM
forum](https://bb.cgd.ucar.edu/cesm/forums/ctsm-clm-mosart-rtm.134/) or other appropriate forum (e.g., for
infrastructure/porting questions) through the [CESM forums](https://bb.cgd.ucar.edu/cesm/).

To get updates on CTSM tags and important notes on CTSM developments
join our low traffic email list:

https://groups.google.com/a/ucar.edu/forum/#!forum/ctsm-dev

(Send email to ctsm-software@ucar.edu if you have problems with any of this)

## CTSM code management team

CTSM code management is provided primarily by:

Software engineering team:
- [Erik Kluzek](https://github.com/ekluzek)
- [Bill Sacks](https://github.com/billsacks)
- [Sam Levis](https://github.com/slevis-lmwg)
- [Adrianna Foster](https://github.com/adrifoster)
- [Sam Rabin](https://github.com/samsrabin)
- [Greg Lemieux](https://github.com/glemieux)
- [Ryan Knox](https://github.com/rgknox)

Science team:
- [Will Wieder](https://github.com/wwieder)
- [Dave Lawrence](https://github.com/dlawrenncar)
- [Danica Lombardozzi](https://github.com/danicalombardozzi)
- [Keith Oleson](https://github.com/olyson)
- [Sean Swenson](https://github.com/swensosc)
- [Peter Lawrence](https://github.com/lawrencepj1)
- Gordon Bonan

FATES Project:
- https://github.com/NGEET/fates?tab=readme-ov-file

Perturbed Parameter Experiment (PPE) Science team:
- [Katie Dagon] (https://github.com/katiedagon)
- [Daniel Kennedy] (https://github.com/djk2120)
- [Linnea Hawkins] (https://github.com/linniahawkins)