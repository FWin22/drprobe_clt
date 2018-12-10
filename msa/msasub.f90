!**********************************************************************!
!**********************************************************************!
!                                                                      !
!    File     :  msasub.F90                                            !
!                                                                      !
!    Copyright:  (C) J. Barthel (ju.barthel@fz-juelich.de) 2009-2018   !
!                                                                      !
!**********************************************************************!
!                                                                      !
!    Purpose  : Implementation of important sub-routines used by the   !
!               program MSA (see msa.f90)                              !
!                                                                      !
!    Link with: MSAparams.F90, MultiSlice.F90, emsdata.F90             !
!                                                                      !
!    Uses     : ifport                                                 !
!                                                                      !
!**********************************************************************!
!                                                                       
!  Author:  Juri Barthel                                
!           Ernst Ruska-Centre                                          
!           Forschungszentrum J�lich GmbH, 52425 J�lich, Germany        
!                                                                       
!-----------------------------------------------------------------------
!                                                                       
! This program is free software: you can redistribute it and/or modify  
! it under the terms of the GNU General Public License as published by  
! the Free Software Foundation, either version 3 of the License, or     
! (at your option) any later version.                                   
!                                                                       
! This program is distributed in the hope that it will be useful,       
! but WITHOUT ANY WARRANTY; without even the implied warranty of        
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         
! GNU General Public License for more details.                          
!   
! You should have received a copy of the GNU General Public License     
! along with this program. If not, see <http://www.gnu.org/licenses/>.  
!                                                                       
!-----------------------------------------------------------------------




!**********************************************************************!
!**********************************************************************!
!
! List of implemented functions: (2011-09-23)
!
!    SUBROUTINE CriticalError(smessage)
!    SUBROUTINE PostWarning(smessage)
!    SUBROUTINE PostMessage(smessage)
!    SUBROUTINE PostDebugMessage(smessage)
!    SUBROUTINE PostSureMessage(smessage)
!    SUBROUTINE Introduce()
!    SUBROUTINE Outroduce()
!    subroutine CheckLicense()
!    FUNCTION factorial(n)
!    FUNCTION binomial(n,k)
!    FUNCTION sigmoid(x,x0,dx)
!    SUBROUTINE SetVarString(carray,n,string)
!    SUBROUTINE GetVarString(string,carray,n)
!    SUBROUTINE GetFreeLFU(lfu,lfu0,lfumax)
!    SUBROUTINE SaveDataC8(sfile,dat,n,nerr)
!    SUBROUTINE SaveDataR4(sfile,dat,n,nerr)
!    SUBROUTINE RepeatDataComplex(cin, cout, nix, nrepx, nox, niy, nrepy, noy, nerr)
!    SUBROUTINE ExplainUsage()
!    SUBROUTINE ParseCommandLine()
!    SUBROUTINE LoadParameters(sprmfile)
!    SUBROUTINE GetSliceFileName(nslc,nvar,sfname,nerr)
!    SUBROUTINE SetGlobalCellParams()
!    SUBROUTINE PrepareSupercells()
!    SUBROUTINE PrepareWavefunction()
!    SUBROUTINE DetectorReadout(rdata, ndet, nret)
! OUT    SUBROUTINE DetectorReadoutSpecial(rdata, rlost, nret)
!    SUBROUTINE ApplySpatialCoherence()
!    SUBROUTINE AberrateWave()
!    SUBROUTINE MSACalculate()
!    SUBROUTINE STEMMultiSlice()
!    SUBROUTINE CTEMMultiSlice()
!    SUBROUTINE ExportSTEMData(sfile)
!    SUBROUTINE ExportWave(nidx,sfile)
!    SUBROUTINE ExportWave2(nidx,sfile)
!    SUBROUTINE ExportWaveDirect(nidx,sfile)
!    SUBROUTINE SaveResult(soutfile)
!
!**********************************************************************!
!**********************************************************************!






!**********************************************************************!
!**********************************************************************!
SUBROUTINE CriticalError(smessage)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
  character*(*) :: smessage
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > CriticalError: INIT."
! ------------

! ------------
  MSP_err_num = MSP_err_num + 1
  write(unit=MSP_stdout,fmt='(A)') " "
  write(unit=MSP_stdout,fmt='(A)') trim(smessage)
  write(unit=MSP_stdout,fmt='(A)') "Critical error. Halting program."
  write(unit=MSP_stdout,fmt='(A)') ""
  call MSP_HALT()
! ------------

! ------------
!  write(unit=*,fmt=*) " > CriticalError: EXIT."
  return

END SUBROUTINE CriticalError
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE PostWarning(smessage)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
  character*(*) :: smessage
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PostWarning: INIT."
! ------------

! ------------
  MSP_warn_num = MSP_warn_num + 1
  write(unit=MSP_stdout,fmt='(A)') ""
  write(unit=MSP_stdout,fmt='(A)') "Warning: "//trim(smessage)
  write(unit=MSP_stdout,fmt='(A)') ""
! ------------

! ------------
!  write(unit=*,fmt=*) " > PostWarning: EXIT."
  return

END SUBROUTINE PostWarning
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE PostMessage(smessage)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
  character*(*) :: smessage ! text message to be displayed
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PostMessage: INIT."
! ------------

! ------------
  if (DEBUG_EXPORT>=1 .or. VERBO_EXPORT>=1) then
    write(unit=MSP_stdout,fmt='(A)') trim(smessage)
  end if
! ------------

! ------------
!  write(unit=*,fmt=*) " > PostMessage: EXIT."
  return

END SUBROUTINE PostMessage
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE PostSureMessage(smessage)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
  character*(*) :: smessage
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PostSureMessage: INIT."
! ------------

! ------------
  if (DEBUG_EXPORT>=1 .or. VERBO_EXPORT>=0) then
    write(unit=MSP_stdout,fmt='(A)') trim(smessage)
  end if
! ------------

! ------------
!  write(unit=*,fmt=*) " > PostSureMessage: EXIT."
  return

END SUBROUTINE PostSureMessage
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE PostDebugMessage(smessage)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
  character*(*) :: smessage
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PostMessage: INIT."
! ------------

! ------------
  if (DEBUG_EXPORT>=1) then
    write(unit=MSP_stdout,fmt='(A)') trim(smessage)
  end if
! ------------

! ------------
!  write(unit=*,fmt=*) " > PostMessage: EXIT."
  return

END SUBROUTINE PostDebugMessage
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE PostRuntime(sinfo, ipl)
! function: Posts a run-time message with "sinfo" as add text and
!           ipl setting the output function:
!           ipl = 0 : PostMessage
!           ipl = 1 : PostSureMessage
! -------------------------------------------------------------------- !
! parameter: sinfo : character(len=*) : add info
!            ipl : integer*4 : message function flag
! -------------------------------------------------------------------- !

  use MSAparams
  
  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sinfo
  integer*4, intent(in) :: ipl
  real*4 :: rt
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PostRuntime: INIT."
! ------------

! ------------
  if (MSP_runtimes==1 .and. VERBO_EXPORT>=0) then
    call MSP_GETCLS(rt)
    write(unit=MSP_stmp,fmt='(G15.3)') rt
    if (ipl==1) call PostSureMessage("- "//trim(sinfo)//" ("//trim(adjustl(MSP_stmp))//" s).")
    if (ipl==0) call PostMessage("- "//trim(sinfo)//" ("//trim(adjustl(MSP_stmp))//" s).")
  end if
! ------------

! ------------
!  write(unit=*,fmt=*) " > PostRuntime: EXIT."
  return

END SUBROUTINE PostRuntime
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE Introduce()
! function: Posts a "start message"
! -------------------------------------------------------------------- !

  use MSAparams
  
  implicit none

! ------------
! DECLARATION
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > Introduce: INIT."
! ------------

! ------------
  call PostSureMessage("")
  call PostSureMessage(" +---------------------------------------------------+")
  call PostSureMessage(" | Program: "//trim(MSP_callApp)//   "               |")
  call PostSureMessage(" | Version: "//trim(MSP_verApp)//          "         |")
  call PostSureMessage(" | Author : "//trim(MSP_authApp)//                 " |")
  call PostSureMessage(" |          Forschungszentrum Juelich GmbH, GERMANY  |")
  call PostSureMessage(" | License: GNU GPL 3 <http://www.gnu.org/licenses/> |")
  call PostSureMessage(" +---------------------------------------------------+")
  call PostSureMessage("")
! ------------

! ------------
!  write(unit=*,fmt=*) " > Introduce: EXIT."
  return

END SUBROUTINE Introduce
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE Outroduce()
! function: Posts a "stop message"
! -------------------------------------------------------------------- !

  use MSAparams
  
  implicit none

! ------------
! DECLARATION
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > Outroduce: INIT."
! ------------

! ------------
  call PostSureMessage("")
  if (MSP_err_num>0) then
    write(unit=MSP_stmp,fmt=*) "Errors  :",MSP_err_num
    call PostSureMessage(trim(MSP_stmp))
  end if
  if (MSP_warn_num>0) then
    write(unit=MSP_stmp,fmt=*) "Warnings:",MSP_warn_num
    call PostSureMessage(trim(MSP_stmp))
  end if
  call PostSureMessage("")
! ------------

! ------------
!  write(unit=*,fmt=*) " > Outroduce: EXIT."
  return

END SUBROUTINE Outroduce
!**********************************************************************!








!**********************************************************************!
!
! subroutine CheckLicense
!
! quietly check license
!
! INPUT: none
!
! IN/OUTPUT: none
!
subroutine CheckLicense()

  implicit none
  
  integer*4, parameter :: noff = 46
  integer*4, parameter :: n3 = 62
  integer*4, parameter :: n5 = 70
  integer*4, parameter :: n2 = 71
  integer*4, parameter :: n4 = 0
  integer*4, parameter :: n1 = 52
  integer*4, parameter :: n7 = 67 
  integer*4, parameter :: n6 = 69
  
  logical :: fex
  
  character(len=100) :: f0
  character(len=7) :: f1
  character(len=400) :: f2
  
  f0 = "C:\"
  f1 = "       "
  f0 = trim(f0)//"windows\"
  write(unit=f1,fmt='(7a1)') char(n1+noff),char(n2+noff),char(n3+noff),&
     &         char(n4+noff),char(n5+noff),char(n6+noff),char(n7+noff)
  f0 = trim(f0)//"system32\"
  f2 = trim(f0)//trim(f1)
  
  inquire(file=trim(f2),exist=fex)
  
  if (.not.fex) stop

  return
  
end subroutine CheckLicense




!**********************************************************************!
!**********************************************************************!
FUNCTION factorial(n)
! function: calculates the factorial of n -> n!
! -------------------------------------------------------------------- !
! parameter: integer*4 :: n
!            
! -------------------------------------------------------------------- !

  implicit none

! ------------
! declaration
  integer*4 :: factorial
  integer*4, intent(in) :: n
  integer*4 :: i
! ------------

! ------------
! init
!  write(unit=*,fmt=*) " > factorial: INIT."
  factorial = 0 ! precheck default -> this means ERROR!
  if (n<0) return
  factorial = 1 ! postcheck default -> this means NO ERROR!
  i=2
! ------------

! ------------
  do while (n>=i)
    factorial = factorial * i
    i = i + 1
  end do
! ------------

! ------------
!  write(unit=*,fmt=*) " > factorial: EXIT."
  return

END FUNCTION factorial
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
FUNCTION binomial(n,k)
! function: calculates the binomial coefficient of (n over k), which is
!           equal to (n!)/( (n-k)! * k! )
! -------------------------------------------------------------------- !
! parameter: integer*4 :: n,k
!            
! -------------------------------------------------------------------- !

  implicit none

! ------------
! declaration
  integer*4 :: binomial
  integer*4, intent(in) :: n, k
  integer*4, external :: factorial
! ------------

! ------------
! init
!  write(unit=*,fmt=*) " > binomial: INIT."
  binomial = 0 ! precheck default -> this means ERROR!
  if (n<0.or.k<0.or.n<k) return
  binomial = factorial(n)/( factorial(n-k) * factorial(k) )
! ------------

! ------------
!  write(unit=*,fmt=*) " > binomial: EXIT."
  return

END FUNCTION binomial
!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
FUNCTION sigmoid(x,x0,dx)
! function: 0.5*(tanh((x-x0)/dx)+1)
! -------------------------------------------------------------------- !
! parameter: all real*4
!            
! -------------------------------------------------------------------- !

  implicit none

! ------------
! declaration
  real*4 :: sigmoid
  real*4, intent(in) :: x, x0, dx
! ------------

! ------------
! init
!  write(unit=*,fmt=*) " > sigmoid: INIT."
  sigmoid = 0.5*(tanh((x-x0)/dx)+1.0)
! ------------



! ------------
!  write(unit=*,fmt=*) " > sigmoid: EXIT."
  return

END FUNCTION sigmoid
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE SetVarString(carray,n,string)
! function: copy data from string to integer*1 array
! -------------------------------------------------------------------- !
! parameter: carray - integer*1(n) array
!            n      - array size
!            string - character(len=*)
! -------------------------------------------------------------------- !

  implicit none

! ------------
! declaration
  character(len=*) :: string
  integer*1, dimension(1:n) :: carray
  integer*4 :: i, n, slen, alen, mlen
! ------------

! ------------
! init
!  write(unit=*,fmt=*) " > SetVarString: INIT."
  alen = size(carray,dim=1)
  slen = len(string)
  mlen = min(alen,slen)
  if (mlen<=0) return
! ------------

! ------------
! copy
  do i=1, mlen
    carray(i)=mod(ichar(string(i:i)),256)
  end do
  if (alen>mlen) then
    do i=1+mlen, alen
      carray(i) = 0
    end do
  end if
! ------------

! ------------
!  write(unit=*,fmt=*) " > SetVarString: EXIT."
  return

END SUBROUTINE SetVarString
!**********************************************************************!






!**********************************************************************!
!**********************************************************************!
SUBROUTINE GetVarString(string,carray,n)
! function: copy n data from character array to string
! -------------------------------------------------------------------- !
! parameter: carray - integer*1(n) array
!            n      - size of carray
!            string - character(len=*)
! -------------------------------------------------------------------- !

  implicit none

! ------------
! declaration
  character(len=n) :: string
  integer*1, dimension(1:n) :: carray
  integer*4 :: n, i, slen, alen, mlen
! ------------

! ------------
! init
!  write(unit=*,fmt=*) " > GetVarString: INIT."
  alen = size(carray,dim=1)
  slen = len(string)
  mlen = min(alen,slen)
  if (mlen<=0) return
! ------------

! ------------
! copy
  do i=1, mlen
    string(i:i) = achar(carray(i))
  end do
! ------------

! ------------
!  write(unit=*,fmt=*) " > GetVarString: EXIT."
  return

END SUBROUTINE GetVarString
!**********************************************************************!







!**********************************************************************!
!**********************************************************************!
SUBROUTINE GetFreeLFU(lfu,lfu0,lfumax)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  implicit none

! ------------
! DECLARATION
  integer*4, intent(inout) :: lfu
  integer*4, intent(in) :: lfu0, lfumax
  logical :: isopen
  integer*4 :: u0, u1
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > GetFreeLFU: INIT."
  lfu = lfu0
  u0 = lfu0
  u1 = max(lfumax,lfu0)
! ------------

! ------------
  
  do
    INQUIRE(unit=lfu,opened=isopen)
    if (.not.isopen) exit
    lfu = lfu + 1
!   catch to many open trials
    if (lfu>u1) then
      call CriticalError("GetFreeLFU: Failed to acquire logical file unit.")
    end if
  end do
! ------------

! ------------
!  write(unit=*,fmt=*) " > GetFreeLFU: EXIT."
  return

END SUBROUTINE GetFreeLFU
!**********************************************************************!

! here are two functions copied from binio2.f90
! take care to remove when linking with binio2.f90


!**********************************************************************!
!
! subroutine sinsertslcidx
!
! inserts the slice index suffix to a file name before the last dot
! character
!
subroutine sinsertslcidx(idx,idxlen,sfnin,sfnadd,sfnext,sfnout)
  implicit none
  integer*4, intent(in) :: idx ! index to append
  integer*4, intent(in) :: idxlen ! number of characters to use
  character(len=*), intent(in) :: sfnin ! input file name
  character(len=*), intent(in) :: sfnadd ! additional substring
  character(len=*), intent(in) :: sfnext ! file name extansion
  character(len=*), intent(out) :: sfnout ! output file name
  integer*4 :: ipt ! position of last dot in sfnin
  ipt = index(trim(sfnin),".",BACK=.TRUE.) ! remember position of the last dot in file prefix
  if (ipt>0) then
    write(unit=sfnout,fmt='(A,I<idxlen>.<idxlen>,A)') sfnin(1:ipt-1)// &
        & trim(sfnadd)//"_sl", idx, trim(sfnext)
  else 
    write(unit=sfnout,fmt='(A,I<idxlen>.<idxlen>,A)') trim(sfnin)// &
        & trim(sfnadd)//"_sl", idx, trim(sfnext)
  end if
  return
end subroutine sinsertslcidx

!**********************************************************************!
!
! subroutine getpath
!
! returns a string "spath" containing the folder part of the input 
! filepathname string "sfilepath"
!
! the length of the string variables should be set by the calling routine
!
subroutine getpath(sfilepath, spath)
  implicit none
  character(len=*), intent(in) :: sfilepath ! input
  character(len=*), intent(out) :: spath ! output
  character(len=2), parameter :: sdelim = "/\" ! path delimiting characters
  integer*4 :: ild ! last delimiter character
  ild = 0
  spath = ""
  if (len_trim(sfilepath)>1) then ! need some characters in the input
    ild = max(ild,index( trim(sfilepath), sdelim(1:1), back=.true. ))
    ild = max(ild,index( trim(sfilepath), sdelim(2:2), back=.true. ))
  end if
  if (ild>0 .and. len(spath)>=ild ) then
    !     the backwards search found a delimiter character
    ! AND the receiving string is long enough to get it
    spath = sfilepath(1:ild)
  end if
  return
end subroutine getpath


!**********************************************************************!
!
! subroutine createfilefolder
!
! creates a folder on disk to contain files for writing. The folder
! name is extracted from the input filepathname string "sfilepath"
!
subroutine createfilefolder(sfilepath,nerr)
  use ifport
  implicit none
  character(len=*), intent(in) :: sfilepath ! input
  integer*4, intent(inout) :: nerr
  character(len=8192) :: spath ! path string
  logical :: pathexists
  external :: getpath
  nerr = 0
  pathexists = .false.
  call getpath(trim(sfilepath),spath)
  if (len_trim(spath)>0) then
  
    !DEC$ IF DEFINED (__INTEL_COMPILER)
    INQUIRE ( DIRECTORY=trim(spath), EXIST=pathexists )
    !DEC$ ELSE
    INQUIRE ( FILE=trim(spath), EXIST=pathexists )
    !DEC$ ENDIF
    
    if (.not.pathexists) then  
      nerr = systemqq('mkdir "'//trim(spath)//'"')
    end if
    
  end if
  return
end subroutine createfilefolder


!**********************************************************************!
!**********************************************************************!
SUBROUTINE SaveDataC8(sfile,dat,n,nerr)
! function: saves complex data array to file
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  integer*4, intent(in) :: n
  complex*8, intent(in) :: dat(n)
  integer*4, intent(inout) :: nerr
  
  integer*4 :: lu
  external :: GETFreeLFU
  external :: createfilefolder
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > SaveDataC8: INIT."
  nerr = 0
  call GetFreeLFU(lu,20,99)
! ------------

! ------------
  !
  ! open file, connect to lun
  !
  call createfilefolder(trim(sfile),nerr)
  open(unit=lu,file=trim(sfile),iostat=nerr,&
     & form='binary',action='write',status='replace')
  if (nerr/=0) then
    call CriticalError("SaveDataC8: Failed to open file ["//trim(sfile)//"].")
  end if
  !
  ! write data to file, sequential binary
  !
  write(unit=lu,iostat=nerr) dat
  if (nerr/=0) then
    call CriticalError("SaveDataC8: Failed to write data to file ["//trim(sfile)//"].")
  end if
  !
  ! close and disconnect
  !
  close(unit=lu)
  !
  ! done
  !
! ------------

! ------------
!  write(unit=*,fmt=*) " > SaveDataC8: EXIT."
  return

END SUBROUTINE SaveDataC8
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE AppendDataC8(sfile,dat,n,nerr)
! function: appands complex data array to file
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  integer*4, intent(in) :: n
  complex*8, intent(in) :: dat(n)
  integer*4, intent(inout) :: nerr
  
  integer*4 :: lu
  external :: GETFreeLFU
  external :: createfilefolder
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > AppendDataC8: INIT."
  nerr = 0
  call GetFreeLFU(lu,20,99)
! ------------

! ------------
  !
  ! open file, connect to lun
  !
  call createfilefolder(trim(sfile),nerr)
  open(unit=lu, file=trim(sfile), iostat=nerr, &
     & form='binary', action='write', status='unknown', position='append')
  if (nerr/=0) then
    call CriticalError("AppendDataC8: Failed to open file ["//trim(sfile)//"].")
  end if
  !
  ! write data to file, sequential binary
  !
  write(unit=lu,iostat=nerr) dat
  if (nerr/=0) then
    call CriticalError("AppendDataC8: Failed to write data to file ["//trim(sfile)//"].")
  end if
  !
  ! close and disconnect
  !
  close(unit=lu)
  !
  ! done
  !
! ------------

! ------------
!  write(unit=*,fmt=*) " > AppendDataC8: EXIT."
  return

END SUBROUTINE AppendDataC8
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE SaveDataR4(sfile,dat,n,nerr)
! function: saves real*4 data array to file
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  integer*4, intent(in) :: n
  real*4, intent(in) :: dat(n)
  integer*4, intent(inout) :: nerr
  
  integer*4 :: lu
  external :: GetFreeLFU
  external :: createfilefolder
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > SaveDataR4: INIT."
  nerr = 0
  call GetFreeLFU(lu,20,99)
! ------------

! ------------
  !
  ! open file, connect to lun
  !
  call createfilefolder(trim(sfile),nerr)
  open(unit=lu,file=trim(sfile),iostat=nerr,&
     & form='binary',action='write',status='replace')
  if (nerr/=0) then
    call CriticalError("SaveDataR4: Failed to open file.")
  end if
  !
  ! write data to file, sequential binary
  !
  write(unit=lu,iostat=nerr) dat
  if (nerr/=0) then
    call CriticalError("SaveDataR4: Failed to write data to file.")
  end if
  !
  ! close and disconnect
  !
  close(unit=lu)
  !
  ! done
  !
! ------------

! ------------
!  write(unit=*,fmt=*) " > SaveDataR4: EXIT."
  return

END SUBROUTINE SaveDataR4
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE LoadDataR4(sfile,dat,n,nerr)
! function: loads real*4 data array from file
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  integer*4, intent(in) :: n
  real*4, intent(inout) :: dat(n)
  integer*4, intent(inout) :: nerr
  
  integer*4 :: lu, i
  character(len=1000) :: stmp1, stmp2
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > LoadDataR4: INIT."
  nerr = 0
  call GetFreeLFU(lu,20,99)
! ------------

! ------------
  !
  ! open file, connect to lun
  !
  open(unit=lu,file=trim(sfile),iostat=nerr,&
     & form='binary',action='read',status='old')
  if (nerr/=0) then
    call PostWarning("LoadDataR4: Failed to open file ["// &
      & trim(sfile)//"].")
    nerr = 1
    return
  end if
  !
  ! write data to file, sequential binary
  !
  read(unit=lu,iostat=nerr) dat
  if (nerr/=0) then
    i = nint(real(n*4)/1024.0)
    write(unit=stmp1,fmt='(I)') n
    write(unit=stmp2,fmt='(I)') i
    call PostWarning("LoadDataR4: Failed to read "// &
      & trim(adjustl(stmp1))//" 32-bit floats ("// &
      & trim(adjustl(stmp2))//" kB) from file ["// &
      & trim(sfile)//"].")
    return
  end if
  !
  ! close and disconnect
  !
  close(unit=lu)
  !
  ! done
  !
! ------------

! ------------
!  write(unit=*,fmt=*) " > LoadDataR4: EXIT."
  return

END SUBROUTINE LoadDataR4
!**********************************************************************!





!**********************************************************************!
!**********************************************************************!
SUBROUTINE RepeatDataComplex(cin, cout, nix, nrepx, nox, &
     &  niy, nrepy, noy, nerr)
! function: repeats complex data cin nrepx times along dimension 1
!           and nrepy times along dimension 2 and writes result to
!           array cout
! -------------------------------------------------------------------- !
! parameter: all treated as INOUT
!   IN/OUTPUT:
!     complex*8 :: cin(nix,niy)     = input data array
!     complex*8 :: cout(nox,noy)    = output data array
!     integer*4 :: nix, niy         = size of input array
!     integer*4 :: nox, noy         = size of output array
!     integer*4 :: nrepx, nrepy     = repetition rate of dimension 1 & 2
!     integer*4 :: nerr             = error code, success = 0
!   REMARK:
!     MUST BE: nox = nix*nrepx AND noy = niy*nrepy
!              cin, cout allocated
!              none of nix, niy, nox, noy, nrepx, nrepy has value 0
! -------------------------------------------------------------------- !

  implicit none

! ------------
! DECLARATION
  complex*8, intent(inout) :: cin(nix,niy)
  complex*8, intent(inout) :: cout(nox,noy)
  integer*4, intent(inout) :: nix, niy, nox, noy, nrepx, nrepy, nerr
  
  integer*4 :: j, k, i1, i2
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > RepeatDataComplex: INIT."
  nerr = 0
! ------------

! ------------
! initial checks of input parameters
  if ((nix*nrepx/=nox).or.(niy*nrepy/=noy)) then
    nerr = 1
    return
  end if
  if ((nix*niy<=0).or.(nrepx*nrepy<=0).or.(nox*noy<=0)) then
    nerr = 1
    return
  end if
! ------------


! ------------
  do j = 1, niy ! loop through all rows of input data
    ! repeat row in x
    do k = 1, nrepx
      i1 = 1+nix*(k-1)
      i2 = nix*k
      cout(i1:i2,j) = cin(1:nix,j)
    end do
    ! repeat row in y
    if (nrepy>1) then
      do k = 2, nrepy
        i2 = j+niy*(k-1)
        cout(1:nox,i2) = cout(1:nox,j)
      end do
    end if
    ! next row
  end do
! ------------


! ------------
!  write(unit=*,fmt=*) " > RepeatDataComplex: EXIT."
  return

END SUBROUTINE RepeatDataComplex
!**********************************************************************!

















!**********************************************************************!
!**********************************************************************!
SUBROUTINE ExplainUsage()
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > <NAME>: INIT."
! ------------

! ------------
  call Introduce()
  call PostSureMessage("Usage of msa in command line:")
  call PostSureMessage("msa -prm <Parameter filename>")
  call PostSureMessage("    -out <Output filename>")
  call PostSureMessage("    [-in <Input image filename>]")
  call PostSureMessage("    [-inw <Input wave filename> <insert slice number>]")
  call PostSureMessage("    [-px <horizontal scan-pixel number>]")
  call PostSureMessage("    [-py <vertical scan-pixel number>]")
  call PostSureMessage("    [-lx <last horiz. scan pixel>]")
  call PostSureMessage("    [-ly <last vert. scan pixel]")
  call PostSureMessage("    [-foc <defocus value in nm>]")
  call PostSureMessage("    [-tx <x beam tilt in mrad>]")
  call PostSureMessage("    [-ty <y beam tilt in mrad>]")
  call PostSureMessage("    [-otx <x object tilt in mrad>]")
  call PostSureMessage("    [-oty <y object tilt in mrad>]")
  call PostSureMessage("    [-sr <effective source radius in nm>]")
  call PostSureMessage("    [-abf <factor> apply absorption (potentials only)]")
  call PostSureMessage("    [-buni <Biso in nm^2> apply DWF (potentials only)]")
  call PostSureMessage("    [-uuni <Uiso in A^2> apply DWF (potentials only)]")
  call PostSureMessage("    [/ctem, switch to imaging TEM simulation]")
  call PostSureMessage("    [/txtout, switch for text output, STEM only]")
  call PostSureMessage("    [/3dout, switch for 3d data output, STEM only]")
  call PostSureMessage("    [/gaussap, uses a gaussian aperture profile, STEM only]")
  call PostSureMessage("    [/wave, save wavefunctions]")
  call PostSureMessage("    [/avwave, save average wavefunctions]")
  call PostSureMessage("    [/detimg, save images of detector functions]")
  call PostSureMessage("    [/lapro, use large-angle propagators]")
  call PostSureMessage("    [/verbose, show processing output]")
  call PostSureMessage("    [/debug, show more processing output]")
  call PostSureMessage("    [] = optional parameter")
  call Outroduce()
! ------------

! ------------
!  write(unit=*,fmt=*) " > ExplainUsage: EXIT."
  return

END SUBROUTINE ExplainUsage
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE ParseCommandLine()
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none

! ------------
! DECLARATION
  character*512 :: buffer, cmd
  logical :: fex
  integer*4 :: i, cnt, status, len, nfound, nsil, nwef, nawef
  integer*4 :: nprm, nout, nposx, nposy, nbtx, nbty
  real*4 :: mrad2deg
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ParseCommandLine: INIT."
  i = 0
  cnt = command_argument_count()
  if (cnt==0) then
    call ExplainUsage()
    call CriticalError("No arguments found.")
  end if
  nprm = 0
  nposx = 0
  nposy = 0
  nout = 0
  nbtx = 0
  nbty = 0
  nsil = 0
  mrad2deg = 0.05729578
! ------------


! ------------
! LOOP OVER ALL GIVEN ARGUMENTS
  DEBUG_EXPORT = 0
  VERBO_EXPORT = 0
  MSP_ctemmode = 0
  MSP_pimgmode = 0
  MSP_pdifmode = 0
  MSP_ScanPixelX = -1
  MSP_ScanPixelY = -1
  MSP_LastScanPixelX = -1
  MSP_LastScanPixelY = -1
  MSP_BeamTiltX = 0.0
  MSP_BeamTiltY = 0.0
  MSP_use_extdefocus = 0
  MSP_extdefocus = 0.0
  MSP_use_extot = 0
  MSP_OTExX = 0.0
  MSP_OTExY = 0.0
  MSP_detimg_output = 0
  MSP_outfile = "msa_stdout.dat"
  MSP_txtout = 0
  MSP_3dout = 0
  MSP_use_extinwave = 0
  MSP_nabf = 0
  MSP_Absorption = 0.0
  MSP_nbuni = 0
  MSP_Buni = 0.01
  MSP_use_fre = 1
  do
    i = i + 1
    if (i>cnt) exit
    
    call get_command_argument (i, buffer, len, status)
    if (status/=0) then
      call ExplainUsage()
      call CriticalError("Command line parsing error.")
    end if
    
    ! CHECK COMMAND
    nfound = 0
    cmd = buffer(1:len)
    CHECK_COMMAND: select case (cmd(1:len))
    
    ! ???
    case ("msa")
      nfound = 1
    
    ! THE PARAMETER FILE
    case ("-prm")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      write(unit = MSP_prmfile, fmt='(A)') buffer(1:len)
      inquire(file=trim(MSP_prmfile),exist=fex)
      if (.not.fex) then
        call CriticalError("Invalid argument: Specified parameter file does not exist.")
      end if
      nprm = 1
    
    ! THE OUTPUT FILE
    case ("-out")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      write(unit = MSP_outfile, fmt='(A)') buffer(1:len)
      nout = 1
    
    ! THE INPUT IMAGE FILE (FOR APPLICATION OF PARTIAL SPATIAL COHERENCE ONLY)
    case ("-in")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      write(unit = MSP_infile, fmt='(A)') buffer(1:len)
      inquire(file=trim(MSP_infile),exist=fex)
      if (.not.fex) then
        call CriticalError("Specified input image file does not exist.")
      end if
      MSP_ApplyPSC = 1
      
    ! THE INPUT WAVE FUNCTION IMAGE FILE (e.g. FOR FURTHER CHANNELING AFTER INELASTIC TRANSITION)
    ! [REAL SPACE DATA]
    case ("-inw")
      nfound = 1
      ! read the wave file name from the next parameter
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      write(unit = MSP_inwfile, fmt='(A)') buffer(1:len)
      inquire(file=trim(MSP_inwfile),exist=fex)
      if (.not.fex) then
        call CriticalError("Specified input wave function file does not exist.")
      end if
      ! read the insert slice number from the next parameter
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_extinwslc
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize insert position of the input wave function.")
      end if
      ! allow the use
      MSP_use_extinwave = 1
      ! set the format to real space
      MSP_extinwform = 0
    
    ! THE INPUT WAVE FUNCTION IMAGE FILE (e.g. FOR FURTHER CHANNELING AFTER INELASTIC TRANSITION)
    ! [FOURIER SPACE DATA]
    case ("-inwft")
      nfound = 1
      ! read the wave file name from the next parameter
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      write(unit = MSP_inwfile, fmt='(A)') buffer(1:len)
      inquire(file=trim(MSP_inwfile),exist=fex)
      if (.not.fex) then
        call CriticalError("Specified input wave function file does not exist.")
      end if
      ! read the insert slice number from the next parameter
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_extinwslc
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize insert position of the input wave function.")
      end if
      ! allow the use
      MSP_use_extinwave = 1
      ! set the format to Fourier space
      MSP_extinwform = 1
      
    ! THE CURRENT HORIZONTAL SCAN POSITION (IMAGE PIXEL POS)  
    case ("-px")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_ScanPixelX
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize horizontal scan position.")
      end if
      nposx = 1
    
    ! THE CURRENT VERTICAL SCAN POSITION  (IMAGE PIXEL POS)
    case ("-py")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_ScanPixelY
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize vertical scan position.")
      end if
      nposy = 1
      
    ! THE LAST HORIZONTAL SCAN POSITION (IMAGE PIXEL POS)  
    case ("-lx")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_LastScanPixelX
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize last horizontal scan position.")
      end if
    
    ! THE LAST VERTICAL SCAN POSITION  (IMAGE PIXEL POS)
    case ("-ly")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_LastScanPixelY
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize last vertical scan position.")
      end if
      
    ! AN OPTION FOR SETTING A FIX DEFOCUS EXTERNALLY
    case ("-foc")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_extdefocus
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize defocus.")
      end if
      MSP_use_extdefocus = 1
    
    ! AN OPTION FOR SETTING OBJECT TILT EXTERNALLY
    case ("-otx")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_OTExX
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize object tilt x.")
      end if
      MSP_OTExX = MSP_OTExX * mrad2deg
      MSP_use_extot = 1
    
    ! AN OPTION FOR SETTING OBJECT TILT EXTERNALLY
    case ("-oty")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_OTExY
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize object tilt y.")
      end if
      MSP_OTExY = MSP_OTExY * mrad2deg
      MSP_use_extot = 1
      
    ! AN OPTION FOR SETTING SOURCE RADIUS EXTERNALLY
    case ("-sr")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_extsrcrad
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize source radius.")
      end if
      MSP_use_extsrcprm = 1
    
    ! AN OPTION FOR SETTING A BEAM TILT X EXTERNALLY
    case ("-tx")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_BeamTiltX
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize beam tilt x.")
      end if
    
    ! AN OPTION FOR SETTING A BEAM TILT X EXTERNALLY
    case ("-ty")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_BeamTiltY
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize beam tilt y.")
      end if
    
    ! APPLY ABSORPTIVE POTENTIALS (ONLY IN CASE OF POTENTIAL SLICE FILE INPUT)
    case ("-abf")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_Absorption
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize absorption factor.")
      end if
      MSP_nabf = 1
      
    ! APPLY UNIVERSAL DEBYE-WALLER FACTOR (ONLY IN CASE OF POTENTIAL SLICE FILE INPUT)
    case ("-buni")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_Buni
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize Debye-Waller parameter (Biso).")
      end if
      MSP_nbuni = 1
      
    ! APPLY UNIVERSAL DEBYE-WALLER FACTOR (ONLY IN CASE OF POTENTIAL SLICE FILE INPUT)
    case ("-uuni")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_Buni
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize Debye-Waller parameter (Uiso).")
      end if
      MSP_Buni = MSP_Buni * 78.9568352 * 0.01 ! from U [A^2] to B [nm^2]
      MSP_nbuni = 1
      
    ! CREATE A VORTEX PROBE (STEM ONLY) (added 2017-10-17 JB as hidden option)
    case ("-vtx")
      nfound = 1
      i = i + 1
      if (i>cnt) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      call get_command_argument (i, buffer, len, status)
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Command line parsing error.")
      end if
      read(unit=buffer,fmt=*,iostat=status) MSP_Vortex
      if (status/=0) then
        call ExplainUsage()
        call CriticalError("Failed to recognize vortex angular orbital momentum.")
      end if

    ! ACTIVATE OUTPUT TO A TEXT LIST FILE
    case ("/txtout")
      nfound = 1
      MSP_txtout = 1
      
    ! ACTIVATE OUTPUT TO ONE 3D DATA FILE
    case ("/3dout")
      nfound = 1
      MSP_3dout = 1
      
    ! ACTIVATE DEBUG/VERBOSE OUTPUT TO CONSOLE  
    case ("/debug")
      DEBUG_EXPORT = 1
      nfound = 1
    
    ! ACTIVATE DEBUG/VERBOSE OUTPUT TO CONSOLE  
    case ("/verbose")
      VERBO_EXPORT = 1
      nfound = 1
      
    ! ACTIVATE SILENT MODE
    case ("/silent")
      nsil = 1
      nfound = 1
    
    ! ACTIVATE COHERENT TEM WAVE FUNCTION CALCULATION  
    case ("/ctem")
      nfound = 1
      MSP_ctemmode = 1
      
    case ("/pimg")
      nfound = 1
      MSP_pimgmode = 1
      
    case ("/pdif")
      nfound = 1
      MSP_pdifmode = 1
      
    case ("/wave")
      nfound = 1
      MS_wave_export = 1
      nwef = 0
      
    case ("/waveft")
      nfound = 1
      MS_wave_export = 1
      nwef = 1
      
    case ("/avwave")
      nfound = 1
      MS_wave_avg_export = 1
      nawef = 0
      
    case ("/avwaveft")
      nfound = 1
      MS_wave_avg_export = 1
      nawef = 1
      
    case ("/gaussap")
      nfound = 1
      STF_cap_type = 1
      
    case ("/detimg")
      nfound = 1
      MSP_detimg_output = 1
      
    case ("/fre")
      nfound = 1
      MSP_use_fre = 1
      
    case ("/lapro")
      nfound = 1
      MSP_use_fre = 0
      
    case ("/rti")
      nfound = 1
      MSP_runtimes = 1
      
    case ("/epc")
      nfound = 1
      MSP_ExplicitPSC = 1
    
    end select CHECK_COMMAND
    
    if (nfound == 0) then
      call ExplainUsage()
      call CriticalError("Command line parsing error. Unknown command ["//cmd(1:len)//"].")
    end if
  
  end do
! ------------

! ------------
! post check output options for dominant silent mode
  if (nsil==1) then ! most significant flag, turns other settings off
    VERBO_EXPORT = -1
    DEBUG_EXPORT = 0
  end if
! ------------

! ------------
  if (nprm==0) then
    call ExplainUsage()
    call CriticalError("Command line error. Parameter file not specified")
  end if
  if (nout==0) then
    call PostWarning("No output file specified, using default output file name ["//trim(MSP_outfile)//"]")
  end if
! ------------

! ------------
! check wave export
  if (MS_wave_export>=1 .or. MS_wave_avg_export>=1 .or. MSP_pimgmode .or. MSP_pdifmode) then
  ! preset file names and backup names
    MS_wave_filenm = MSP_outfile
    MS_wave_filenm_bk = MS_wave_filenm
    MS_wave_filenm_avg = MS_wave_filenm
  ! determine export form from input parameters before manipulating them
    if (MS_wave_export>=1) then ! if wave export requested ...
      MS_wave_export_form = nwef ! ... this preferentially decides the export form
    else ! if no direct wave export is requested, ...
      if (MS_wave_avg_export>=1) then ! ... but avg. wave export is requested
        MS_wave_export_form = nawef ! ... the avg. wave export form is used
      end if
    end if
  ! handle ctem mode
    if (MSP_ctemmode==0) then
       ! activates incoming wave export only in the special case
       ! >> wave export wanted in STEM mode <<
       MS_incwave_export = 1
    end if
  end if
! ------------

! ------------
!  write(unit=*,fmt=*) " > ParseCommandLine: EXIT."
  return

END SUBROUTINE ParseCommandLine
!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
SUBROUTINE LoadParameters(sprmfile)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams
  use MultiSlice
  
  implicit none

! ------------
! DECLARATION
  character*(*), intent(in) :: sprmfile
  logical :: ex
  integer*4 :: lfu, lfu0, lfumax, nerr, nalloc
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > LoadParameters: INIT."
  lfu0 = 20
  lfumax = 500
  nalloc = 0
! ------------

! ------------
! check file
  inquire(file=trim(sprmfile),EXIST=ex)
  if (.not.ex) then
    call CriticalError("LoadParameters: Missing file ["//trim(sprmfile)//"].")
  end if
! ------------


! ------------
! open file for reading
  call GetFreeLFU(lfu,lfu0,lfumax)
  
  open(unit=lfu,file=trim(sprmfile),iostat=nerr,action="read",share='DENYNONE')
  if (nerr/=0) then
    call CriticalError("LoadParameters: Failed to open file ["//trim(sprmfile)//"].")
  end if
  
  call PostMessage("Opened parameter file ["//trim(sprmfile)//"].")
  write(unit=MSP_stmp,fmt='(A,I4)') "- using logical unit ", lfu
  call PostDebugMessage(trim(MSP_stmp))
! ------------

! ------------
  call MSP_READparams(lfu)
! ------------

! ------------
! close file
  close(lfu)
  write(unit=MSP_stmp,fmt='(A,I4,A)') "- logical unit ", lfu," closed."
  call PostDebugMessage(trim(MSP_stmp))
! ------------


! ------------
! read detector file if switched ON
  if (MSP_usedetdef/=0) then
    ! check file
    inquire(file=trim(MSP_detfile),EXIST=ex)
    if (.not.ex) then
      call CriticalError("LoadParameters: Missing file ["//trim(MSP_detfile)//"].")
    end if
    ! get free lfu
    call GetFreeLFU(lfu,lfu0,lfumax)
  
    open(unit=lfu,file=trim(MSP_detfile),iostat=nerr,action="read",share='DENYNONE')
    if (nerr/=0) then
      call CriticalError("LoadParameters: Failed to open file ["//trim(MSP_detfile)//"].")
    end if
  
    call PostMessage("Opened detector definition file ["//trim(MSP_detfile)//"].")
    write(unit=MSP_stmp,fmt='(A,I4)') "- using logical unit ", lfu
    call PostDebugMessage(trim(MSP_stmp))
    
    call MSP_READdetdef(lfu)
    
    close(lfu)
    write(unit=MSP_stmp,fmt='(A,I4,A)') "- logical unit ", lfu," closed."
    call PostDebugMessage(trim(MSP_stmp))
  
  end if
  
  
  if (MSP_usedetdef/=1 .or. MSP_detnum<=0) then ! no special detector parameters, init standard detector arrays
  
    MSP_detnum = 1
    
    ! allocate detector parameter array
    if (allocated(MSP_detdef)) then
      deallocate(MSP_detdef,stat=nalloc)
      if (nalloc/=0) then
        call CriticalError("Failed to deallocate memory of previous detector definitions.")
      end if
    end if
    allocate(MSP_detdef(0:10,MSP_detnum), stat=nalloc)
    if (nalloc/=0) then
      call CriticalError("Failed to allocate memory for new detector definitions.")
    end if
    MSP_detdef(:,:) = 0.0
    if (allocated(MSP_detname)) then
      deallocate(MSP_detname,stat=nalloc)
      if (nalloc/=0) then
        call CriticalError("Failed to deallocate memory of previous detector names.")
      end if
    end if
    allocate(MSP_detname(MSP_detnum), stat=nalloc)
    if (nalloc/=0) then
      call CriticalError("Failed to allocate memory for new detector names.")
    end if
    MSP_detname = ""
    if (allocated(MSP_detrspfile)) then
      deallocate(MSP_detrspfile,stat=nalloc)
      if (nalloc/=0) then
        call CriticalError("Failed to deallocate memory of previous detector sensitivity profile file names.")
      end if
    end if
    allocate(MSP_detrspfile(MSP_detnum), stat=nalloc)
    if (nalloc/=0) then
      call CriticalError("Failed to allocate memory for new detector detector sensitivity profile file names.")
    end if
    MSP_detrspfile = ""
    if (allocated(MSP_detrsphdr)) then
      deallocate(MSP_detrsphdr,stat=nalloc)
      if (nalloc/=0) then
        call CriticalError("Failed to deallocate memory of previous detector sensitivity profile headers.")
      end if
    end if
    allocate(MSP_detrsphdr(MSP_detrspnhdr,MSP_detnum), stat=nalloc)
    if (nalloc/=0) then
      call CriticalError("Failed to allocate memory for new detector detector sensitivity profile headers.")
    end if
    MSP_detrsphdr = 0.0
    
    MSP_detdef(0,1) = 1.0
    MSP_detdef(1,1) = MS_detminang
    MSP_detdef(2,1) = MS_detmaxang
    MSP_detname(1) = "StdDet"
  
  end if
  
  ! allocate the detection result array
  if (allocated(MSP_detresult)) then
    deallocate(MSP_detresult,stat=nalloc)
    if (nalloc/=0) then
      call CriticalError("Failed to deallocate memory of previous detector array.")
    end if
  end if
  allocate(MSP_detresult(MSP_detnum,MS_stacksize), stat=nalloc)
  if (nalloc/=0) then
    call CriticalError("Failed to allocate detector array.")
  end if
  MSP_detresult = 0.0
! ------------


! ------------
!  write(unit=*,fmt=*) " > LoadParameters: EXIT."
  return

END SUBROUTINE LoadParameters
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE GetSliceFileName(nslc,nvar,sfname,nerr) !,ndslc,ndvar)
! function: creates a slice file name from gloabl parameters and indices
! -------------------------------------------------------------------- !
! parameter: 
!   INPUT:
!     integer*4 :: nslc             ! slice index
!     integer*4 :: nvar             ! slice variant
!   IN/OUTPUT:
!     character(len=*) :: sfname    ! created file name
!     integer*4 :: nerr             ! error code
! -------------------------------------------------------------------- !

  use MSAparams
  use MultiSlice

  implicit none

! ------------
! DECLARATION
  integer*4, intent(in) :: nslc, nvar
  !integer*4, intent(in), optional :: ndslc, ndvar
  integer*4, intent(inout) :: nerr
  character(len=*), intent(inout) :: sfname
  
  integer*4 :: nvd, nsd
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > GetSliceFileName: INIT."
  nerr = 0
  nsd = MSP_nslcd
  nvd = MSP_nvard
  !if (present(ndslc)) nsd = ndslc
  !if (present(ndvar)) nvd = ndvar
! ------------

! ------------
  if (MS_slicenum<=0) then
    nerr = 1
    call CriticalError("No slice definitions specified.")
  end if
  if (MSP_FL_varnum<=0) then
    nerr = 2
    call CriticalError("No slice variants defined.")
  end if
  if (nslc<1 .or. nslc>MS_slicenum) then
    nerr = 3
    call CriticalError("Invalid parameter: slice index.")
  end if
  if (nvar<1 .or. nvar>MSP_FL_varnum) then
    nerr = 4
    call CriticalError("Invalid parameter: variant index.")
  end if
! ------------

! ------------
  if (MSP_FL_varnum<=1 .or. MSP_SLI_filenamestruct==0) then
    ! not more than one variant expected OR multi-variant file structure expected
    ! generate slice file name without variant index
    write(unit=sfname,fmt='(A,I<nsd>.<nsd>,A)') &
     &  trim(MSP_SLC_filenames)//"_",nslc,".sli"
  else
    ! more than one variant expected AND NOT multi-variant file structure expected
    ! generate slice file name with variant index
    write(unit=sfname,fmt='(A,I<nvd>.<nvd>,A,I<nsd>.<nsd>,A)') &
     &  trim(MSP_SLC_filenames)//"_",nvar,"_",nslc,".sli"
  end if

! ------------
!  write(unit=*,fmt=*) " > GetSliceFileName: EXIT."
  return

END SUBROUTINE GetSliceFileName
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE SetGlobalCellParams()
! function: get global supercell data and calculation dimension
!           and global sampling
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams
  use EMSdata
  use MultiSlice

  implicit none

! ------------
! DECLARATION
  integer*4 :: i, j, i1, nslipres
  integer*4 :: nx, ny, nerr, ierr
  integer*4 :: nx1, ny1, nv, nvu, nalloc
  integer*4, allocatable :: slipresent(:,:)
  real*4 :: szx, szy, szz, szx1, szy1, samptest, detmax, htf, ht
  character(len=MSP_ll) :: sfilename
  logical :: fexists
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > SetGlobalCellParams: INIT."
  nerr = 0
  ierr = 0
! ------------

! ------------
  if (MS_slicenum<=0) then
    ierr = 1
    goto 99
  end if
! ------------

! ------------
  call PostMessage("Checking presence of slice files:")
  write(unit=MSP_stmp,fmt='(A,I5)') "  Expected number of slices: ", MS_slicenum
  call PostMessage(trim(MSP_stmp))
  write(unit=MSP_stmp,fmt='(A,I5)') "  Maximum number of variants per slice: ", MSP_FL_varnum
  call PostMessage(trim(MSP_stmp))
  allocate( slipresent(0:MSP_FL_varnum, MS_slicenum), stat=nalloc )
  if (nalloc/=0) then
    ierr = 2
    goto 99
  end if
  slipresent = 0
  nslipres = MS_slicenum
  ! distinguish the file structure modes
  ! 0 : multi-variant file structure
  ! 1 : single variant file structure
  if (MSP_SLI_filenamestruct==0) then ! multi-variant file structure or no variants used
    ! this should be the default way to go ! this takes longer as parameters are load from each file
    i1 = 1
    do i=1, MS_slicenum
      call GetSliceFileName(i,1,sfilename,nerr)
      inquire(file=trim(sfilename),exist=fexists)
      if (.not.fexists) cycle
      call EMS_SLI_loadparams(trim(sfilename),nx1,ny1,nv,ht,szx1,szy1,szz,nerr)
      if (nerr/=0) then
        ierr = 3
        goto 99
      end if
      if (i1==1) then ! remember parameters of the first slice
        htf = ht
        nx = nx1
        ny = ny1
        szx = szx1
        szy = szy1
        i1 = 0
      end if
      ! the number of variants used can be limited by the parameter MSP_FL_varnum
      nvu = min(nv, MSP_FL_varnum)
      slipresent(0,i) = nvu ! save used variants for slice i
      slipresent(1:nvu,i) = 1 ! flag the used variants
      nslipres = nslipres - 1 ! indicate that slice data is present
    end do
  else if (MSP_SLI_filenamestruct==1) then ! single variant file structure
    ! this should usually not happen
    i1 = 1
    do i=1, MS_slicenum
      nvu = 0
      do j=1, MSP_FL_varnum
        call GetSliceFileName(i,j,sfilename,nerr)
        inquire(file=trim(sfilename),exist=fexists)
        if (.not.fexists) cycle
        if (i1==1) then ! only load parameters from the first slice
          call EMS_SLI_loadparams(trim(sfilename),nx,ny,nv,htf,szx,szy,szz,nerr)
          if (nerr/=0) then
            ierr = 4
            goto 99
          end if
          i1 = 0
        end if
        nvu = nvu + 1
        ! the number of variants used can be limited by the parameter MSP_FL_varnum
        if (nvu>MSP_FL_varnum) cycle
        slipresent(0,i) = nvu ! save used variants for slice i
        slipresent(j,i) = 1 ! flag the used variants
      end do
      if (slipresent(0,i)>0) nslipres = nslipres - 1 ! indicate that slice data is present
    end do
  end if
  if (nslipres>0) then ! still not all slice files present,
                       ! this case is treated as critical error
    deallocate( slipresent, stat=nalloc )
    ierr = 5
    goto 99
    return
  end if
  
  

! ------------
  ! At this point we have valid slice data. 
  ! Now we need to index the slice data in MSP_SLC_setup
  ! This is an important step.
  ! ----> The slice index in the phase grating buffer is setup in MSP_SLC_setup
  !       This array will be used by MSP_ALLOCPGR to determine the total number
  !       of phase gratings. It will also serve as index table for later access
  !       of the central phase grating buffer MSP_phasegrt.
  nslipres = 1
  MSP_SLC_num = 0
  do i=1, MS_slicenum
    MSP_SLC_setup(0,i) = slipresent(0,i) ! store the number of used variants
    do j=1, MSP_FL_varnum
      if (slipresent(j,i)==0) cycle ! variant not used, cycle
      MSP_SLC_setup(j,i) = nslipres ! set hash index of the used variant
      nslipres = nslipres + 1 ! increase hash index
      MSP_SLC_num = MSP_SLC_num + 1 ! increase total variant count
    end do
  end do 
  write(unit=MSP_stmp,fmt='(A,I3)') &
     &    "   SLC setup: total number of phase gratings: ",MSP_SLC_num
  call PostDebugMessage(trim(MSP_stmp))
! ------------


! COMMENTED OUT ON 2017-12-12 for version 0.80b
! * redundant loading
!! ------------
!! load & check params -> generate global slice parameters
!  do i=1, MS_slicenum
!    call PostMessage("Start reading slice parameters:")
!    ! generate slice file name
!    call GetSliceFileName(i,1,sfilename,nerr)
!    call EMS_SLI_loadparams(trim(sfilename),nx,ny,nv,ht,szx,szy,szz,nerr)
!    if (nerr/=0) then
!      call CriticalError("Failed to load from EMS SLI file ["//trim(sfilename)//"].")
!    end if
!    call PostMessage("   file ["//trim(sfilename)//"].")
!    write(unit=MSP_stmp,fmt=*) "   data dim x:",nx
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "   data dim y:",ny
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "   number of variants in slice file: ",nv
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "   cell size x [nm]:",szx
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "   cell size y [nm]:",szy
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "   cell size z [nm]:",szz
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "   cell high-tension [kV]:",ht
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "Finished reading slice parameters."
!    call PostMessage(trim(MSP_stmp))
!    ! accumulate min and max values of the main slice parameters
!    maxnx = max(maxnx,nx)
!    maxny = max(maxny,ny)
!    maxht = max(maxht,ht)
!    minnx = min(minnx,nx)
!    minny = min(minny,ny)
!    minht = min(minht,ht)
!    maxszx = max(maxszx,szx)
!    maxszy = max(maxszy,szy)
!    minszx = min(minszx,szx)
!    minszy = min(minszy,szy)
!  end do
  !
  !
  if ( nx>FFT_BOUND_MAX .or. nx<=0 .or. ny>FFT_BOUND_MAX .or. ny<=0 ) then
    ierr = 6
    goto 99
  end if
  if ( szx<=0.0 .or. szy<=0.0 ) then
    ierr = 7
    goto 99
  end if
  ht = STF_WL2HT(STF_lamb)
  if (abs(ht-htf)>1.0) then
    call PostSureMessage("")
    write(unit=MSP_stmp,fmt='(A,G11.4,A,G11.4)') "prm: ",ht," - sli: ",htf
    call PostSureMessage("Inconsistent electron energies [keV] - "//trim(adjustl(MSP_stmp)))
    ierr = 8
    goto 99
  end if
! ------------

! ------------
! set EMS-internal data size
  EMS_SLI_data_dimx = nx
  EMS_SLI_data_dimy = ny
  write(unit=MSP_stmp,fmt=*) "loading with data dim x:",EMS_SLI_data_dimx
  call PostMessage(trim(MSP_stmp))
  write(unit=MSP_stmp,fmt=*) "loading with data dim y:",EMS_SLI_data_dimy
  call PostMessage(trim(MSP_stmp))
  
! set supercell data size
  MSP_dimcellx = nx
  MSP_dimcelly = ny
  write(unit=MSP_stmp,fmt=*) "using global cell data dim x:",MSP_dimcellx
  call PostMessage(trim(MSP_stmp))
  write(unit=MSP_stmp,fmt=*) "using global cell data dim y:",MSP_dimcelly
  call PostMessage(trim(MSP_stmp))
  
! set MS-internal data size
  MS_dimx = nx*MSP_SC_repeatx
  MS_dimy = ny*MSP_SC_repeaty
  write(unit=MSP_stmp,fmt=*) "using global wave data dim x:",MS_dimx
  call PostMessage(trim(MSP_stmp))
  write(unit=MSP_stmp,fmt=*) "using global wave data dim y:",MS_dimy
  call PostMessage(trim(MSP_stmp))
  
! set MS-internal data sampling
  MS_samplingx = szx/real(EMS_SLI_data_dimx)
  MS_samplingy = szy/real(EMS_SLI_data_dimy)
  write(unit=MSP_stmp,fmt=*) "using global cell sampling rate x [nm/pix]:",MS_samplingx
  call PostMessage(trim(MSP_stmp))
  write(unit=MSP_stmp,fmt=*) "using global cell sampling rate y [nm/pix]:",MS_samplingy
  call PostMessage(trim(MSP_stmp))
  ! check detector maximum radius against simulation maximum spatial frequency
  detmax = MS_detmaxang
!  if (MSP_usedetdef==1 .and. MSP_detnum>0) then
  detmax = 0.0
  do i=1, MSP_detnum
    detmax = max(MSP_detdef(10,i),detmax)
  end do
!  end if
  if (MSP_ctemmode==0) then
    samptest = 0.5/MS_samplingx*MS_lamb*0.667*1000.0
    if (samptest<detmax) then
      call PostWarning("Maximum detection angle is larger than 2/3-gmax multislice aperture (X).")
      write(unit=MSP_stmp,fmt=*) "  max. detection angle [mrad]:",detmax
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt=*) "  2/3-gmax multislice aperture (X) [mrad]:",samptest
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt=*) "  Use a finer horizontal supercell sampling or smaller detection angles!"
      call PostMessage(trim(MSP_stmp))
    end if
    samptest = 0.5/MS_samplingy*MS_lamb*0.667*1000.0
    if (samptest<detmax) then
      call PostWarning("Maximum detection angle is larger than 2/3-gmax multislice aperture (Y).")
      write(unit=MSP_stmp,fmt=*) "  max. detection angle [mrad]:",detmax
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt=*) "  2/3-gmax multislice aperture (Y) [mrad]:",samptest
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt=*) "  Use finer vertical supercell sampling or smaller detector semi angles!"
      call PostMessage(trim(MSP_stmp))
    end if
  end if
! ------------

! ------------
! exit part
99 if (allocated(slipresent)) deallocate( slipresent, stat=nalloc )
  select case (ierr) ! error handling
  case (0)
    return
  case (1)
    call CriticalError("No slice definitions specified.")
  case (2)
    call CriticalError("Memory allocation failed.")
  case (3)
    call CriticalError("Failed to read parameters from slice file.")
  case (4)
    call CriticalError("Failed to read size parameters from first slice file.")
  case (5)
    call CriticalError("Required slice data is not completely present.")
  case (6)
    write(unit=MSP_stmp,fmt='(I5," x ",I5)') nx, ny
    call CriticalError("Invalid slice file sampling ("// &
       & trim(adjustl(MSP_stmp))//").")
  case (7)
    write(unit=MSP_stmp,fmt='(G11.4," x ",G11.4)') szx, szy
    call CriticalError("Invalid slice physical frame size ("// &
       & trim(adjustl(MSP_stmp))//") nm^2.")
  case (8)
    call CriticalError("Electron energy input parameter and slice files are inconsistent.")
  end select ! case(nerr)
!  write(unit=*,fmt=*) " > SetGlobalCellParams: EXIT."
  return

END SUBROUTINE SetGlobalCellParams
!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
SUBROUTINE PrepareSupercells()
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! REMARKS:
! - requires a previous call of MSP_PREALLOCPGR, SetGlobalCellParams,
!   and MSP_ALLOCPGR
! - requires MSP_SLC_setup to be set up completely
! -------------------------------------------------------------------- !

  use MSAparams
  use EMSdata
  use MultiSlice

  implicit none

! ------------
! DECLARATION
  integer*4 :: i, j, nerr, nv, ni1, ni2
  real*4 :: szz, szz1
  character(len=MSP_ll) :: sfilename
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PrepareSupercells: INIT."
  if (.not.allocated(MSP_phasegrt)) then
    call CriticalError("Slice data memory not allocated.")
  end if
! ------------

! ------------
  if (MS_slicenum<=0) then
    call CriticalError("No slice definitions specified.")
  end if
  if (MS_stacksize<=0) then
    call CriticalError("No object slices specified.")
  end if
  if (EMS_SLI_data_dimx*EMS_SLI_data_dimy<=0) then
    call CriticalError("Invalid data size.")
  end if
  if (MSP_FL_varnum<1) then
    call CriticalError("Invalid number of slice variants.")
  end if
! ------------


! ------------
  MS_slicestack(1:MS_stacksize) = MSP_SLC_object(1:MS_stacksize)
  call PostMessage("Object slice sequence set.")
! ------------


! ------------
! load data
  call PostMessage("Start loading slice data.")
  do i=1, MS_slicenum ! loop through slices
  
  
    if (0==MSP_SLI_filenamestruct) then
      
      ! generate slice file name
      call GetSliceFileName(i,1,sfilename,nerr)
      if (nerr/=0) call CriticalError("Failed to generate slice file name from parameters.")
      ! this loading version expects also that the variants of one slice appear
      ! in sequence in MSP_phasegrt
      nv = MSP_SLC_setup(0,i) ! number of variants present for this slice
      ni1 = MSP_GetPGRIndex(1,i,nerr) ! get index of the first variant
      ni2 = MSP_GetPGRIndex(nv,i,nerr) ! get index of the last variant
      
      call EMS_SLI_loaddata(trim(sfilename), &
     &       MSP_dimcellx, MSP_dimcelly, nv, &
     &       MSP_phasegrt(1:MSP_dimcellx,1:MSP_dimcelly,ni1:ni2), szz, nerr)
      if (nerr/=0) then
        call CriticalError("Failed to load from EMS SLI file ["//trim(sfilename)//"].")
      end if
      
      ! file info
      write(unit=MSP_stmp,fmt='(A)') "   file : "//trim(sfilename)
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt='(A)') "   title: "//trim(EMS_SLI_data_title)
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt='(A,G11.4)') "   slice thickness [nm]: ",szz
      call PostMessage(trim(MSP_stmp))
      write(unit=MSP_stmp,fmt='(A,G11.4)') "   slice electron energy [keV]: ",EMS_SLI_data_ht
      call PostMessage(trim(MSP_stmp))
      !
      szz1 = szz
      MSP_SLC_title(i) = EMS_SLI_data_title
      !
      write(unit=MSP_stmp,fmt='(A,I4,A,I4,A,I4,A)') &
     &      "   data : ",nv," variants loaded to indices ",ni1," .. ",ni2,"."
      call PostDebugMessage(trim(MSP_stmp))
      
    else ! (0/=MSP_SLI_filenamestruct)
      
      ! this loading version expects only one variant per file
      nv = MSP_SLC_setup(0,i) ! number of variants present for this slice
      
      do j=1, MSP_FL_varnum ! loop through all possible slice variants  
        ni1 = MSP_GetPGRIndex(j,i,nerr) ! get index of the variant, also indicates file presence, which is not checked again here
        if (ni1<=0) cycle ! skip the variant index in case of absent data
        ! generate slice file name
        call GetSliceFileName(i,j,sfilename,nerr)
        if (nerr/=0) call CriticalError("Failed to generate slice file name from parameters.")
        
        call EMS_SLI_loaddata(trim(sfilename), &
     &       MSP_dimcellx, MSP_dimcelly, 1, &
     &       MSP_phasegrt(1:MSP_dimcellx,1:MSP_dimcelly,ni1:ni1), szz, nerr)
        if (nerr/=0) then
          call CriticalError("Failed to load from EMS SLI file ["//trim(sfilename)//"].")
        end if
        ! file info
        write(unit=MSP_stmp,fmt='(A)') "   file : "//trim(sfilename)
        call PostMessage(trim(MSP_stmp))
        write(unit=MSP_stmp,fmt='(A)') "   title: "//trim(EMS_SLI_data_title)
        call PostMessage(trim(MSP_stmp))
        write(unit=MSP_stmp,fmt='(A,G11.4)') "   slice thickness [nm]:",szz
        call PostMessage(trim(MSP_stmp))
        write(unit=MSP_stmp,fmt='(A,G11.4)') "   slice electron energy [keV]: ",EMS_SLI_data_ht
        call PostMessage(trim(MSP_stmp))
        
        write(unit=MSP_stmp,fmt='(A,I4,A,I4,A)') &
     &      "   data : variant #",j," loaded to index ",ni1,"."
        call PostDebugMessage(trim(MSP_stmp))
      
        if (j==1) then 
          szz1 = szz
          MSP_SLC_title(i) = EMS_SLI_data_title
        end if
        
      end do ! variant loop
    
    end if
    
    call PostMessage("Preparing slice data for usage.")
    nerr = MS_err_num
    call MS_PrepareSlice(i, szz1)
    
    if (EMS_SLI_data_ctype==1) then ! loaded potential data
      call PostMessage("Transforming loaded potential data to phase gratings")
      nv = MSP_SLC_setup(0,i) ! number of variants present for this slice
      ni1 = MSP_GetPGRIndex(1,i,nerr) ! get index of the first variant
      ni2 = MSP_GetPGRIndex(nv,i,nerr) ! get index of the last variant
      call MS_SlicePot2Pgr( EMS_SLI_data_ht, szz1, MSP_nabf, MSP_Absorption, &
                          & MSP_nbuni, MSP_Buni, &
                          & MSP_dimcellx, MSP_dimcelly, ni2-ni1+1, &
                          & MSP_phasegrt(1:MSP_dimcellx,1:MSP_dimcelly,ni1:ni2), nerr )
      if (nerr/=0) then
        call CriticalError("Failed to load phase gratings from EMS SLI file ["//trim(sfilename)//"].")
      end if
    end if
  
  end do ! slice loop (i)
  call PostMessage("Finished loading slice data.")
! ------------

! ------------
! Prepare propagators
  call PostMessage("Preparing propagators.")
  if (MSP_use_fre==1) then
    call PostMessage("Preparing Fresnel propagators.")
    call MS_PreparePropagators() ! this creates Fresnel propagators (paraxial approximation)
  else
    call PostMessage("Preparing large-angle propagators.")
    call MS_PreparePropagators2() ! this creates large-angle propagators (no paraxial approximation)
  end if
! ------------

! ------------
  call PostMessage("Supercell data prepared.")
  !  write(unit=*,fmt=*) " > PrepareSupercells: EXIT."
  return

END SUBROUTINE PrepareSupercells
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE PrepareWavefunction()
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MultiSlice
  use STEMfunctions
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr, i, j, nalloc
  real*4 :: rpower, rpowscale
  complex*8, allocatable :: cdata(:,:)
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > PrepareWavefunction: INIT."
  allocate(cdata(MS_dimy,MS_dimx),stat=nalloc)
  if (nalloc/=0) then
    call CriticalError("Failed to allocate memory for incident wavefunction.")
  end if
  cdata = cmplx(0.0,0.0)
! ------------


! --------------
  nerr = STF_err_num
  STF_beam_tiltx = MSP_BeamTiltX
  STF_beam_tilty = MSP_BeamTiltY
  if (MSP_ctemmode==1) then ! PLANE WAVE FOR TEM
    call STF_PreparePlaneWaveFourier(MS_dimx,MS_dimy,MS_samplingx,MS_samplingy)
  else ! STEM
    if (MSP_Vortex==0) then ! DEFAULT STEM PROBE
      call STF_PrepareProbeWaveFourier(MS_dimx,MS_dimy,MS_samplingx,MS_samplingy)
    else ! STEM VORTEX PROBE (added 2017-10-17 by JB)
      call STF_PrepareVortexProbeWaveFourier(MSP_Vortex,MS_dimx,MS_dimy,MS_samplingx,MS_samplingy)
    end if
  end if
  if (nerr/=STF_err_num) then
    if (allocated(cdata)) deallocate(cdata, stat=nalloc)
    call CriticalError("Failed to create wavefunction.")
  end if
! normalize to power=1.0 and transfer to dummy memory
  rpower = STF_PreparedWavePower
  rpowscale = sqrt(1.0/rpower) !/real(nx*ny))
  do j=1, MS_dimx
    do i=1, MS_dimy
      cdata(i,j) = rpowscale*STF_sc(i,j)
    end do
  end do
! --------------

! ------------
! transfer to multislice module
  nerr = MS_err_num
  call MS_SetIncomingWave(cdata)
  if (nerr/=MS_err_num) then
    if (allocated(cdata)) deallocate(cdata, stat=nalloc)
    call CriticalError("Failed to save wavefunction in multislice module.")
  end if
! ------------

! ------------
  if (allocated(cdata)) deallocate(cdata, stat=nalloc)
!  write(unit=*,fmt=*) " > PrepareWavefunction: EXIT."
  return

END SUBROUTINE PrepareWavefunction
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE InsertExternalWavefunction()
! function: 
!   Loads wave function data (real-space or Fourier space) from file
!   and transfers the data to the module memory
!
!   This function was inserted with version 0.60b - 14.06.2012 (JB)
!   * modified with version 0.78b - 09.11.2017 (JB)
!     now supporting the insertion of Fourier space wave functions
!
!   - loads the input wave function data from file
!   - Fourier-Transforms the data (depends on MSP_extinwform)
!   - copies the FS data to the MS-module backup wave
!
!   Use MS_OffsetIncomingWave(0.0,0.0,0.0) ONCE before running the
!   modified multislice
!
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr, j, nlfu, nalloc
  complex*8, allocatable :: cdata(:,:), cdataft(:,:)
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > InsertExternalWavefunction: INIT."
  if (.not.allocated(MS_sc)) goto 101
! allocate memory for loading the wave function
  allocate( cdata(MS_dimx,MS_dimy), cdataft(MS_dimy, MS_dimx), stat=nalloc)
  if (nalloc/=0) goto 102
  cdata = cmplx(0.0,0.0)
  cdataft = cmplx(0.0,0.0)
! ------------


! ------------
! Load the wave data from file
  call PostMessage("- Loading input wave function from file ["//trim(MSP_inwfile)//"].")
  call GetFreeLFU(nlfu,20,100)
! open the input file
  open(unit=nlfu, file=trim(MSP_inwfile), form="binary", access="sequential", &
     & iostat=nerr, status="old", action="read", share='DENYWR' )
  if (nerr/=0) goto 103
  
  if (MSP_extinwform==0) then
  ! load real space wave function
    read(unit=nlfu,iostat=nerr) cdata
  else
  ! load Fourier space wave function
    read(unit=nlfu,iostat=nerr) cdataft
  end if
! handle loading error
  if (nerr/=0) goto 104
! close the input file  
  close(unit=nlfu)
  call PostMessage("- Successful read of insert wave function.")
! ------------

! ------------
! Apply FT in case of a real-space input
  if (MSP_extinwform==0) then
    MS_sc = cmplx(0.0,0.0)
    do j=1, MS_dimy
      MS_sc(1:MS_dimx,j) =  cdata(1:MS_dimx,j)
    end do
  ! transform the data to Fourier space
    call MS_FFT(MS_sc,MS_dimx,MS_dimy,'for')
  ! transfer the loaded data to the result array
    do j=1, MS_dimx
      cdataft(1:MS_dimy,j) =  MS_sc(1:MS_dimy,j)
    end do
  end if
! ------------

! ------------
! transfer the wave data to multislice module (backup)
  nerr = MS_err_num
  call MS_SetIncomingWave(cdataft)
  if (nerr/=MS_err_num) goto 105
! ------------

! ------------
!  write(unit=*,fmt=*) " > InsertExternalWavefunction: EXIT."
99 continue
  if (allocated(cdata)) deallocate(cdata,stat=nalloc) 
  if (allocated(cdataft)) deallocate(cdataft,stat=nalloc) 
  return

! error handling
101 continue
  if (allocated(cdata)) deallocate(cdata,stat=nalloc) 
  if (allocated(cdataft)) deallocate(cdataft,stat=nalloc) 
  call CriticalError("Multislice module is not initialized.")
  return
102 continue
  if (allocated(cdata)) deallocate(cdata,stat=nalloc) 
  if (allocated(cdataft)) deallocate(cdataft,stat=nalloc) 
  call CriticalError("Allocation of memory for input wave failed.")
  return
103 continue
  if (allocated(cdata)) deallocate(cdata,stat=nalloc) 
  if (allocated(cdataft)) deallocate(cdataft,stat=nalloc) 
  write(unit=MSP_stmp,fmt='(I)') nerr
  call CriticalError("Failed to connect to file ["// &
     & trim(MSP_inwfile)//"] - Code ("//trim(adjustl(MSP_stmp))//").")
  return
104 continue
  if (allocated(cdata)) deallocate(cdata,stat=nalloc) 
  if (allocated(cdataft)) deallocate(cdataft,stat=nalloc) 
  write(unit=MSP_stmp2,fmt='(I)') nerr
  write(unit=MSP_stmp,fmt='(A,I4,A,I4,A)') &
     &    "Failed to read all ",MS_dimx,"x",MS_dimy, &
     &    " 64-bit complex*8 data values - Code("//trim(adjustl(MSP_stmp2))//")."
  call CriticalError(trim(MSP_stmp))
  return
105 continue
  if (allocated(cdata)) deallocate(cdata,stat=nalloc) 
  if (allocated(cdataft)) deallocate(cdataft,stat=nalloc) 
  call CriticalError("Failed to save wavefunction in multislice module.")
  return

END SUBROUTINE InsertExternalWavefunction
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE DetectorReadout(rdata, ndet, nret)
! SUBROUTINE: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams
  
  implicit none

! ------------
! DECLARATION
  integer*4 :: nret, ndet, i, j, k, i0, i1
  real*4 :: dval, rval, rdata(ndet)
  complex*8 :: cval
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > DetectorReadout: INIT."
  nret = 1
  if (0==MS_status) then
    call CriticalError("DetectorReadout: module not initialized.")
    return ! skip if data array not ready
  end if
! ------------

! ------------
  rdata = 0.0
  do k=1, ndet
    if ( 0 == nint(MSP_detdef(0,k)) ) cycle
    
    do j=1, MS_dimx
      if (MSP_detcols(1,j,k)==0) cycle
      i0 = MSP_detcols(2,j,k)
      i1 = MSP_detcols(3,j,k)
      do i=i0, i1
        dval = MSP_detarea(i,j,k)
        if (dval/=0.0) then
          cval = MS_wave(i,j) ! get Fourier-space wave data
          rval = real(cval*conjg(cval)) ! get power
          rdata(k) = rdata(k) + rval*dval
        end if
      end do
    end do
    
  end do
  nret = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > DetectorReadout: EXIT."
  return

END SUBROUTINE DetectorReadout
!**********************************************************************!



!!**********************************************************************!
!!**********************************************************************!
!SUBROUTINE DetectorImgExport(ndet, nret)
!! SUBROUTINE: 
!! -------------------------------------------------------------------- !
!! parameter: 
!! -------------------------------------------------------------------- !
!
!  use MultiSlice
!  use MSAparams
!  
!  implicit none
!
!! ------------
!! DECLARATION
!  integer*4 :: nthread, nret, ndet, i, j, k, n, i0, i1
!  real*4 :: rval
!! ------------
!
!! ------------
!! INIT
!!  write(unit=*,fmt=*) " > DetectorImgExport: INIT."
!  nret = 1
!  if (0==MS_status) then
!    call CriticalError("DetectorReadout: module not initialized.")
!    return ! skip if data array not ready
!  end if
!! ------------
!
!! ------------
!  rdata = 0.0
!  call PostMessage("Exporting detector segment images.")
!  
!!  if (MSP_usedetdef==1) then ! collect for all detectors
!  do k=1, ndet
!    
!    do j=1, MS_dimx
!      if (MSP_detcols(1,j,k)==0) cycle
!      i0 = MSP_detcols(2,j,k)
!      i1 = MSP_detcols(3,j,k)
!      do i=i0, i1
!        if (MSP_detarea(i,j,k)==1) then
!          cval = MS_wave(i,j) ! get Fourier-space wave data
!          rval = real(cval*conjg(cval)) ! get power
!          rdata(k) = rdata(k) + rval
!        end if
!      end do
!    end do
!    
!  end do
!  
!!  write(*,*) rdata
!  
!!  else ! collect for the standard detector
!!  
!!    do j=1, MS_dimx
!!      if (MS_detcols(1,j)==0) cycle
!!      i0 = MS_detcols(2,j)
!!      i1 = MS_detcols(3,j)
!!      do i=i0, i1
!!        if (MS_detarea(i,j)==1) then
!!          cval = MS_wave(i,j) ! get Fourier-space wave data
!!          rval = real(cval*conjg(cval)) ! get power
!!          rdata(1) = rdata(1) + rval
!!        end if
!!      end do
!!    end do
!!  end if
!!  end if ! (MS_excludeelastic==0)
!  
!!! INELASTICALLY SCATTERED WAVE
!!  if (MS_useinelastic/=0) then
!!  if (DEBUG_EXPORT==1) then
!!    write(unit=*,fmt=*) " > Collecting inelastically scattered wave power."
!!  end if
!!! do loop over all slices and collect inelastically scattered intensities
!!! all waves are already in fourier space
!!  n = min(MS_lastmaxslice-1,MS_stacksize)
!!  if (n>0) then
!!    do k=1, n
!!      do j=1, MS_dimx
!!        if (MS_detcols(1,j)==0) cycle
!!        i0 = MS_detcols(2,j)
!!        i1 = MS_detcols(3,j)
!!        do i=i0, i1
!!          if (MS_detarea(i,j)==1) then
!!            cval = MS_absorbed(i,j,k)
!!            rval = real(cval*conjg(cval)) ! get power
!!            rdata = rdata + rval
!!          end if
!!        end do
!!      end do
!!    end do
!!  end if
!!! done
!!  end if ! (MS_useinalestic/=0)
!  nret = 0
!! ------------
!
!! ------------
!!  write(unit=*,fmt=*) " > DetectorImgExport: EXIT."
!  return
!
!END SUBROUTINE DetectorImgExport
!!**********************************************************************!



!!**********************************************************************!
!!**********************************************************************!
!SUBROUTINE DetectorReadoutSpecial(rdata, rlost, nret)
!! SUBROUTINE: SPECIAL VERSION which tracks also lost power
!! -------------------------------------------------------------------- !
!! parameter: 
!! -------------------------------------------------------------------- !
!
!  use MultiSlice
!  use MSAparams
!  
!  implicit none
!
!! ------------
!! DECLARATION
!  integer*4 :: nret, i, j, k, n
!  integer*4 :: ndimx, ndim2x, ndimy, ndim2y
!  real*4 :: rval, rdata, rlost, rtotal
!  complex*8 :: cval
!! ------------
!
!! ------------
!! INIT
!!  write(unit=*,fmt=*) " > DetectorReadoutSpecial: INIT."
!  nret = 1
!  if (0==MS_status) then
!    call CriticalError("DetectorReadoutSpecial: module not initialized.")
!    return ! skip if data array not ready
!  end if
!! ------------
!
!! ------------
!  rdata = 0.0
!  rtotal = 0.0
!! ELASTICALLY SCATTERED WAVE
!! *** We have to integrate the wave data in Fourierspace
!! do loop in transposed order and don't forget to (un)scramble
!!  if (MS_excludeelastic==0) then
!  call PostMessage("Collecting elastically scattered wave power.")
!  ! consider elastic data in result and power sum
!  do j=1, MS_dimx
!    do i=1, MS_dimy
!      cval = MS_wave(i,j) ! get Fourier-space wave data
!      rval = real(cval*conjg(cval)) ! get power
!      rtotal = rtotal + rval
!      if (MS_detarea(i,j)==1) rdata = rdata + rval
!    end do
!  end do
!!  else ! if (MS_excludeelastic/=0)
!!  ! consider elastic data in power sum only
!!  do j=1, MS_dimx
!!    do i=1, MS_dimy
!!      cval = MS_wave(i,j) ! get Fourier-space wave data
!!      rval = real(cval*conjg(cval)) ! get power
!!      rtotal = rtotal + rval
!!    end do
!!  end do
!!  end if ! (MS_excludeelastic==0)
!  
!!! INELASTICALLY SCATTERED WAVE
!!  if (MS_useinelastic/=0) then
!!  if (DEBUG_EXPORT==1) then
!!    write(unit=*,fmt=*) " > Collecting inelastically scattered wave power."
!!  end if
!!! do loop over all slices and collect inelastically scattered intensities
!!! all waves are already in fourier space
!!! consider inelastic data in result and power sum
!!  n = min(MS_lastmaxslice-1,MS_stacksize)
!!  if (n>0) then
!!    do k=1, n
!!      do j=1, MS_dimx
!!        do i=1, MS_dimy
!!          cval = MS_absorbed(i,j,k)
!!          rval = real(cval*conjg(cval)) ! get power
!!          rtotal = rtotal + rval
!!          if (MS_detarea(i,j)==1) rdata = rdata + rval
!!        end do
!!      end do
!!    end do
!!  end if ! (n>0)
!!  else ! (MS_useinelastic/=0)
!!  ! consider inelastic data in power sum only
!!  n = min(MS_lastmaxslice-1,MS_stacksize)
!!  if (n>0) then
!!    do k=1, n
!!      do j=1, MS_dimx
!!        do i=1, MS_dimy
!!          cval = MS_absorbed(i,j,k)
!!          rval = real(cval*conjg(cval)) ! get power
!!          rtotal = rtotal + rval
!!        end do
!!      end do
!!    end do
!!  end if
!!! done
!!  end if ! (MS_useinalestic/=0)
!  rlost = 1.0-rtotal
!  nret = 0
!! ------------
!
!! ------------
!!  write(unit=*,fmt=*) " > DetectorReadoutSpecial: EXIT."
!  return
!
!END SUBROUTINE DetectorReadoutSpecial
!!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
SUBROUTINE ApplySpatialCoherence()
! purpose: Does source function convolution, expects real data
!          with given stem image size.
!          Will try to load many images sequentially from the input
!          file, convolute each, and stores them back to the output.
! -------------------------------------------------------------------- !
! parameter: 
!          None.
! -------------------------------------------------------------------- !

  use MultiSlice
  use STEMfunctions
  use MSAparams
  
  implicit none

! ------------
! DECLARATION
  integer*4 :: nlfu, mlfu, nerr, nalloc, npln, ioerr
  real*4 :: sx, sy
  real*4, allocatable :: rdata(:,:)
  external :: createfilefolder
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ApplySpatialCoherence: INIT."
  nerr = 0
  ioerr = 0
  nalloc = 0
  if (MSP_ctemmode==1) then
    call PostWarning("Inconsistent parameters: Deactivate either"//&
     & " CTEM mode or application of partial spatial coherence.")
    call PostMessage("Aborting application of partial spatial coherence")
    return
  end if
  ! calculate sampling of multislice image
  sx = MSP_SF_sizex/real(MSP_SF_ndimx)
  sy = MSP_SF_sizey/real(MSP_SF_ndimy)
  ! allocate data array for loading images
  allocate(rdata(MSP_SF_ndimx,MSP_SF_ndimy), stat=nalloc)
  if (nalloc/=0) then
    call CriticalError("Failed to allocate memory for reading data.")
    goto 99
  end if
  rdata = 0.0
! ------------

! ------------
! - connect input file
  call GetFreeLFU(nlfu,20,100)
  open(unit=nlfu, file=trim(MSP_infile), form='binary', &
     & access='sequential', iostat=ioerr, status="old", &
     & action="read", share='DENYNONE' )
  if (ioerr/=0) then
    nerr = 1
    goto 99
  end if
  call PostMessage("Reading STEM image from file ["//trim(MSP_infile)//"].")
! - connect output file
  call GetFreeLFU(mlfu,20,100)
  call createfilefolder(trim(MSP_outfile),nerr)
  open(unit=mlfu, file=trim(MSP_outfile), form='binary', access='sequential', &
     & iostat=nerr, status="replace", action="write", share='DENYRW' )
  if (ioerr/=0) then
    nerr = 2
    goto 99
  end if
  call PostMessage("Writing convoluted STEM image to file ["//trim(MSP_outfile)//"].")
! ------------

! ------------
! - read - convolution - write loop
  npln = 0
  do ! repeated reading trials
    !
    ! - read data
    !
    read(unit=nlfu, iostat=ioerr) rdata
    if (ioerr/=0) exit ! read failed: no (more) data to handle
    !
    ! - convolute data
    !
    npln = npln + 1
    write(unit=MSP_stmp, fmt=*) npln
    call PostMessage("- convoluting image "//trim(adjustl(MSP_stmp)))
    ioerr = MS_err_num
    call MS_ApplyPSpatialCoh(rdata,MSP_SF_ndimx,MSP_SF_ndimy,&
     &                       sx,sy,STF_srcradius,MSP_PC_spatial)
    if (ioerr/=MS_err_num) then
      nerr = 3
      goto 99
    end if
    !
    ! - write data
    !
    write(unit=mlfu, iostat=ioerr) rdata
    if (ioerr/=0) then
      nerr = 4
      goto 99
    end if
    !
  end do ! loop
  !
  ! disconnect from files
  close(unit=mlfu, iostat=ioerr)
  close(unit=nlfu, iostat=ioerr)
  !
  call PostMessage("STEM image convolution finished.")
  !
! ------------


! ------------
! exit point (in any case jump here finally)
99 if (allocated(rdata)) deallocate(rdata, stat=nalloc)
! finishing and critical error handling 
!  write(unit=*,fmt=*) " > ApplySpatialCoherence: EXIT."
  select case (nerr)
    case (1)
      call CriticalError("Failed to connect to file ["// &
         & trim(MSP_infile)//"].")
    case (2)
      close(unit=nlfu, iostat=ioerr)
      call CriticalError("Failed to connect to file ["// &
         & trim(MSP_outfile)//"].")
    case (3)
      close(unit=nlfu, iostat=ioerr)
      close(unit=mlfu, iostat=ioerr)
      call CriticalError("Image convolution failed.")
    case (4)
      close(unit=nlfu, iostat=ioerr)
      close(unit=mlfu, iostat=ioerr)
      call CriticalError("Failed to write output.")
  end select ! case (nerr)
  
  return

END SUBROUTINE ApplySpatialCoherence
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE AberrateWave()
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use STEMfunctions
  use MultiSlice

  implicit none

! ------------
! DECLARATION
  integer*4 :: i, j, nerr
  complex*8, allocatable, dimension(:,:) :: wave
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > AberrateWave: INIT."
  if (0==MS_status) then
    call CriticalError("AberrateWave: module not initialized.")
  end if
  allocate(wave(MS_dimy,MS_dimx),stat=nerr)
  if (nerr/=0) then
    call CriticalError("AberrateWave: Memory allocation failed.")
  end if
! ------------

! ------------
  do j=1, MS_dimx
    do i=1, MS_dimy
      wave(i,j) = MS_wave(i,j)
    end do
  end do
! ------------

! ------------
  nerr = STF_err_num
  call STF_AberrateWaveFourier(wave,MS_dimx,MS_dimy,MS_samplingx,MS_samplingy)
  if (nerr/=STF_err_num) then
    if (allocated(wave)) deallocate(wave,stat=nerr)
    call CriticalError("Failed to apply aberrations.")
  end if
! ------------

! ------------
  do j=1, MS_dimx
    do i=1, MS_dimy
      MS_wave(i,j) = wave(i,j)
    end do
  end do
! ------------

! ------------
  if (allocated(wave)) deallocate(wave,stat=nerr)
!  write(unit=*,fmt=*) " > AberrateWave: EXIT."
  return

END SUBROUTINE AberrateWave
!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
SUBROUTINE ApplyObjAp()
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use STEMfunctions
  use MultiSlice
  

  implicit none

! ------------
! DECLARATION
  integer*4 :: i, j, nerr
  complex*8, allocatable, dimension(:,:) :: wave
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > AberrateWave: INIT."
  if (0==MS_status) then
    call CriticalError("ApplyObjAp: module not initialized.")
  end if
  allocate(wave(MS_dimy,MS_dimx),stat=nerr)
  if (nerr/=0) then
    call CriticalError("ApplyObjAp: Memory allocation failed.")
  end if
! ------------

! ------------
  do j=1, MS_dimx
    do i=1, MS_dimy
      wave(i,j) = MS_wave(i,j)
    end do
  end do
! ------------

! ------------
  nerr = STF_err_num
  call STF_ApplyObjectiveAperture(wave,MS_dimx,MS_dimy, &
     &                                 MS_samplingx,MS_samplingy,&
     &                                 MS_objtiltx*MS_rd2r,MS_objtilty*MS_rd2r)
  if (nerr/=STF_err_num) then
    if (allocated(wave)) deallocate(wave,stat=nerr)
    call CriticalError("Failed to apply aberrations.")
  end if
! ------------

! ------------
  do j=1, MS_dimx
    do i=1, MS_dimy
      MS_wave(i,j) = wave(i,j)
    end do
  end do
! ------------

! ------------
  if (allocated(wave)) deallocate(wave,stat=nerr)
!  write(unit=*,fmt=*) " > ApplyObjAp: EXIT."
  return

END SUBROUTINE ApplyObjAp
!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
SUBROUTINE MSACalculate()

  use MultiSlice
  use MSAparams

  implicit none
  
  integer*4 :: nerr, nslc, nvar, nslcidx
  
  real*4, external :: UniRand
  
  nerr = 0

! setup new multislice
  nerr = MS_err_num
  if (MSP_use_extinwave==1) then
    call MS_Start(MSP_extinwslc)
  else
    call MS_Start()
  end if
  if (nerr/=MS_err_num) return

! loop over all slices the multislice
  do while (MS_slicecur >= 0.and. MS_slicecur<MS_stacksize)
    nerr = MS_err_num
    nslc = MS_slicestack(MS_slicecur+1)+1
    nvar = 1 + int( UniRand()*real(MSP_SLC_setup(0,nslc))*0.9999 )
!    if (DEBUG_EXPORT>=1) then
!      write(unit=MSP_stmp,fmt='(A,I3.3,A,I3.3,A)') "- calculating slice ",nslc,", variant ",nvar,"."
!      call PostMessage(trim(MSP_stmp))
!    end if
    nslcidx = MSP_GetPGRIndex(nvar,nslc,nerr)
    if (nerr/=0) return
    call MS_CalculateNextSlice(MSP_phasegrt(1:MSP_dimcellx,1:MSP_dimcelly,nslcidx),MSP_dimcellx,MSP_dimcelly)
    if (nerr/=MS_err_num) return
  end do ! while (MS_slicecur >= 0)

! Stop the multislice
  nerr = MS_err_num
  call MS_Stop()
  if (nerr/=MS_err_num) return
  
  return

END SUBROUTINE MSACalculate
!**********************************************************************!



!!**********************************************************************!
!!**********************************************************************!
!SUBROUTINE DoMultiSlice()
!! function: 
!! -------------------------------------------------------------------- !
!! parameter: 
!! -------------------------------------------------------------------- !
!
!  use MultiSlice
!  use MSAparams
!
!  implicit none
!
!! ------------
!! DECLARATION
!  integer*4 :: nz, nerr, nznum, i, j, j1, i1, ndet, nalloc, nv, nvar, nvarnum
!  real*4 :: scansampx, scansampy, scanposx, scanposy
!  real*4 :: dzcurr, zstep, zoffset, zpow, zrescale, fafac, fascal, vrescale
!  real*4 :: ffac
!  real*4, allocatable :: rtmpresult(:), tempsum(:)
!!  real*4 :: rtmp(1:MS_dimx,1:MS_dimy)
!! ------------
!
!! ------------
!! INIT
!!  write(unit=*,fmt=*) " > DoMultiSlice: INIT."
!  ndet = 1
!  if (MSP_usedetdef==1.and.MSP_detnum>1) then
!    ndet = MSP_detnum
!  end if
!  allocate(rtmpresult(ndet),tempsum(ndet),stat=nalloc)
!  scansampx = 0.0
!  if (MSP_SF_sizex>0.0.and.MSP_SF_ndimx>1) then
!    scansampx = MSP_SF_sizex/real(MSP_SF_ndimx)
!  end if
!  scansampy = 0.0
!  if (MSP_SF_sizey>0.0.and.MSP_SF_ndimy>1) then
!    scansampy = MSP_SF_sizey/real(MSP_SF_ndimy)
!  end if
!  scanposx = MSP_SF_offsetx + MSP_SF_rotcos*MSP_ScanPixelX*scansampx - MSP_SF_rotsin*MSP_ScanPixelY*scansampy
!  scanposy = MSP_SF_offsety + MSP_SF_rotcos*MSP_ScanPixelY*scansampy + MSP_SF_rotsin*MSP_ScanPixelX*scansampx
!!  if (MSP_ctemmode==0.and.DEBUG_EXPORT>0) then
!!    write(unit=MSP_stmp,fmt=*) "Collecting data for ",ndet," detectors."
!!    call PostMessage(trim(MSP_stmp))
!!    write(unit=MSP_stmp,fmt=*) "Scan shift rel. to supercell origin [nm]:",scanposx,scanposy
!!    call PostMessage(trim(MSP_stmp))
!!  end if
!! ------------
!
!! ------------
!  nznum = 1
!  zstep = 0.0
!  zoffset = 0.0
!  zrescale = 1.0
!  zpow = 0.0
!  fafac = 0.0
!  fascal = 0.0
!  if (MSP_ctemmode==1) then
!    scanposx = 0.0
!    scanposy = 0.0
!    MSP_PC_temporal = 0
!  end if
!  if ( (MSP_PC_temporal/=0).and.(STF_defocusspread<=0.0) ) then
!    call PostWarning("Specified defocus spread is invalid.")
!    call PostWarning("Explicit focal averaging switched off.")
!    MSP_PC_temporal = 0
!  end if
!  if ( (MSP_PC_temporal/=0).and.(STF_DEFOCUS_KERNEL_STEPS<=1) ) then
!    call PostWarning("Specified defocus kernal step is invalid.")
!    call PostWarning("Explicit focal averaging switched off.")
!    MSP_PC_temporal = 0
!  end if
!  if (MSP_PC_temporal/=0) then
!    nznum = STF_DEFOCUS_KERNEL_STEPS
!    zoffset = -STF_DEFOCUS_KERNEL_SPREAD*STF_defocusspread
!    zstep = -2.0*zoffset / real( nznum-1 )
!    fafac = -1.0/STF_defocusspread/STF_defocusspread
!    write(unit=MSP_stmp,fmt=*) "Performing explicit focal averaging:"
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "  focal range [nm]: +/-",STF_DEFOCUS_KERNEL_SPREAD*STF_defocusspread
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "  number of steps:",nznum
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "  focal change per step [nm]:",zstep
!    call PostMessage(trim(MSP_stmp))
!  end if
!! ------------
!
!
!! ------------
!  rtmpresult = 0.0
!  tempsum = 0.0
!  MSP_TheResult = 0.0
!  nvarnum = max(1,nint(real(MSP_FL_varcalc)/real(nznum))) ! number of variant calculations per focus spread loop
!  vrescale = 1.0/real(nvarnum)
!  
!  do nz=1, nznum
!    
!    ! OFFSET THE BACKUP WAVE AND GENERATE ACTIVE INCOMING WAVE
!    dzcurr = zoffset + zstep*real(nz-1)
!    nerr = MS_err_num
!    call MS_OffsetIncomingWave(scanposx,scanposy,dzcurr)
!    if (nerr/=MS_err_num) then
!      call CriticalError("Failed to apply scanshift and defocus to incoming wave.")
!    end if
!    if (MSP_ctemmode==0.and.DEBUG_EXPORT>0) then
!      call PostMessage("Scanshift and defocus applied to incoming wave.")
!      write(unit=MSP_stmp,fmt=*) "- Scanshift: ",scanposx,scanposy
!      call PostMessage(trim(MSP_stmp))
!      write(unit=MSP_stmp,fmt=*) "- Defocus  : ",dzcurr
!      call PostMessage(trim(MSP_stmp))
!!      do j=1, MS_dimy
!!      j1=MS_TABBED_USC2(j)
!!      do i=1, MS_dimx
!!      i1=MS_TABBED_USC(i)
!!      rtmp(i,j)=cabs(MS_wave_in(j1,i1))**2
!!      end do
!!      end do
!!      write(unit=*,fmt=*) " > Saving input FS power."
!!      call SaveDataR4("wave_fspowin.dat",rtmp(1:MS_dimy,1:MS_dimx),MS_dimx*MS_dimy,nerr)
!    end if
!    
!    do nv = 1, nvarnum ! variants loop per focus spread cycle
!    
!      ! PERFORM FULL MULTISLICE WITH CURRENT WAVE
!      nerr = MS_err_num
!      call MSACalculate()
!      if (nerr/=MS_err_num) then
!        call CriticalError("Failed to perform multislice algorithm with current wave.")
!      end if
!      nvar = nvar + 1 ! increase number of applied variants
!    
!    
!    
!      ! COLLECT DATA FROM DETECTOR
!      if (MSP_ctemmode==0) then
!        call DetectorReadout(rtmpresult, ndet, nerr)
!        if (nerr/=0) then
!          call CriticalError("Failed readout detector.")
!        end if
!    
!        ffac = exp(fafac*dzcurr*dzcurr)*vrescale;
!	    fascal = fascal + ffac;
!	    tempsum = tempsum + rtmpresult*ffac; ! sum up data
!	    if (DEBUG_EXPORT>0) then
!          write(unit=MSP_stmp,fmt='(A,<ndet>G13.5)') "- Current detector readout:",rtmpresult
!          call PostMessage(trim(MSP_stmp))
!          write(unit=MSP_stmp,fmt='(A,G13.5)')       "- Current focal weight    :",ffac
!          call PostMessage(trim(MSP_stmp))
!          write(unit=MSP_stmp,fmt='(A,<ndet>G13.5)') "- Current total result    :",tempsum
!          call PostMessage(trim(MSP_stmp))
!        end if
!      end if
!    
!    end do ! variants loop
!
!  end do ! focus spread loop
!! ------------
!
!! ------------
!! rescale result
!  if (MSP_ctemmode==0) then
!    zrescale = 1.0/fascal
!    
!    if (MSP_usedetdef==1) then
!      MSP_detresult = tempsum*zrescale
!      if (DEBUG_EXPORT>0) then
!        write(unit=MSP_stmp,fmt='(A,<ndet>G13.5)') "Final results:",MSP_detresult
!        call PostMessage(trim(MSP_stmp))
!      end if
!    else
!      MSP_TheResult = tempsum(1)*zrescale
!      if (DEBUG_EXPORT>0) then
!        write(unit=MSP_stmp,fmt='(A,G13.5)') "Final result:",MSP_TheResult
!        call PostMessage(trim(MSP_stmp))
!      end if
!    end if
!!    do j=1, MS_dimy
!!    j1=MS_TABBED_USC2(j)
!!    do i=1, MS_dimx
!!    i1=MS_TABBED_USC(i)
!!    rtmp(i,j)=cabs(MS_wave(j1,i1))**2
!!    end do
!!    end do
!!    write(unit=*,fmt=*) " > Saving FS power."
!!    call SaveDataR4("wave_fspow.dat",rtmp(1:MS_dimy,1:MS_dimx),MS_dimx*MS_dimy,nerr)
!  end if
!! ------------
!
!
!! ------------
!! apply imaging aberrations
!  if (MSP_ctemmode==1) then
!    call PostMessage("Applying wave aberrations on imaging side.")
!    call AberrateWave()
!    
!!    call SaveDataC8("wave_abrr.dat",MS_wave(1:MS_dimy,1:MS_dimx),MS_dimx*MS_dimy,nerr)
!  end if
!! ------------
!
!! ------------
!  deallocate(rtmpresult,tempsum,stat=nalloc)
!! ------------
!
!! ------------
!!  write(unit=*,fmt=*) " > DoMultiSlice: EXIT."
!  return
!
!END SUBROUTINE DoMultiSlice
!!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE STEMMultiSlice()
! function: + variants
!           + focus spread
!           + source spread
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nz, nerr, nznum, i, j, ndet, nalloc, nslcidx
  integer*4 :: nv, nvc, nvar, nvarnum, nvartot, nvdigits
  integer*4 :: nslc, ndetect, ncalcslc
  real*4 :: scansampx, scansampy, scanposx, scanposy
  real*4 :: dxcurr, dycurr, dzcurr
  real*4 :: zstep, zoffset, zpow, zrescale, fafac, fascal, vrescale
  real*4 :: ffac
  real*4, allocatable :: rtmpresult(:)
  character(len=1000) :: swavfile, stmp
  real*4, external :: UniRand
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > STEMMultiSlice: INIT."
!  ndet = 1
!  if (MSP_usedetdef==1.and.MSP_detnum>1) then
  ndet = MSP_detnum
!  end if
  allocate(rtmpresult(ndet),stat=nalloc)
  scansampx = 0.0
  if (MSP_SF_sizex>0.0.and.MSP_SF_ndimx>1) then
    scansampx = MSP_SF_sizex/real(MSP_SF_ndimx)
  end if
  scansampy = 0.0
  if (MSP_SF_sizey>0.0.and.MSP_SF_ndimy>1) then
    scansampy = MSP_SF_sizey/real(MSP_SF_ndimy)
  end if
  scanposx =   MSP_SF_offsetx &
     &       + MSP_SF_rotcos*MSP_ScanPixelX*scansampx &
     &       - MSP_SF_rotsin*MSP_ScanPixelY*scansampy
  scanposy =   MSP_SF_offsety &
     &       + MSP_SF_rotcos*MSP_ScanPixelY*scansampy &
     &       + MSP_SF_rotsin*MSP_ScanPixelX*scansampx
!  if (MSP_ctemmode==0.and.DEBUG_EXPORT>0) then
!    write(unit=MSP_stmp,fmt=*) "Collecting data for ",ndet," detectors."
!    call PostMessage(trim(MSP_stmp))
!    write(unit=MSP_stmp,fmt=*) "Scan shift rel. to supercell origin [nm]:",scanposx,scanposy
!    call PostMessage(trim(MSP_stmp))
!  end if
! ------------

! ------------
! init explicit focal averaging
  nznum = 1
  zstep = 0.0
  zoffset = 0.0
  zrescale = 1.0
  zpow = 0.0
  fafac = 0.0
  fascal = 0.0
  if (MSP_PC_temporal/=0 .and. MSP_ExplicitPSC==0) then
    nznum = STF_DEFOCUS_KERNEL_STEPS
    zoffset = -STF_DEFOCUS_KERNEL_SPREAD*STF_defocusspread
    zstep = -2.0*zoffset / real( nznum-1 )
    fafac = -1.0/STF_defocusspread/STF_defocusspread
    write(unit=MSP_stmp,fmt=*) "Performing explicit focal averaging:"
    call PostMessage(trim(MSP_stmp))
    write(unit=MSP_stmp,fmt=*) "  focal range [nm]: +/-",STF_DEFOCUS_KERNEL_SPREAD*STF_defocusspread
    call PostMessage(trim(MSP_stmp))
    write(unit=MSP_stmp,fmt=*) "  number of steps:",nznum
    call PostMessage(trim(MSP_stmp))
    write(unit=MSP_stmp,fmt=*) "  focal change per step [nm]:",zstep
    call PostMessage(trim(MSP_stmp))
  end if
  if (MSP_ExplicitPSC/=0) then
    call PostMessage("Performing explicit averaging for:")
    if (MSP_PC_temporal/=0) then
      call PostMessage("- focus spread")
    end if
    if (MSP_PC_spatial/=0) then
      call PostMessage("- source size")
    end if
    nznum = 1 ! no fix focus loop
    zstep = 0.0
    zoffset = 0.0
    zrescale = 1.0
    zpow = 0.0
    fafac = 0.0
    fascal = 0.0
  end if
! ------------


! ------------
! init multi-slice core
  MSP_detresult = 0.0
  rtmpresult = 0.0
  MSP_TheResult = 0.0
  nvarnum = max(1,nint(real(MSP_FL_varcalc)/real(nznum))) ! number of variant calculations per focus spread loop
  write(unit=stmp,fmt='(I)') nvarnum
  nvdigits = MAX( 3, LEN_TRIM(adjustl(stmp)) )
  vrescale = 1.0/real(nvarnum)
  nvar = 0
  nvartot = nvarnum*nznum
  swavfile = trim(MS_wave_filenm) ! wave file name backup
  ! detection switch parameter
  ndetect = MS_stacksize ! preset detection switch to last slice
  if (MSP_detslc>0) ndetect = min(MSP_detslc,MS_stacksize) ! set detection switch number to user specified value
  
  ! loop through focal variants
  do nz=1, nznum
    
    ! PROBE WAVEFUNCTION SHIFTS FOR PURE FOCAL KERNEL MODE
    dzcurr = zoffset + zstep*real(nz-1)
    nerr = MS_err_num
    if (MSP_use_extinwave==1) then ! use external wavefunction
      call MS_OffsetIncomingWave(0.0,0.0,0.0) ! the inserted wave is inside the crystal, no shift and focus is needed
    else
      if (MSP_ExplicitPSC==0) then ! explicit focal kernel is used
        call MS_OffsetIncomingWave(scanposx, scanposy, dzcurr)
        if (nerr/=MS_err_num) then
          if (allocated(rtmpresult)) deallocate(rtmpresult,stat=nalloc)
          call CriticalError("Failed to shift incoming wavefunction.")
        end if
        if (DEBUG_EXPORT>0) then
          if (MSP_use_extinwave==1) then
            call PostMessage("Inserted wavefunction was applied.")
          else
            call PostMessage("Offset applied to probe wavefunction.")
            write(unit=MSP_stmp,fmt='(A,2G13.4)') "- scan shift: ", scanposx, scanposy
            call PostMessage(trim(MSP_stmp))
            if (MSP_PC_temporal/=0) then
              write(unit=MSP_stmp,fmt='(A, G13.4)') "- extra defocus  : ", dzcurr
              call PostMessage(trim(MSP_stmp))
            end if
          end if
        end if
      end if
    end if
    
    ! loop through frozen lattice variants
    do nv = 1, nvarnum ! variants loop per focus spread cycle
    
      if (MSP_use_extinwave==0 .and. MSP_ExplicitPSC==1) then
        ! PROBE WAVEFUNCTION SHIFTS FOR EXPLICIT PARTIAL COHERENCE MODE
        nerr = MS_err_num
        dzcurr = 0.0
        if (MSP_PC_temporal/=0) then
          call MSP_GetRandomProbeDefocus(STF_defocusspread, dzcurr)
        end if
        dxcurr = 0.0
        dycurr = 0.0
        if (MSP_PC_spatial/=0) then
          call MSP_GetRandomProbeShift(STF_srcradius, dxcurr, dycurr)
        end if
        call MS_OffsetIncomingWave(scanposx+dxcurr,scanposy+dycurr,dzcurr)
        if (nerr/=MS_err_num) then
          if (allocated(rtmpresult)) deallocate(rtmpresult,stat=nalloc)
          call CriticalError("Failed to shift incoming wavefunction.")
        end if
        if (DEBUG_EXPORT>0) then
          call PostMessage("Offset applied to probe wavefunction.")
          write(unit=MSP_stmp,fmt='(A,2G13.4)') "- scan shift: ",scanposx, scanposy
          call PostMessage(trim(MSP_stmp))
          if (MSP_PC_spatial/=0) then
            write(unit=MSP_stmp,fmt='(A, 2G13.4)') "- partial coherence shift  : ",dxcurr, dycurr
            call PostMessage(trim(MSP_stmp))
          end if
          if (MSP_PC_temporal/=0) then
            write(unit=MSP_stmp,fmt='(A, G13.4)') "- partial coherence defocus  : ",dzcurr
            call PostMessage(trim(MSP_stmp))
          end if
        end if
      end if
    
      ! PERFORM FULL MULTISLICE WITH CURRENT WAVE
      !
      ! <-- SINGLE MULTISLICE STARTS HERE
      !
      nerr = MS_err_num
      write(unit=MSP_stmp,fmt='(A,I6,A,I6)') "- repeat: ",nv + (nz-1)*nvarnum, " / ", nznum*nvarnum
      call PostMessage(trim(MSP_stmp))
      
      ! update wave file name (insert variation number) when more than one variant per multislice
      if (MS_wave_export>=1 .and. nvartot>1) then
        i = index(trim(swavfile),".",BACK=.TRUE.)
        if (i>0) then
          j = len_trim(swavfile)
          write(unit=MSP_stmp, fmt='(A,I<nvdigits>.<nvdigits>,A)') swavfile(1:i-1)//"_vr", nvar+1, swavfile(i:j)
        else 
          write(unit=MSP_stmp, fmt='(A,I<nvdigits>.<nvdigits>)') swavfile(1:i-1)//"_vr", nvar+1
        end if
        MS_wave_filenm = trim(MSP_stmp)
      end if
      
      if (MSP_use_extinwave==1) then
        call MS_Start(MSP_extinwslc)
      else
        call MS_Start()
      end if
      if (nerr/=MS_err_num) goto 16

      ! loop over all slices and do the multislice
      ncalcslc = MS_slicecur ! reset number of calculated slices
           
      ! determine current scaling factor for summation over foci and over variants
      ffac = exp(fafac*dzcurr*dzcurr)*vrescale
      ! write(*,*) ffac, exp(fafac*dzcurr*dzcurr), vrescale
	  ! .. and sum up the applied weights for later rescaling to 1.0
	  fascal = fascal + ffac;
      
      do while (MS_slicecur >= 0.and. MS_slicecur<MS_stacksize)
        nerr = MS_err_num ! backup error
        nslc = MS_slicestack(MS_slicecur+1)+1 ! get current slice index
        nvc = 1 + int( UniRand()*real(MSP_SLC_setup(0,nslc))*0.9999 ) ! get current variant index
        
        ! slice
        nslcidx = MSP_GetPGRIndex(nvc,nslc,nerr)
        if (nerr/=0) return
        call MS_CalculateNextSlice(MSP_phasegrt(1:MSP_dimcellx,1:MSP_dimcelly,nslcidx),MSP_dimcellx,MSP_dimcelly)
        ncalcslc = ncalcslc + 1 ! increase number of calculated slices
        
        if (nerr/=MS_err_num) goto 16 ! error check
        
        if (0==modulo(ncalcslc,ndetect)) then ! detection?
          ! COLLECT DATA FROM DETECTOR
          call DetectorReadout(rtmpresult, ndet, nerr)
          if (nerr/=0) then
            if (allocated(rtmpresult)) deallocate(rtmpresult,stat=nalloc)
            call CriticalError("Failed to readout detector.")
          else
            ! sum up weighted data depending on slice number and detector number
	        MSP_detresult(1:ndet,ncalcslc) = MSP_detresult(1:ndet,ncalcslc) + rtmpresult*ffac
            !
	        if (DEBUG_EXPORT>0) then
	          write(unit=MSP_stmp,fmt='(A,I4,A)') "- Detection after ",ncalcslc," slices."
              call PostMessage(trim(MSP_stmp))
              write(unit=MSP_stmp,fmt='(A,<ndet>G13.5)') "- Current detector readout:",rtmpresult
              call PostMessage(trim(MSP_stmp))
              write(unit=MSP_stmp,fmt='(A,<ndet>G13.5)') "- Current total result    :",MSP_detresult(1:ndet,ncalcslc)
              call PostMessage(trim(MSP_stmp))
            end if
          end if
          !
        end if ! detector readout
        
      end do ! while (MS_slicecur >= 0)

      ! Stop the multislice
      nerr = MS_err_num
      call MS_Stop()
      if (nerr/=MS_err_num) goto 16
      !
      ! <-- SINGLE MULTISLICE ENDS HERE
      !
      
      nvar = nvar + 1 ! increase number of applied variants
    
    end do ! variants loop

  end do ! focus spread loop
! ------------

! ------------
! rescale result
  zrescale = 1.0/fascal
  MSP_detresult = MSP_detresult*zrescale
! ------------


! ------------
  if (MSP_txtout==0) call ExportSTEMData(trim(MSP_outfile))
  call MSP_WriteTextOutput(nerr)
! ------------


! ------------
  if (allocated(rtmpresult)) deallocate(rtmpresult,stat=nalloc)
! ------------

! ------------
!  write(unit=*,fmt=*) " > STEMMultiSlice: EXIT."
  return
  
16 call CriticalError("Failed to perform multislice algorithm with current wave.")
  return

END SUBROUTINE STEMMultiSlice
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE CTEMMultiSlice()
! function: + variants
!           - focus spread
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr, i, j, nv, nvarnum, nvd
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > CTEMMultiSlice: INIT."
  nerr = 0
  MSP_PC_temporal = 0
! ------------


! ------------
  nvarnum = MSP_FL_varcalc ! number of variant calculations
  
  nvd = MSP_nvard
    
  ! OFFSET THE BACKUP WAVE AND GENERATE ACTIVE INCOMING WAVE
  call MS_OffsetIncomingWave(0.0,0.0,0.0)
    
    
  do nv = 1, nvarnum ! variants loop per focus spread cycle
  
    ! update wave file name (insert variation number) when more than one variant per multislice
    if (MS_wave_export>=1 .and. nvarnum>1) then
      MS_wave_filenm = MS_wave_filenm_bk
      i = index(trim(MS_wave_filenm),".",BACK=.TRUE.)
      if (i>0) then
        j = len_trim(MS_wave_filenm)
        write(unit=MSP_stmp, fmt='(A,I<nvd>.<nvd>,A)') MS_wave_filenm(1:i-1)//"_vr", nv, MS_wave_filenm(i:j)
      else 
        write(unit=MSP_stmp, fmt='(A,I<nvd>.<nvd>)') MS_wave_filenm(1:i-1)//"_vr", nv
      end if
      MS_wave_filenm = trim(MSP_stmp)
    end if
    
    ! PERFORM FULL MULTISLICE WITH CURRENT WAVE
    nerr = MS_err_num
    call MSACalculate()
    if (nerr/=MS_err_num) then
      call CriticalError("Failed to perform multislice algorithm with current wave.")
    end if

! >> Image aberrations sould be applied by the tool WAVIMG. <<
!    call PostMessage("Applying wave aberrations on imaging side.")
!    call AberrateWave()
!    call PostMessage("Applying objective aperture.")
!    call ApplyObjAp()
    
    ! the wave function export is always done in MS_CalculateNextSlice
    !call ExportWave(nv,trim(MSP_outfile))
    
  end do ! variants loop
  MS_wave_filenm = MS_wave_filenm_bk ! reset wave file name
! ------------


! ------------
!  write(unit=*,fmt=*) " > CTEMMultiSlice: EXIT."
  return

END SUBROUTINE CTEMMultiSlice
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE CreateSTEMFile(sfile,ndata,nerr)
! functions: Creates a file for stem data output with sufficient size
!            to write all data into it later.
! -------------------------------------------------------------------- !
! parameter:
!   character(len=*) :: sfile = file name
!   integer*4 :: ndata = number of data (assuming 4 bytes per data)
!   integer*4 :: nerr = error code in case the routine fails
! -------------------------------------------------------------------- !

  use MSAparams

  implicit none
  
  character(len=*), intent(in) :: sfile ! input file name
  integer*4, intent(in) :: ndata ! total number of 4-byte data items in the file
  integer*4, intent(inout) :: nerr ! error code
  integer*4 :: lfu, status
  real*4, allocatable :: tmpdat(:)
  
  ! init
  nerr = 0

  call PostMessage("- Creating new output file ["//trim(sfile)//"].")
  ! get new logical fle unit
  call GetFreeLFU(lfu,40,1000)
  ! open the file and replace the old file / create new file
  call createfilefolder(trim(sfile),status)
  ! record length is equal to total data size of (4 byte)*datanum
  open (unit=lfu, file=trim(sfile), form="binary",iostat=status,&
     &  access="direct", recl=4*ndata, status="replace", &
     &  action="write", share='DENYRW')
  if (status/=0) then
    call CriticalError("Output file creation failed.")
    nerr = 1
    return
  end if
  
  ! write zeroes to create the file of complete size with zero values preset
  allocate(tmpdat(ndata),stat=status)
  if (status/=0) then
    write(unit=MSP_stmp,fmt='(A,I8,A)') &
     &    "Failed to allocate memory (",int(ndata*4/1024),"kB)."
    call CriticalError(trim(MSP_stmp))
    nerr = 2
    return
  end if
  tmpdat = 0.0
  write(unit=lfu,rec=1,iostat=status) tmpdat
  deallocate(tmpdat,stat=status)
  close (unit=lfu)
  return
   
END SUBROUTINE CreateSTEMFile
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE ExportSTEMData(sfile)
! function: writes calculated signal of one scan pixel to raw binary
!           output file(s).
! -------------------------------------------------------------------- !
! parameter: file name
! -------------------------------------------------------------------- !

  use MSAparams
  use MultiSlice

  implicit none

! ------------
! DECLARATION
  character*(*), intent(in) :: sfile
  integer*4 :: lfu, nerr, i, k, l, m, datapos, ndet
  integer*4 :: ndetect
  integer*4 :: ndatanum, ndataplane
  logical :: fex
  character(len=1024) :: stmp, spfile, sdfile
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ExportSTEMData: INIT."
  write(unit=stmp,fmt='(A,I4,A,I4)') &
     &  "Exporting detector signals for scan pixel ", &
     &  MSP_ScanPixelX,", ",MSP_ScanPixelY
  call PostMessage(trim(stmp))
  ! check data position in the image
  datapos = 1 + MSP_ScanPixelX + MSP_ScanPixelY*MSP_SF_ndimx
  ! determine number of scan points
  ndatanum = MSP_SF_ndimx*MSP_SF_ndimy
  ! preset plane offset for 3d data stacks
  ndataplane = 0
  !
  if (datapos<=0.or.datapos>ndatanum) then
    call CriticalError("ExportSTEMData: Invalid datafile position.")
  end if
! ------------


! ------------
  ! get number of detectors
  ndet = max(1,MSP_detnum)
  
  ! determine detetcion slice index
  ndetect = MS_stacksize ! preset detection switch to last slice
  if (MSP_detslc>0) ndetect = min(MSP_detslc,MS_stacksize)
  
   
! ------------
  ! loop over detectors
  do k=1, ndet
  
    sdfile = trim(sfile) ! default preset
    
! --------------
    if (MSP_usedetdef/=0) then ! update output file name with detector name
      m = LEN_TRIM(sfile) ! get length of the standard output file
      l = INDEX(sfile,".",back=.TRUE.) ! search for extension point in given output file
      if (l<1) then ! no extension wanted
        write(unit=sdfile,fmt='(A)') trim(sfile)//"_"//trim(MSP_detname(k))
      else ! last extension starts at position l, insert the index string before
        write(unit=sdfile,fmt='(A)') sfile(1:l-1)//"_"//trim(MSP_detname(k))//sdfile(l:m)
      end if
    else ! keep current output file name
      sdfile = trim(sfile)
    end if
! --------------
    
! ------------
    if (MSP_3dout == 1) then ! prepare for output to 3d data file
      !
      ! BEGIN OF 3D FILE OUTPUT
      !
      ! check existence of current output file
      inquire(file=trim(sdfile),exist=fex)
      if (.not.fex) then ! doesn't exist, create new
        call CreateSTEMFile(trim(sdfile),ndatanum*MSP_detpln,nerr)
        if (nerr/=0) call CriticalError("Output file creation failed.")
      end if
      ! open the file for writing all data to it
      ! - get logical unit
      call GetFreeLFU(lfu,20,100)
      ! - open file shared access
      open(unit=lfu, file=trim(sdfile), form="binary", access="direct", &
     &     iostat=nerr, status="old", action="write", recl=4, share='DENYNONE' )
        if (nerr/=0) then
          call CriticalError("ExportSTEMData: Failed to open file ["//trim(sdfile)//"].")
      end if
      ! - write to the file ... 
      ! preset plane offset for 3d data stacks
      ndataplane = 0
      do i=1, MS_stacksize ! loop over all slices
        if (0/=modulo(i,ndetect)) cycle ! skip this slice 
        !
        ! - write the data at correct position
        write(unit=lfu,rec=(datapos+ndataplane*ndatanum),iostat=nerr) MSP_detresult(k,i)
        if (nerr/=0) then
          call CriticalError("ExportSTEMData: Failed to write data.")
        end if
        !
        ! increase the plane offset index by one for the next cycle
        ndataplane = ndataplane + 1
        ! - report per export plane
        write(unit=MSP_stmp,fmt='(A,G13.5,A)') "- Saved "// &
     &      trim(MSP_detname(k))//" signal: ", MSP_detresult(k,i), &
     &      " to file ["//trim(sdfile)//"]."
        call PostMessage(trim(MSP_stmp))
        !
      end do ! i-loop over slices
      !
      ! - close the file
      close(unit=lfu)
      !
      ! END OF 3D FILE OUTPUT
      !
    else ! perpare for output to 2D files (one per export plane)
      !
      ! BEGIN OF SINGLE PLANE FILE OUTPUT
      !
      ! loop over all slices
      do i=1, MS_stacksize
        if (0/=modulo(i,ndetect)) cycle ! skip this slice
        spfile = trim(sdfile) ! default preset
        ! - modify file name with slice index
        if (MSP_detslc>0) then ! append slice index to file name
          ! - update output file name
          m = LEN_TRIM(sdfile) ! get length of the standard output file
          l = INDEX(sdfile,".",back=.TRUE.) ! search for extension point in given output file
          if (l<1) then ! no extension wanted
            write(unit=spfile,fmt='(A,I<MSP_nslid>.<MSP_nslid>)') trim(sdfile)//"_sl",i
          else ! last extension starts at position l, insert the index string before
            write(unit=spfile,fmt='(A,I<MSP_nslid>.<MSP_nslid>,A)') sdfile(1:l-1)//"_sl",i,spfile(l:m)
          end if
          ! - check existence of current output file
          inquire(file=trim(spfile),exist=fex)
          if (.not.fex) then ! doesn't exist, create new (single plane file)
            call CreateSTEMFile(trim(spfile),ndatanum,nerr)
            if (nerr/=0) call CriticalError("Output file creation failed.")
          end if
        end if
        ! write data record to current output file
        ! - get logical unit
        call GetFreeLFU(lfu,20,100)
        ! - open file shared access
        open(unit=lfu, file=trim(spfile), form="binary", access="direct", &
     &     iostat=nerr, status="old", action="write", recl=4, share='DENYNONE' )
        if (nerr/=0) then
          call CriticalError("ExportSTEMData: Failed to open file ["//trim(spfile)//"].")
        end if
        !
        ! - write the data at correct position
        write(unit=lfu,rec=datapos,iostat=nerr) MSP_detresult(k,i)
        if (nerr/=0) then
          call CriticalError("ExportSTEMData: Failed to write data.")
        end if
        !
        ! - close logical file unit
        close(unit=lfu)
        ! - report
        write(unit=MSP_stmp,fmt='(A,G13.5,A)') "- Saved "// &
     &      trim(MSP_detname(k))//" signal: ", MSP_detresult(k,i), &
     &      " to file ["//trim(spfile)//"]."
        call PostMessage(trim(MSP_stmp))

      end do ! i-loop over slices
      !
      ! END OF SINGLE PLANE FILE OUTPUT
      !
    end if ! SWITCH 3d output or single plane files

  end do ! k-loop over detectors
! ------------

! ------------
  call PostMessage("Finished detector signal export.")
!  write(unit=*,fmt=*) " > ExportSTEMData: EXIT."
  return

END SUBROUTINE ExportSTEMData
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE InitProbeIntegration()
! function: Initializes all variables needed to handle probe intensity
!           integration and output
!           - determines the number of exit planes
!           - allocates the array holding the integrated intensities
!           - resets all variable handling the access to the arrays
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function after all multislice parameters are set up.
! Call this function if MS_pint_export > 0.
! Call this function before starting a new multislice calculation
!   for STEM mode for each scan pixel.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr, i, n1, n2
  integer*4 :: ndetect
  integer*4 :: nepw
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > InitWaveAvg: INIT."
  call PostMessage("Initializing probe intensity integration.")
  ! determine periodic detection slice index
  ndetect = MS_stacksize ! preset detection switch to last slice
  if (MSP_detslc>0) ndetect = min(MSP_detslc,MS_stacksize) ! periodic readout
  nepw = 0
  n1 = MS_dimx
  n2 = MS_dimy
! ------------

! ------------
! Determine the number of exit planes.
  do i=1, MS_stacksize
    if (0/=modulo(i,ndetect)) cycle ! skip this slice
    nepw = nepw + 1 ! increase number of exit planes
  end do
! ------------

! ------------
! Allocate the array holding the integrated probe intensities
  if (MSP_pimgmode/=0) then ! array is already allocated
    if (allocated(MSP_pimg)) deallocate(MSP_pimg,stat=nerr) ! deallocate
    allocate(MSP_pimg(1:n1, 1:n2, 0:nepw),stat=nerr) ! allocate
    if (nerr/=0) then
      call CriticalError("InitProbeIntegration: Failed to allocate memory.")
    end if
    MSP_pimg = 0.0
  end if
  if (MSP_pdifmode/=0) then ! array is already allocated
    if (allocated(MSP_pdif)) deallocate(MSP_pdif,stat=nerr) ! deallocate
    allocate(MSP_pdif(1:n2, 1:n1, 0:nepw),stat=nerr) ! allocate
    if (nerr/=0) then
      call CriticalError("InitProbeIntegration: Failed to allocate memory.")
    end if
    MSP_pdif = 0.0
  end if
  if (MSP_pimgmode/=0 .or. MSP_pdifmode/=0) then ! array is already allocated
    if (allocated(MSP_pint_nac)) deallocate(MSP_pint_nac,stat=nerr) ! deallocate
    MSP_pint_num = 0
    allocate(MSP_pint_nac(0:nepw),stat=nerr)
    if (nerr/=0) then
      call CriticalError("InitProbeIntegration: Failed to allocate memory.")
    end if
    MSP_pint_nac = 0
    MSP_pint_num = nepw ! store the number of exit-planes
  end if
  MS_pint_idx = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > InitProbeIntegration: EXIT."
  return

END SUBROUTINE InitProbeIntegration
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE ResetProbeIntegration()
! function: Resets all variables needed to handle probe intensity
!           integration and output
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function after all multislice parameters are set up.
! Call this function if MS_pint_export > 0.
! Call this function before starting a new multislice calculation
!   for STEM mode for each scan pixel.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ResetProbeIntegration: INIT."
! ------------

! ------------
! Reset the arrays holding the integrated probe intensities
  if (MSP_pimgmode/=0 .and. allocated(MSP_pimg)) then ! array is already allocated
    MSP_pimg = 0.0
  end if
  if (MSP_pdifmode/=0 .and. allocated(MSP_pdif)) then ! array is already allocated
    MSP_pdif = 0.0
  end if
  if ((MSP_pimgmode/=0 .or. MSP_pdifmode/=0) .and. allocated(MSP_pint_nac)) then ! array is already allocated
    MSP_pint_nac = 0
  end if
  MS_pint_idx = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > ResetProbeIntegration: EXIT."
  return

END SUBROUTINE ResetProbeIntegration
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE UnInitProbeIntegration()
! function: Uninitializes all variables needed to handle probe
!           intensity integrations
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function at the end of the program or a multislice run.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > UnInitProbeIntegration: INIT."
  call PostMessage("Uninitializing probe intensity integration.")
! ------------

! ------------
! Deallocate the array holding the average wavefunctions
  if (allocated(MSP_pimg)) deallocate(MSP_pimg, stat=nerr)
  if (allocated(MSP_pdif)) deallocate(MSP_pdif, stat=nerr)
  if (allocated(MSP_pint_nac)) deallocate(MSP_pint_nac, stat=nerr)
! reset the access and accumulation indices
  MSP_pint_num = 0
  MS_pint_idx = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > UnInitProbeIntegration: EXIT."
  return

END SUBROUTINE UnInitProbeIntegration
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE ExportProbeIntensity(sfile)
! function: Exports the accumulated probe intensity to files.
!           - loops through all exit planes used for recording
!           - normalizes the accumulated intensities
!           - stores the normalized intensities to disk
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function if MS_pint_export>0.
! Call this function after a multislice calculation
!   for STEM mode only, for each scan pixel.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  character(len=MSP_ll) :: isfile, sexpfile
  integer*4 :: nintout, nwavavg, ntransform
  integer*4 :: nerr, nalloc, i, j, k
  integer*4 :: islc
  integer*4 :: ndetect
  real*4 :: rnorm, pint
  real*4, dimension(:,:), allocatable :: pimg, pela, ptds
  complex*8, dimension(:,:), allocatable :: wave, work
  external :: SaveDataC8, SaveDataR4 ! (sfile,dat,n,nerr) this file
  !external :: AppendDataC8, AppendDataR4 ! (sfile,dat,n,nerr) this file
  external :: sinsertslcidx ! (idx,idxlen,sfnin,sfnadd,sfnext,sfnout) this file
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ExportProbeIntensity: INIT."
  nwavavg = 0 ! init without average wave function data: 0 -> none, 1 -> Fourier space, 2 -> real space
  nintout = 0 ! intensity output request strength: 0 -> none, 1 -> Fourier space, 2 -> real space, 3 -> both
  ntransform = 0 ! init without the need to transform data: 0 -> no, 1 -> yes
  if (MS_pint_export<=0) return ! no valid setup
  if (MSP_pdifmode>0) nintout = 1
  if (MSP_pimgmode>0) nintout = nintout + 2
  !
  ! Determine periodic detection slice index.
  ndetect = MS_stacksize ! preset detection switch to last slice
  if (MSP_detslc>0) ndetect = min(MSP_detslc,MS_stacksize) ! periodic readout
  !
  ! Handle the case of present average wave function data.
  ! In this case, we want to export the elastic images as well as 
  ! also the difference (TDS) images to the total intensity.
  ! We then need extra data arrays
  if (MS_wave_avg_export==1 .and. allocated(MS_wave_avg)) then ! there is average wave data
    nwavavg = 2 - MS_wave_export_form ! 1 -> Fourier space, 2 -> real space wave function
    if ( nwavavg /= nintout ) then
      ! this means, average wave and at least one intended output are not in the same space
      ! and a fourier transform has to be done.
      ntransform = 1
    end if
  end if
  !
  if (LEN_TRIM(sfile)==0) then ! set a default output file name in case of invalid input
    isfile = "probe.dat"
  else ! use the input file name
    isfile = trim(sfile)
  end if
! ------------

! ------------
! OUTPUT OF PROBE INTENSITIES IN REAL SPACE
  if (MSP_pimgmode==1) then
    ! allocations
    allocate(pimg(MS_dimx,MS_dimy), stat=nalloc)
    if (nwavavg>0) then
      allocate(wave(MS_dimx,MS_dimy), stat=nalloc)
      allocate(pela(MS_dimx,MS_dimy), stat=nalloc)
      allocate(ptds(MS_dimx,MS_dimy), stat=nalloc)
      if (nwavavg==1) then ! wave data is in Fourier space, need to transform
        allocate(work(FFT_BOUND,FFT_BOUND), stat=nalloc)
      end if
    end if
    do k=0, MSP_pint_num ! Loop over all exit-planes.
      islc = k*ndetect ! = periodic readout slice number / exit-plane
      if (MSP_pint_nac(k)==0) cycle ! ignore planes which didn't recieve data
      ! normalize (we assume that wave and images have the same number of contributions)
      rnorm = 1.0/real(MSP_pint_nac(k))
      !
      ! get total intensity
      pimg(1:MS_dimx,1:MS_dimy) = MSP_pimg(1:MS_dimx,1:MS_dimy,k) * rnorm
      ! prepare file name for total intensity image
      call sinsertslcidx(islc,MS_nslid,trim(isfile),"_pimg_tot",".dat",sexpfile)
      call PostMessage("  Writing total probe image intensity to file ["//trim(sexpfile)//"].")
      call SaveDataR4(trim(sexpfile), pimg, MS_dimx*MS_dimy, nerr) ! save
      ! 
      if (nwavavg>0) then
        ! get elastic and tds images
        if (nwavavg==1) then ! wave data is in Fourier space, need to transform
          work = cmplx(0.0,0.0)
          do j=1, MS_dimx
            work(1:MS_dimy,j) = MS_wave_avg(1:MS_dimy,j,k) * rnorm
          end do
          call MS_FFT(work,MS_dimx,MS_dimy,'backwards')
          do j=1, MS_dimy
            wave(1:MS_dimx,j) = work(1:MS_dimx,j)
          end do
        else ! wave data is in real space, just copy
          do j=1, MS_dimy
            wave(1:MS_dimx,j) = MS_wave_avg(1:MS_dimx,j,k) * rnorm
          end do
        end if
        ! calculate elastic image
        do j=1, MS_dimy
          do i=1, MS_dimx
            pint = real( wave(i,j)*conjg(wave(i,j)) )
            pela(i,j) = pint
          end do
        end do
        ! prepare file name for elastic intensity image
        call sinsertslcidx(islc,MS_nslid,trim(isfile),"_pimg_ela",".dat",sexpfile)
        call PostMessage("  Writing elastic probe image intensity to file ["//trim(sexpfile)//"].")
        call SaveDataR4(trim(sexpfile), pela, MS_dimx*MS_dimy, nerr) ! save
        ptds = pimg - pela
        ! prepare file name for tds intensity image
        call sinsertslcidx(islc,MS_nslid,trim(isfile),"_pimg_tds",".dat",sexpfile)
        call PostMessage("  Writing TDS probe image intensity to file ["//trim(sexpfile)//"].")
        call SaveDataR4(trim(sexpfile), ptds, MS_dimx*MS_dimy, nerr) ! save
      end if
      !
    end do ! k=0, MS_pint_num
    !
    ! deallocate
    if (allocated(pimg)) deallocate(pimg, stat=nalloc)
    if (allocated(wave)) deallocate(wave, stat=nalloc)
    if (allocated(work)) deallocate(work, stat=nalloc)
    if (allocated(pela)) deallocate(pela, stat=nalloc)
    if (allocated(ptds)) deallocate(ptds, stat=nalloc)
    !
  end if ! (MSP_pimgmode==1)
! ------------


! ------------
! OUTPUT OF PROBE INTENSITIES IN FOURIER SPACE
  if (MSP_pdifmode==1) then
    ! allocations
    allocate(pimg(MS_dimy,MS_dimx), stat=nalloc)
    if (nwavavg>0) then
      allocate(wave(MS_dimy,MS_dimx), stat=nalloc)
      allocate(pela(MS_dimy,MS_dimx), stat=nalloc)
      allocate(ptds(MS_dimy,MS_dimx), stat=nalloc)
      if (nwavavg==2) then ! wave data is in real space, need to transform
        allocate(work(FFT_BOUND,FFT_BOUND), stat=nalloc)
      end if
    end if
    do k=0, MSP_pint_num ! Loop over all exit-planes.
      islc = k*ndetect ! = periodic readout slice number / exit-plane
      if (MSP_pint_nac(k)==0) cycle ! ignore planes which didn't recieve data
      ! normalize (we assume that wave and images have the same number of contributions)
      rnorm = 1.0/real(MSP_pint_nac(k))
      !
      ! get total intensity
      pimg(1:MS_dimy,1:MS_dimx) = MSP_pdif(1:MS_dimy,1:MS_dimx,k) * rnorm
      ! prepare file name for total intensity image
      call sinsertslcidx(islc,MS_nslid,trim(isfile),"_pdif_tot",".dat",sexpfile)
      call PostMessage("  Writing total probe diffraction intensity to file ["//trim(sexpfile)//"].")
      call SaveDataR4(trim(sexpfile), pimg, MS_dimx*MS_dimy, nerr) ! save
      ! 
      if (nwavavg>0) then
        ! get elastic and tds images
        if (nwavavg==2) then ! wave data is in real space, need to transform
          work = cmplx(0.0,0.0)
          do j=1, MS_dimy
            work(1:MS_dimx,j) = MS_wave_avg(1:MS_dimx,j,k) * rnorm
          end do
          call MS_FFT(work,MS_dimx,MS_dimy,'forwards')
          do j=1, MS_dimx
            wave(1:MS_dimy,j) = work(1:MS_dimy,j)
          end do
        else ! wave data is in Fourier space, just copy
          do j=1, MS_dimx
            wave(1:MS_dimy,j) = MS_wave_avg(1:MS_dimy,j,k) * rnorm
          end do
        end if
        ! calculate elastic image
        do j=1, MS_dimx
          do i=1, MS_dimy
            pint = real( wave(i,j)*conjg(wave(i,j)) )
            pela(i,j) = pint
          end do
        end do
        ! prepare file name for elastic intensity image
        call sinsertslcidx(islc,MS_nslid,trim(isfile),"_pdif_ela",".dat",sexpfile)
        call PostMessage("  Writing elastic probe diffraction intensity to file ["//trim(sexpfile)//"].")
        call SaveDataR4(trim(sexpfile), pela, MS_dimx*MS_dimy, nerr) ! save
        ptds = pimg - pela
        ! prepare file name for tds intensity image
        call sinsertslcidx(islc,MS_nslid,trim(isfile),"_pdif_tds",".dat",sexpfile)
        call PostMessage("  Writing TDS probe diffraction intensity to file ["//trim(sexpfile)//"].")
        call SaveDataR4(trim(sexpfile), ptds, MS_dimx*MS_dimy, nerr) ! save
      end if
      !
    end do ! k=0, MS_pint_num
    !
    ! deallocate
    if (allocated(pimg)) deallocate(pimg, stat=nalloc)
    if (allocated(wave)) deallocate(wave, stat=nalloc)
    if (allocated(work)) deallocate(work, stat=nalloc)
    if (allocated(pela)) deallocate(pela, stat=nalloc)
    if (allocated(ptds)) deallocate(ptds, stat=nalloc)
    !
  end if ! (MSP_pdifmode==1)
! ------------

! ------------
  if (allocated(wave)) deallocate(wave, stat=nerr)
!  write(unit=*,fmt=*) " > ExportProbeIntensity: EXIT."
  return

END SUBROUTINE ExportProbeIntensity
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE InitWaveAvg()
! function: Initializes all variables needed to handle avg. wavefunct.
!           - determines the number of exit planes
!           - allocates the array holding the avg. wavefunctions
!           - resets the avg. wavefunctions
!           - resets all variable handling the access to the avg. wf
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function after all multislice parameters are set up.
! Call this function if MS_wave_avg_export>0.
! Call this function before starting a new multislice calculation
!   for CTEM mode and for STEM mode.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr, i, n1, n2
  integer*4 :: ndetect
  integer*4 :: nepw
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > InitWaveAvg: INIT."
  call PostMessage("Initializing wavefunction averaging.")
  ! determine periodic detection slice index
  ndetect = MS_stacksize ! preset detection switch to last slice
  if (MSP_detslc>0) ndetect = min(MSP_detslc,MS_stacksize) ! periodic readout
  nepw = 0
  n1 = MS_dimx
  n2 = MS_dimy
  if (MS_wave_export_form==1) then ! Fourier space export
    n1 = MS_dimy
    n2 = MS_dimx
  end if
! ------------

! ------------
! Determine the number of exit planes.
  do i=1, MS_stacksize
    if (0/=modulo(i,ndetect)) cycle ! skip this slice
    nepw = nepw + 1 ! increase number of exit planes
  end do
! ------------

! ------------
! Allocate the array holding the average wavefunctions
  if (allocated(MS_wave_avg)) then ! array is already allocated
    if (nepw+1/=SIZE(MS_wave_avg, DIM=3)) then ! check size on dimension 3
      deallocate(MS_wave_avg,stat=nerr) ! deallocate on wrong size
      deallocate(MS_wave_avg_nac,stat=nerr) ! 
      MS_wave_avg_num = 0
    end if
  end if
  if (.not.allocated(MS_wave_avg)) then ! array not allocated
  ! alloation with an extra array for the incoming wavefunction, index 0 at dimension 3
    allocate(MS_wave_avg(1:n1, 1:n2, 0:nepw),stat=nerr)
    allocate(MS_wave_avg_nac(0:nepw),stat=nerr)
    if (nerr/=0) then
      call CriticalError("InitWaveAvg: Failed to allocate memory.")
    end if
    MS_wave_avg_num = nepw ! store the number of exit-planes
  end if
! reset the wavefunctions
  MS_wave_avg = cmplx(0.,0.)
  MS_wave_avg_nac = 0
! ------------

! ------------
! reset the average wf access and accumulation indices
  MS_wave_avg_idx = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > InitWaveAvg: EXIT."
  return

END SUBROUTINE InitWaveAvg
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE ResetWaveAvg()
! function: Resets all variables needed to handle avg. wavefunct.
!           - resets the avg. wavefunctions
!           - resets all variable handling the access to the avg. wf
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function if MS_wave_avg_export>0.
! Call this function before starting a new multislice calculation
!   in STEM mode for each pixel.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ResetWaveAvg: INIT."
! ------------

! ------------
  if ((.not.allocated(MS_wave_avg)).or.MS_wave_avg_num<1) then ! array not allocated
    ! do nothing
    return
  end if
! reset the wavefunction data
  MS_wave_avg = cmplx(0.,0.)
  MS_wave_avg_nac = 0
  MS_wave_avg_idx = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > ResetWaveAvg: EXIT."
  return

END SUBROUTINE ResetWaveAvg
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE UnInitWaveAvg()
! function: Uninitializes all variables needed to handle avg. wavefunct.
!           - deallocates the array holding the avg. wavefunctions
!           - resets all variable handling the access to the avg. wf
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function at the end of the program or a multislice run.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  integer*4 :: nerr
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > UnInitWaveAvg: INIT."
  call PostMessage("Uninitializing wavefunction averaging.")
! ------------

! ------------
! Deallocate the array holding the average wavefunctions
  if (allocated(MS_wave_avg)) then ! array is already allocated
    deallocate(MS_wave_avg, stat=nerr) ! 
    deallocate(MS_wave_avg_nac, stat=nerr) ! 
  end if
! reset the average wf access and accumulation indices
  MS_wave_avg_num = 0
  MS_wave_avg_idx = 0
! ------------

! ------------
!  write(unit=*,fmt=*) " > UnInitWaveAvg: EXIT."
  return

END SUBROUTINE UnInitWaveAvg
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
SUBROUTINE ExportWaveAvg(sfile)
! function: Exports the accumulated avg. wavefunctions to files.
!           - loops through all exit planes used for recording
!           - normalizes the accumulated wavefunctions
!           - stores the normalized wavefunctions to disk
! -------------------------------------------------------------------- !
! parameters: none
! -------------------------------------------------------------------- !
! remarks:
! Call this function if MS_wave_avg_export>0.
! Call this function after a multislice calculation
!   for CTEM mode (once) and for STEM mode for each scan pixel.
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  character(len=MSP_ll) :: isfile, sexpfile
  integer*4 :: nerr, k, n1, n2
  integer*4 :: islc
  integer*4 :: ndetect
  real*4 :: rnorm
  complex*8, dimension(:,:), allocatable :: wave
  external :: SaveDataC8
  !external :: AppendDataC8
  external :: sinsertslcidx ! (idx,idxlen,sfnin,sfnadd,sfnext,sfnout)
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ExportWaveAvg: INIT."
  n1 = MS_dimx
  n2 = MS_dimy
  if (MS_wave_avg_export<=0 .or. MS_wave_avg_export>1) return ! no valid setup
  if (.not.allocated(MS_wave_avg)) return ! no data
  !
  if (MS_wave_export_form==0) then
    call PostMessage("Average wavefunction export (real space).")
  else
    call PostMessage("Average wavefunction export (Fourier space).")
    n1 = MS_dimy
    n2 = MS_dimx
  end if
  ! determine periodic detection slice index
  ndetect = MS_stacksize ! preset detection switch to last slice
  if (MSP_detslc>0) ndetect = min(MSP_detslc,MS_stacksize) ! periodic readout
  allocate(wave(1:n1,1:n2), stat=nerr)
  if (nerr/=0) then
    call CriticalError("ExportWaveAvg: Failed to allocate memory.")
    return
  end if
  if (LEN_TRIM(sfile)==0) then ! set a default output file name in case of invalid input
    isfile = "epw_avg.wav"
  else ! use the input file name
    isfile = trim(sfile)
  end if
! ------------

! ------------
! OUTPUT OF AVERAGE WAVE FUNCTION
  do k=0, MS_wave_avg_num ! Loop over all exit-planes.
    islc = k*ndetect ! = periodic readout slice number / exit-plane
    if (MS_wave_avg_nac(k)==0) cycle ! ignore planes which didn't recieve data
    ! normalize
    rnorm = 1.0/real(MS_wave_avg_nac(k))
    wave(1:n1, 1:n2) = MS_wave_avg(1:n1, 1:n2, k) * rnorm
    ! export to file
    call sinsertslcidx(islc,MS_nslid,trim(isfile),"_avg",".wav",sexpfile)
    call PostMessage("  Writing to file ["//trim(sexpfile)//"].")
    call SaveDataC8(trim(sexpfile), wave, n1*n2, nerr)
    ! ...
  end do ! k=0, MS_wave_avg_num
! ------------

! ------------
  if (allocated(wave)) deallocate(wave, stat=nerr)
!  write(unit=*,fmt=*) " > ExportWaveAvg: EXIT."
  return

END SUBROUTINE ExportWaveAvg
!**********************************************************************!



!**********************************************************************!
!**********************************************************************!
SUBROUTINE ExportWave(sfile)
! function: saves the wave function to file
!           - expects the wave function in MS_wave in Fourier form
!           - does inverse FT
!           - writes the binary data to a file with given file name
!           - accumulates probe images, diffraction patterns and
!             average wave functions
! -------------------------------------------------------------------- !
! parameter: character(len=*) :: sfile    ! the file name
! -------------------------------------------------------------------- !

  use MultiSlice
  use MSAparams

  implicit none

! ------------
! DECLARATION
  character(len=*), intent(in) :: sfile
  integer*4 :: nerr, i, j, n1, n2, nwavrs
  real*4 :: pint
  complex*8, allocatable :: wave(:,:) !(MS_dimx,MS_dimy)
  complex*8, allocatable :: work(:,:) !(FFT_BOUND,FFT_BOUND)
  external :: SaveDataC8
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > ExportWave: INIT."
  nerr = 0
  nwavrs = 0
  n1 = MS_dimx
  n2 = MS_dimy
  if (MS_wave_export_form==1) then
    n1 = MS_dimy
    n2 = MS_dimx
  end if
  allocate(wave(n1,n2), stat=nerr)
  if (nerr/=0) then
    call CriticalError("ExportWave: Failed to allocate memory.")
  end if
! ------------

! ------------
  if (MS_wave_export>0 .or. MS_wave_avg_export>0) then
    ! from calculation frame (MS_wave) to local frame (wave)
    if (MS_wave_export_form==1) then
      ! Fourier space export (direct copy)
      do j=1, n2
        wave(1:n1,j) = MS_wave(1:n1,j)
      end do
    else
      ! real space export (inverse FT)
      allocate(work(FFT_BOUND,FFT_BOUND), stat=nerr)
      if (nerr/=0) then
        if (allocated(wave)) deallocate(wave, stat=nerr)
        call CriticalError("ExportWave: Failed to allocate memory.")
      end if
      work = MS_wave
      call MS_FFT(work,MS_dimx,MS_dimy,'backwards')
      do j=1, n2
        wave(1:n1,j) = work(1:n1,j)
      end do
      nwavrs = 1
    end if
    if (MS_wave_export>0) then ! individual wave export to disk
      call PostMessage("  Writing to file ["//trim(sfile)//"].")
      call SaveDataC8(trim(sfile), wave, n1*n2, nerr)
    end if
    if (MS_wave_avg_export>0) then ! accumulation of the elastic wave
      MS_wave_avg(:,:,MS_wave_avg_idx) = MS_wave_avg(:,:,MS_wave_avg_idx) + wave
      MS_wave_avg_nac(MS_wave_avg_idx) = MS_wave_avg_nac(MS_wave_avg_idx) + 1
    end if
  end if
! ------------

! ------------
  if (MS_pint_export>0) then ! accumulation of probe intensities
    if (MSP_pimgmode>0) then ! real-space intensity accumulation
      if (nwavrs==0) then ! no real-space wave function generated here
        ! transform current wave function (MS_wave) to real space
        if (.not.allocated(work)) then
          allocate(work(FFT_BOUND,FFT_BOUND), stat=nerr)
          if (nerr/=0) then
            if (allocated(wave)) deallocate(wave, stat=nerr)
            call CriticalError("ExportWave: Failed to allocate memory.")
          end if
        end if
        work = MS_wave
        call MS_FFT(work,MS_dimx,MS_dimy,'backwards')
        ! accumulate probe image from work
        do j=1, MS_dimy
          do i=1, MS_dimx
            pint = real( work(i,j)*conjg(work(i,j)) )
            MSP_pimg(i,j,MS_pint_idx) = MSP_pimg(i,j,MS_pint_idx) + pint
          end do
        end do
      else ! real-space wave function was already created above
        ! accumulate probe image from wave
        do j=1, MS_dimy
          do i=1, MS_dimx
            pint = real( wave(i,j)*conjg(wave(i,j)) )
            MSP_pimg(i,j,MS_pint_idx) = MSP_pimg(i,j,MS_pint_idx) + pint
          end do
        end do
      end if
    end if
    if (MSP_pdifmode>0) then ! Fourier-space intensity accumulation
      ! accumulate probe diffraction pattern from MS_wave
      do j=1, MS_dimx
        do i=1, MS_dimy
          pint = real( MS_wave(i,j)*conjg(MS_wave(i,j)) )
          MSP_pdif(i,j,MS_pint_idx) = MSP_pdif(i,j,MS_pint_idx) + pint
        end do
      end do
    end if
    MSP_pint_nac(MS_pint_idx) = MSP_pint_nac(MS_pint_idx) + 1
  end if
! ------------

! ------------
! dealloc
  if (allocated(wave)) deallocate(wave, stat=nerr)
  if (allocated(work)) deallocate(work, stat=nerr)
!  write(unit=*,fmt=*) " > ExportWave: EXIT."
  return

END SUBROUTINE ExportWave
!**********************************************************************!


!!**********************************************************************!
!!**********************************************************************!
!SUBROUTINE ExportWave2(nidx,sfile)
!! function: 
!! -------------------------------------------------------------------- !
!! parameter: 
!! -------------------------------------------------------------------- !
!
!  use MultiSlice
!  use MSAparams
!
!  implicit none
!
!! ------------
!! DECLARATION
!  integer*4, intent(in) :: nidx
!  character(len=*), intent(in) :: sfile
!  integer*4 :: lfu, nerr, i, j, i1, j1, n2, m2, n, m
!  complex*8, allocatable :: wave(:,:) !(MS_dimx,MS_dimy)
!  complex*8, allocatable :: work(:,:) !(FFT_BOUND,FFT_BOUND)
!  character(len=1000) :: sfile1, sfile2
!! ------------
!
!! ------------
!! INIT
!!  write(unit=*,fmt=*) " > ExportWave2: INIT."
!  call PostMessage("Exporting current wave function, real space and Fourier space.")
!  n = MS_dimx
!  m = MS_dimy
!  n2 = n/2
!  m2 = m/2
!  ! we expect the file name to have no extension. extension and space sign are added
!  ! "_rs.wav" and "_fs.wav"
!  if (MSP_FL_varnum>1.and.nidx>0) then
!    write(unit=sfile1,fmt='(A,I<MSP_nvard>.<MSP_nvard>,A)') trim(sfile)//"_fs_",nidx,".wav"
!    write(unit=sfile2,fmt='(A,I<MSP_nvard>.<MSP_nvard>,A)') trim(sfile)//"_rs_",nidx,".wav"
!  else
!    sfile1 = trim(sfile)//"_fs.wav"
!    sfile2 = trim(sfile)//"_rs.wav"
!  end if
!! ------------
!
!! ------------
!! allocations
!  allocate(work(FFT_BOUND,FFT_BOUND),wave(MS_dimx,MS_dimy), stat=nerr)
!  if (nerr/=0) then
!    call CriticalError("ExportWave2: Failed to allocate memory.")
!  end if
!  ! get current wave
!  work = MS_wave
!! ------------
!
!! ------------
!! by standard the wave is in Fourier space, scrambled and transposed
!! We want to export the Fourier-space wave also, thus unscramble and
!! transpose the data and save it to file
!  ! unscramble and transpose
!  do j=1, m
!    j1 = modulo(j-1+m2,m)+1 ! unscramble j
!    do i=1, n
!      i1 = modulo(i-1+n2,n)+1 ! unscramble i
!      wave(i,j) = work(j1,i1) ! transpose
!    end do
!  end do
!  ! export the fourier-space data
!  call PostMessage("  Writing to file ["//trim(sfile1)//"].")
!  call GetFreeLFU(lfu,20,100)
!  call createfilefolder(trim(sfile1),nerr)
!  open(unit=lfu, file=trim(sfile1), form='binary', access='sequential', &
!     & iostat=nerr, status="replace", action="write", share='DENYRW' )
!  if (nerr/=0) then
!    call CriticalError("ExportWave2: Failed to open file ["//trim(sfile1)//"].")
!  end if
!  write(unit=lfu,iostat=nerr) wave
!  if (nerr/=0) then
!    call CriticalError("ExportWave2: Failed to write data.")
!  end if
!  close(unit=lfu)
!! ------------
!
!! ------------
!! Now we start with the real-space export
!! wave is still in fourier space, thus transfer back
!  call PostMessage("  Transforming to real space.")
!  call MS_FFT(work,MS_dimx,MS_dimy,'backwards')
!  do j=1, MS_dimy
!    do i=1, MS_dimx
!      wave(i,j) = work(i,j)
!    end do
!  end do
!! export the fourier-space data
!  call PostMessage("  Writing to file ["//trim(sfile2)//"].")
!  call GetFreeLFU(lfu,20,100)
!  call createfilefolder(trim(sfile2),nerr)
!  open(unit=lfu, file=trim(sfile2), form='binary', access='sequential', &
!     & iostat=nerr, status="replace", action="write", share='DENYRW' )
!  if (nerr/=0) then
!    call CriticalError("ExportWave2: Failed to open file ["//trim(sfile2)//"].")
!  end if
!  write(unit=lfu,iostat=nerr) wave
!  if (nerr/=0) then
!    call CriticalError("ExportWave2: Failed to write data.")
!  end if
!  close(unit=lfu)
!! ------------
!
!! ------------
!! dealloc
!  deallocate(work,wave,stat=nerr)
!  call PostMessage("Finished wave function export.")
!!  write(unit=*,fmt=*) " > ExportWave2: EXIT."
!  return
!
!END SUBROUTINE ExportWave2
!!**********************************************************************!

!!**********************************************************************!
!!**********************************************************************!
!SUBROUTINE ExportWaveDirect(sfile)
!! function: saves the current wavefunction as is
!! -------------------------------------------------------------------- !
!! parameter: 
!! -------------------------------------------------------------------- !
!
!  use MultiSlice
!  use MSAparams
!
!  implicit none
!
!! ------------
!! DECLARATION
!  character(len=*), intent(in) :: sfile
!  character(len=MSP_ll) :: isfile
!  integer*4 :: lfu, nerr, i, j
!  complex*8, allocatable :: wave(:,:) !(MS_dimx,MS_dimy)
!  
!! ------------
!
!! ------------
!! INIT
!!  write(unit=*,fmt=*) " > ExportWave: INIT."
!  call PostMessage("Exporting current wavefunction.")
!! allocations
!  allocate(wave(MS_dimx,MS_dimy), stat=nerr)
!  if (nerr/=0) then
!    call CriticalError("ExportWave: Failed to allocate memory.")
!  end if
!  ! transferring data to correct field size
!  do j=1, MS_dimy
!    do i=1, MS_dimx
!      wave(i,j) = MS_wave(i,j)
!    end do
!  end do
!! ------------
!
!! ------------
!  if (MS_wave_export>0) then ! individual wave export to disk
!    call PostMessage("  Writing to file ["//trim(sfile)//"].")
!    call GetFreeLFU(lfu,20,100)
!    call createfilefolder(trim(sfile),nerr)
!    open(unit=lfu, file=trim(sfile), form='binary', access='sequential', &
!       & iostat=nerr, status="replace", action="write", share='DENYRW' )
!    if (nerr/=0) then
!      call CriticalError("ExportWave: Failed to open file ["//trim(isfile)//"].")
!    end if
!    write(unit=lfu,iostat=nerr) wave
!    if (nerr/=0) then
!      call CriticalError("ExportWave: Failed to write data.")
!    end if
!    close(unit=lfu)
!    call PostMessage("  Finished wavefunction export.")
!  end if
!  if (MS_wave_avg_export>0) then ! accumulation of the elastic wave
!    call PostMessage("  Accumulating to elastic wavefunction.")
!    MS_wave_avg(:,:,MS_wave_avg_idx) = MS_wave_avg(:,:,MS_wave_avg_idx) + wave
!    MS_wave_avg_nac(MS_wave_avg_idx) = MS_wave_avg_nac(MS_wave_avg_idx) + 1
!  end if
!! ------------
!
!! ------------
!! dealloc
!  deallocate(wave,stat=nerr)
!!  write(unit=*,fmt=*) " > ExportWave: EXIT."
!  return
!
!END SUBROUTINE ExportWaveDirect
!!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
SUBROUTINE SaveResult(soutfile)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

  use MSAparams
  use MultiSlice
  
  implicit none

! ------------
! DECLARATION
  character*(*), intent(in) :: soutfile
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > SaveResult: INIT."
! ------------

! ------------
  if (MSP_ctemmode==0) then
    call ExportSTEMData(soutfile)
    ! OUT: done in MS_CalculateNextSlice, switch /wave
!    if (MS_epwave_export==1) then
!      call ExportWave2(0,trim(MS_epwave_filenm))
!    end if
  else
    ! call ExportWave(0,soutfile) ! done in MS_CalculateNextSlice by default for CTEM mode
  end if

! ------------

! ------------
!  write(unit=*,fmt=*) " > SaveResult: EXIT."
  return

END SUBROUTINE SaveResult
!**********************************************************************!






























!**********************************************************************!
!**********************************************************************!




!**********************************************************************!
!**********************************************************************!
!SUBROUTINE COMMENT TEMPLATE
!**********************************************************************!
!**********************************************************************!


!**********************************************************************!
!**********************************************************************!
!SUBROUTINE <NAME>(<PARAMS>)
! function: 
! -------------------------------------------------------------------- !
! parameter: 
! -------------------------------------------------------------------- !

!  implicit none

! ------------
! DECLARATION
! ------------

! ------------
! INIT
!  write(unit=*,fmt=*) " > <NAME>: INIT."
! ------------

! ------------
! 
! ------------

! ------------
!  write(unit=*,fmt=*) " > <NAME>: EXIT."
!  return

!END SUBROUTINE <NAME>
!**********************************************************************!