      BLOCK DATA
C--DATA INITIALIZATION FOR HYPOINV
      INCLUDE 'common.inc'

C--GENERAL PARAMETERS
      DATA GREETING
     2 /'1/2008 VERSION 1.2 (f77/g77 compiler)'/
      DATA PI,RDEG,LJUNK,LMULT /3.14159,57.2958,2*.FALSE./
      DATA NSTLET,NETLET,NCOMP,NSLOC,NSLOC2 /4,4*0/
      DATA LCOMP1,SUBMOD, CDOMAN,CPVERS /2*.FALSE.,'NC','01'/
C--FILES AND OUTPUT CONTROLS
      DATA LBSTA,LBCRU,LMAG,LSUM,LARC,LPRT,LERR,LAPP /10*.FALSE./
      DATA JCP,JCA,LEJCT,LREP /2*1,2*.TRUE./
      DATA KPRINT,JST,JST2,JST3 /3,1,0,0/
      DATA IH71S,IH71T,ISTFMT /3*1/
      DATA FORID,IE,IS /'(I10)',2*' '/
      DATA MAGFIL,SUMFIL,ARCFIL,PRTFIL,STAFIL,ATNFIL,CALFIL,DELFIL,
     2 PHSFIL,XMCFIL,FMCFIL,CRUFIL,BSTAFL,BCRUFL /11*' ',LM*' ',2*' '/
      DATA INFILE /5*' '/
C--MISCELLANEOUS DATA FOR THIS EVENT
      DATA CP1,CP2,CP3,FULNAM,RUNLAB,LP153 /5*' ',.TRUE./
C--TERMINATING LOCATION UPON CONVERGENCE
      DATA ITRLIM,DQUIT,DRQT /20,.04,.001/
C--ITERATION & DAMPING CONTROLS
      DATA DXFIX,DZMAX,DZAIR,DAMP,EIGTOL,RBACK,BACFAC,DXMAX,D2FAR
     2 /7.,30.,.5,.9,.012,.02,.6, 50.,250./
C--DURATION MAG CONSTANTS
      DATA FMA1,FMB1,FMZ1,FMD1,FMA2,FMB2,FMZ2,FMD2,FMBRK,FMF1,FMF2
     2 /-5.2,3.89,.013,.0037,-.905,2.026,.013,.0037,210.,2*0./
      DATA FMA1B,FMB1B,FMZ1B,FMD1B,FMA2B,FMB2B,FMZ2B,FMD2B,FMBRKB
     2 /-5.2,3.89,.013,.0037,-.905,2.026,.013,.0037,210./
      DATA LATEN,FMGN /.FALSE.,0./
      DATA MAGSEL,MAGSL2,MLOGA0,LCOWT, LNOFMC,LNOXMC /3*1,3*.TRUE./
      DATA DMA0,DMA1,DMA2,DMLI,DMZ,DMGN /-1.03,2.10,0.,.00268,0.,1./
      DATA NCPF1,NCPF2,COMPF1,COMPF2,LABF1,LABF2 /-1,0,40*'   ',2*' '/
      DATA NCPX1,NCPX2,COMPX1,COMPX2,LABX1,LABX2 /-1,0,40*'   ',2*' '/
      DATA DCOFM1,DBRKM1,DCOFM2,DBRKM2,ZCOFM,ZBRKM /6*0/
      DATA NFCM,CFCM,AFCM /0,10*' ',10*0./
      DATA NXCM,CXCM,AXCM /0,10*' ',10*0./
      DATA LXCH /.TRUE./
      DATA NXTYP1,IXTYP1, NXTYP2,IXTYP2 /0,3*0, 0,3*1/
      DATA IDUG,CDUG /-1,10*'   '/
C--THESE ARE THE CAL FACTORS FOR EACH ATTENUATION SETTING
C--IT APPEARS THAT: ATTEN = -20 * LOG(CAL) + 27
C--ALSO G = -LOG (CAL/3.95)
C--ATTENUATIONS:     0     6     12     18     24   30    36    42
      DATA CALSV/25.2, 11.65, 5.576, 2.795, 1.4, .702, .352, .176,
C  GAIN CORRECTION:-.80  -.47   -.15   +.15  +.45  +.75 +1.05 +1.35
C
C           48     54    60     66     72      78
     2 .0885, .044, .0222, .0111, .00557, .00279/
C          +1.65 +1.95 +2.25  +2.55  +2.85   +3.15

C--MISCELLANEOUS PARAMETERS
      DATA DISCUT,DISW1,DISW2 /50.,1.,3./
      DATA DISCU1,DISW11,DISW21 /50.,3.,6./
      DATA RMSCUT,RMSW1,RMSW2 /.16,1.5,3./
      DATA SWT,POS,ZTR,RDERR,ERCOF,NET,MINSTA,ITRDIS,ITRRES,ITRDI1
     2 /1.,1.75,7.,.15,1.,0,4,2*4,100/
      DATA LTBIG,ISTAT /.FALSE.,0/
      DATA IFDATE,IXDATE,ICDATE /3*0/
      DATA LKEEP, WTVALS /.TRUE.,1.,.75,.5,.25/
C--CRUST MODEL PARAMETERS
      DATA MAXMOD,MODDEF,MODTYP /1,1,LH*-1/
      DATA CRODE,MODALT /LM*'   ',LH*0/
      DATA NMOD,MODS,WMOD /1,1,0,0,3*0./
      DATA NNODE,MODH /0,NODMAX*0/
C--UNKNOWN STATIONS
      DATA NLUNK,LUNK,SUNK /0,10*' ',MAXUNK*' '/
C--INTERACTIVE PROCESSING
      DATA LSTFIL,NCBASE,LSTFOR,IEDFLG /'listfil.',12,'(A12)',1/
      DATA EXTPHS,EXTARC,EXTSUM,EXTPRT /'.phs','.arc','.sum','.prt'/
C--P MAGNITUDE PARAMETERS
      DATA LPMAG,LPPRT,LABP1,LABP2 /2*.FALSE.,2*' '/
      DATA NCPP1,NCPP2,COMPP1,COMPP2 /-1,0,20*'   '/
      DATA NCNTMM,CCNTMM,CNT2MM,CNT2MD,CLPRAT /0,10*' ',11*.04,0.4/
      DATA NPWM,CPWM,WPWM /0,10*' ',10*1./
      DATA LATYPP,PMA1,PMB1,PMA2,PMB2 /5, 0.,1., 0.,1./
C--YR 2000
      DATA L2000,ICENT,IAMPU /.FALSE.,1900,0/
C--DIGITIZER CODE TABLES
      DATA NDIG,DIGDEF,DIG1,DIG3 /0,' ',MAXDIG*' ',MAXDIG*'   '/
      END
