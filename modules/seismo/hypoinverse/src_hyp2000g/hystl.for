      SUBROUTINE HYSTL
C--CALLED BY HYPOINV TO LIST STATIONS & CRUST MODEL ON PRINT FILE.
      CHARACTER COMSTR*10,CURTIM*28, TYPSTR*3
      INCLUDE 'common.inc'
      DIMENSION PD(20)
      SAVE PD
      DATA PD /20*0./

C--CONTINUE ONLY IF STATIONS & OTHER DATA ARE TO BE PRINTED
      IF (.NOT.LPRT .OR. JST.EQ.0) RETURN

C--PRINT CURRENT DATE & TIME FIRST
      CALL HYTIME (CURTIM)
      WRITE (15,1000) GREETING, CURTIM,RUNLAB, CDOMAN,CPVERS
1000  FORMAT (' HYPOINVERSE 2000'/1X,A/' RUN ON ',A28,
     2 '  RUN LABEL=',A1/' PROCESSING DOMAIN=',A2,
     3 '  PROCESSING VERSION=',A2/)
      IF (JST.LT.2) GOTO 18

      IF (JST2.LT.1) GOTO 210
C--LIST THE BASIC STATION DATA
      M=MAXMOD
      IF (M.GT.2) M=2
      WRITE (15,1025) (CRODE(I),I=1,M)
1025  FORMAT (' STATIONS:',36X,A3,66X,A3)
      WRITE (15,1009)
1009  FORMAT (6X,'NAME NT COM LC CR  --LAT---  ---LON--- PDLY1 A',
     3 '  FCOR FWT FMC.EXPIRE  XCOR XWT PSWT  CAL ',
     2 ' CAL.EXPIRE PER TYP PDLY2')

C--LOOP TO DECODE PARAMETERS AND WRITE STATIONS
      DO 5 J=1,JSTA
        XLTM=ABS(JLATM(J)*.01)
        XLNM=ABS(JLONM(J)*.01)
        XMC=JXCOR(J)*.01
        FMC=JFCOR(J)*.01
        DO I=1,M
          PD(I)=.01*JPD(I,J)
        END DO
        IF (JLMOD(J)) THEN
          CTEMP='A'
        ELSE
          CTEMP=' '
        END IF
        PWT=.1*JPSWT(J)
        XWT=JXWT(J)*.1
        CWT=JFWT(J)*.1
        PER=JPER(J)*.1
        CAL=JCAL(J)*.001
        KTEMP=ABS(JLATD(J))
        KTEMP2=ABS(JLOND(J))
        IE=' '
        IS=' '
        IF (KTEMP.LT.0 .OR. XLTM.LT.0.) IS='S'
        IF (KTEMP2.LT.0 .OR. XLNM.LT.0.) IE='E'

C--OUTPUT ONE LINE FOR THIS STATION
C--CHOOSE MAIN OR EQUIVALENT LOCATION CODE
        WRITE (15,1001) 
     2  J,STANAM(J),JNET(J), JCOMP3(J),JSLOC(J),JCOMP1(J),
     2  STRMK(J),KTEMP,IS,XLTM, KTEMP2,IE,XLNM, PD(1),CTEMP,FMC,
     3  CWT,JFEXP(J),XMC,XWT,PWT, CAL,JCEXP(J), 
     4  PER,JTYPE(J),(PD(I),I=2,M)
     
1001    FORMAT (1X,I4,1X,A5,A2,1X, A3,1X,A2,1X,A1,
     2  A1,I4,A1,F5.2, I5,A1,F5.2, F6.2,1X,A1,F6.2,
     3  F4.1,I11,F6.2,F4.1,F5.2, F6.2,I11,
     4  F4.1,I3,1X,5F6.2)

5     CONTINUE

      IF (JST2.LT.2) GOTO 210
C--PRINT THE DELAYS FOR ALL MODELS IF THERE IS MORE THAN 1
      IF (MAXMOD.GT.1) THEN
        M=MAXMOD
        IF (M.GT.20) M=20
        WRITE (15,1026) (CRODE(I),I=1,M)
1026    FORMAT (/21X,20(3X,A3))
        WRITE (15,1017) (I,I=1,M)
1017    FORMAT(6X,'NAME NT COM C LC', 9(:,'  DLY',I1), 11(:,' DLY',I2))
        DO J=1,JSTA
          DO I=1,M
            PD(I)=.01*JPD(I,J)
          END DO
          WRITE (15,1018) J,STANAM(J),JNET(J),
     2    JCOMP3(J),JCOMP1(J),JSLOC(J), (PD(I),I=1,M)
1018      FORMAT (1X,I4,1X,A5,A2,1X, A3,1X,A1,1X,A2, 20F6.2)
        END DO
      END IF

      IF (MAXMOD.GT.20) THEN
        M=MAXMOD
        IF (M.GT.40) M=40
        WRITE (15,1026) (CRODE(I),I=21,M)
        WRITE (15,1027) (I,I=21,M)
1027    FORMAT (6X,'NAME NT COM C LC', 20(:,' DLY',I2))
        DO J=1,JSTA
          DO I=1,M-20
            PD(I)=.01*JPD(I+20,J)
          END DO
          WRITE (15,1018) J,STANAM(J),JNET(J),
     2    JCOMP3(J),JCOMP1(J),JSLOC(J), (PD(I),I=1,M-20)
        END DO
      END IF

210   IF (JST3.LT.1) GOTO 18
C--PRINT THE CRUSTAL MODELS, ONE AT A TIME
      DO 15 I=1,MAXMOD
      IF (MODTYP(I).EQ.-1) GOTO 15
      WRITE (15,1002) I,MODNAM(I)
1002  FORMAT (/' CRUST MODEL',I3,': ',A/)

C--LIST THE APPLICABLE REGIONS (NODES) IF MULTIPLE MODELS ARE IN USE
      IF (LMULT) THEN
        IF (I.EQ.MODDEF) THEN
          WRITE (15,1012)
1012      FORMAT (' THIS IS THE DEFAULT MODEL FOR UNASSIGNED REGIONS')
        ELSE

          WRITE (15,1024)
1024      FORMAT (' THE CIRCULAR REGIONS (NODES) DEFINED FOR THIS ',
     2    'MODEL ARE:'/' NODE  CENTER-LAT  CENTER-LON  MOD  ',
     3    'INNER-RADIUS  RING-WIDTH  OUTER-RADIUS')
          DO IZ=1,NNODE
            IF (I.EQ.MODH(IZ)) WRITE (15,1019) IZ,HLAT(IZ),HLON(IZ),
     2      MODH(IZ),RAD1(IZ),DRAD(IZ),RAD2(IZ)
1019        FORMAT (I4,F11.4,F13.4,I5,F11.2,2F13.2)
          END DO
        END IF

        WRITE (15,1013)
1013    FORMAT (1X)
      END IF

C--SIGNAL IF THIS MODEL HAS AN ALTERNATE MODEL
      IF (MODALT(I).GT.0) WRITE (15,1016) MODALT(I),CRODE(MODALT(I))
1016  FORMAT (' SOME STATIONS USE MODEL',I3,' (',A3,
     2 ') INSTEAD OF THIS ONE.')

C--PRINT THE LAYER PARAMETERS FOR THE MODEL
C--HANDLE HOMOGENEOUS LAYER & LINEAR GRADIENT MODELS SEPERATELY
      IF (MODTYP(I).EQ.0) THEN
        WRITE (15,1003)
1003    FORMAT (' LINEAR GRADIENT MODEL WITH VELOCITIES SPECIFIED AT',
     2  ' THE FOLLOWING DEPTHS:')
      ELSE
        WRITE (15,1004)
1004    FORMAT (' HOMOGENEOUS LAYER MODEL WITH THE FOLLOWING',
     2  ' VELOCITIES AND LAYER TOPS:')
      END IF
      WRITE (15,1005)
1005  FORMAT (4X,'VELOCITY  DEPTH') 
      DO 10 J=1,LAY(I)
10    WRITE (15,1006) J,VEL(J,I),D(J,I)
1006  FORMAT (I3,2F8.3)
15    CONTINUE

C--PRINT THE COMPUTATIONAL PARAMETERS FOR THIS RUN
18    WRITE (15,1007)
1007  FORMAT (/' TEST PARAMETERS:'/'   -ITERATION AND CONVERGENCE-',
     2 5X,'-WEIGHTING AND ERRORS-     -MISCELLANEOUS-')

      WRITE (15,1008) ITRLIM,DAMP,DISCUT,RMSCUT,MINSTA,
     2 DQUIT,DRQT,DISW1,RMSW1,NET,
     3 DXFIX,EIGTOL,DISW2,RMSW2,
     4 DZMAX,RBACK,ITRDIS,ITRRES,ZTR,
     5 DZAIR,BACFAC,SWT,RDERR,POS,
     6 ERCOF
1008  FORMAT (
     1  I9,'=ITRLIM',F8.3,'=DAMP  ',F8.3,'=DISCUT',F8.3,'=RMSCUT',
     1  I8,'=MINSTA'/
     2 F9.3,'=DQUIT ',F8.3,'=DRQT  ',F8.3,'=DISW1 ',F8.3,'=RMSW1 ',
     2  I8,'=NET'/
     3 F9.3,'=DXFIX ',F8.3,'=EIGTOL',F8.3,'=DISW2 ',F8.3,'=RMSW2 '/
     4 F9.3,'=DZMAX ',F8.3,'=RBACK ',  I8,'=ITRDIS',  I8,'=ITRRES',
     4 F8.3,'=ZTR'/
     5 F9.3,'=DZAIR ',F8.3,'=BACFAC',F8.3,'=SWT   ',F8.3,'=RDERR ',
     5 F8.3,'=POS'/
     6 46X,                                        F8.3,'=ERCOF')

      WRITE (15,1014)
1014  FORMAT (/6X,'------DURATION MAG CONSTANTS------',7X
     2 ,'-DELAYS & MISC-    -STATIONS-')

      WRITE (15,1015) FMA1,FMA2, DMA0,LMULT,LATEN,
     2 FMB1,  FMB2,  DMA1,  LCOWT,  NSTLET,
     3 FMZ1,  FMZ2,  DMA2,  LJUNK,  NETLET,
     4 FMD1,  FMD2,  DMZ,            NCOMP,
     5 FMF1,  FMF2,  DMGN,
     6 FMGN,  FMBRK, DMLI,
     7 DCOFM1,DBRKM1,MLOGA0,
     7 DCOFM2,DBRKM2,
     8 ZCOFM, ZBRKM
1015  FORMAT (
     1 F9.3,'=FMA1  ',F8.3,'=FMA2  ',F8.4,'=DMA0  ',  L8,'=LMULT ',
     1   L8,'=ATTEN'/
     2 F9.3,'=FMB1  ',F8.3,'=FMB2  ',F8.4,'=DMA1  ',  L8,'=CODAWT',
     2   I8,'=SITE-LET'/
     3 F9.3,'=FMZ1  ',F8.3,'=FMZ2  ',F8.4,'=DMA2  ',  L8,'=LJUNK ',
     3   I8,'=NET-LET'/
     4 F9.3,'=FMD1  ',F8.3,'=FMD2  ',F8.4,'=DMZ   ',  15X,
     4   I8,'=COMP-LET'/
     5 F9.3,'=FMF1  ',F8.3,'=FMF2  ',F8.4,'=DMGN  '/
     6 F9.3,'=FMGN  ',F8.3,'=FMBRK ',F8.4,'=DMLIN '/
     7 F9.4,'=DCOF1 ',F8.3,'=DBRK1 ',  I8,'=LOGA0 '/
     7 F9.4,'=DCOF2 ',F8.3,'=DBRK2 '/
     8 F9.4,'=ZCOF  ',F8.3,'=ZBRK  ')

C--WRITE FMAG & XMAG COMPONENT CORRECTIONS
      IF (NFCM.GT.0) WRITE (15,1077) (CFCM(I),AFCM(I),I=1,NFCM)
1077  FORMAT(/'    DUR MAG COMPONENT CORRECTIONS:',10(2X,A3,'=',F4.2))
      IF (NXCM.GT.0) WRITE (15,1078) (CXCM(I),AXCM(I),I=1,NXCM)
1078  FORMAT ('    AMP MAG COMPONENT CORRECTIONS:',10(2X,A3,'=',F4.2))

C--WRITE MAGNITUDE LABELS AND COMPONENTS
C--FIRST FMAG
      IF (NCPF1.EQ.0) THEN
        COMSTR=' NO'
      ELSE IF (NCPF1.LT.0) THEN
        COMSTR='ALL'
      ELSE
        COMSTR='   '
      END IF
      WRITE (15,1040) LABF1,COMSTR, (COMPF1(I),I=1,NCPF1)
1040  FORMAT (/'    --- MAGNITUDE LABELS & COMPONENTS ---'/
     2 '    FMAG1: LABEL=',A1,2X,A3,' COMPS=',20(1X,A3))

C--SECOND FMAG
      IF (NCPF2.EQ.0) THEN
        COMSTR=' NO'
      ELSE IF (NCPF2.LT.0) THEN
        COMSTR='ALL'
      ELSE
        COMSTR='   '
      END IF
      WRITE (15,1041) LABF2,COMSTR, (COMPF2(I),I=1,NCPF2)
1041  FORMAT ('    FMAG2: LABEL=',A1,2X,A3,' COMPS=',20(1X,A3))

C--FIRST XMAG
C--CHOOSE BY COMPONENT
      IF (LXCH) THEN
        IF (NCPX1.EQ.0) THEN
          COMSTR=' NO'
        ELSE IF (NCPX1.LT.0) THEN
          COMSTR='ALL'
        ELSE
          COMSTR='   '
        END IF

C--MAG TYPE
        TYPSTR='ALL'
        IF (MAG1TYPX.EQ.1) TYPSTR='ML '
        IF (MAG1TYPX.EQ.2) TYPSTR='MX '

        WRITE (15,1042) LABX1,COMSTR,TYPSTR, (COMPX1(I),I=1,NCPX1)
1042    FORMAT ('    XMAG1: LABEL=',A1,2X,A3, '  TYPE=',A3,
     2  '  COMPS=',20(1X,A3))

C--CHOOSE BY INST TYPE
      ELSE
        IF (NXTYP1.EQ.0) THEN
          COMSTR=' NO'
        ELSE IF (NXTYP1.LT.0) THEN
          COMSTR='ALL'
        ELSE
          COMSTR='   '
        END IF
        WRITE (15,1142) LABX1,COMSTR, (IXTYP1(I),I=1,NXTYP1)
1142    FORMAT ('    XMAG1: LABEL=',A1,2X,A3,' INST TYPES=',3(1X,I1))
      END IF

C--SECOND XMAG
C--CHOOSE BY COMPONENT
      IF (LXCH) THEN
        IF (NCPX2.EQ.0) THEN
          COMSTR=' NO'
        ELSE IF (NCPX2.LT.0) THEN
          COMSTR='ALL'
        ELSE
          COMSTR='   '
        END IF

C--MAG TYPE
        TYPSTR='ALL'
        IF (MAG2TYPX.EQ.1) TYPSTR='ML '
        IF (MAG2TYPX.EQ.2) TYPSTR='MX '

        WRITE (15,1043) LABX2,COMSTR,TYPSTR, (COMPX2(I),I=1,NCPX2)
1043    FORMAT ('    XMAG2: LABEL=',A1,2X,A3, '  TYPE=',A3,
     2  '  COMPS=',20(1X,A3))

C--CHOOSE BY INST TYPE
      ELSE
        IF (NXTYP2.EQ.0) THEN
          COMSTR=' NO'
        ELSE IF (NXTYP2.LT.0) THEN
          COMSTR='ALL'
        ELSE
          COMSTR='   '
        END IF
        WRITE (15,1143) LABX2,COMSTR, (IXTYP2(I),I=1,NXTYP2)
1143    FORMAT ('    XMAG2: LABEL=',A1,2X,A3,' INST TYPES=',3(1X,I1))
      END IF

      WRITE (15,1141) MAGSEL,MAGSL2
1141  FORMAT ('    FMAG1 MAGSEL=',I1,'  FMAG2 MAGSEL=',I1)

C--WRITE INPUT FILENAMES
      WRITE (15,1020) INFILE(1),INFILE(2)
1020  FORMAT (/' INPUT FILES:'/' COMMANDS:    ',A/14X,A)
      IF (LBSTA) THEN
        WRITE (15,'('' BINARY STATION SNAPSHOT FILE: '',A)') BSTAFL
      ELSE
        WRITE (15,'('' STATIONS:    '',A,''STATION FORMAT CODE='',I2)')
     2  STAFIL,ISTFMT
      END IF

      WRITE (15,1021)DELFIL,ATNFIL,CALFIL,FMCFIL,XMCFIL,
     2 PHSFIL,JCP,IH71T
1021  FORMAT (
     3 ' DELAYS:       ',A/
     4 ' ATTENUATIONS: ',A/
     5 ' CAL FACTORS:  ',A/
     5 ' FMAG CORRECT: ',A/
     6 ' XMAG CORRECT: ',A//
     7 ' PHASES:       ',A/
     8 8X,'PHASE FORMAT CODE=',I2,', TERMINATOR FORMAT CODE=',I1)

      IF (LBCRU) THEN
        WRITE (15,'('' BINARY CRUST SNAPSHOT FILE: '',A)') BCRUFL
      ELSE
        DO I=1,MAXMOD
          IF (MODTYP(I).EQ.0) WRITE (15,1022) I,CRUFIL(I)
1022      FORMAT (' LINEAR  GRADIENT  CRUST',I2,':  ',A)
          IF (MODTYP(I).EQ.1) WRITE (15,1023) I,CRUFIL(I)
1023      FORMAT (' HOMOGENEOUS LAYER CRUST',I2,':  ',A)
        END DO
      END IF

C--WRITE OUTPUT FILENAMES
      WRITE (15,1030) LAPP(1),PRTFIL
1030  FORMAT (/' OUTPUT FILES: (T IF APPENDED TO)'/
     2 ' (',L1,') PRINTOUT:    ',A)
      IF (LSUM) WRITE (15,1031) LAPP(2),SUMFIL,IH71S
1031  FORMAT (' (',L1,') SUMMARY:     ',A,'FORMAT CODE=',I1)
      IF (LARC) WRITE (15,1032) LAPP(3),ARCFIL,JCA
1032  FORMAT (' (',L1,') ARCHIVE:     ',A,'ARCHIVE FORMAT CODE=',I2)
      IF (LMAG) WRITE (15,1036) MAGFIL
1036  FORMAT (' MAGNITUDE DATA:  ',A)

      WRITE (15,*)
      RETURN
      END
