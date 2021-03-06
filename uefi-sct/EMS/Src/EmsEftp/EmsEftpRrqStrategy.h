/** @file
 
  Copyright 2006 - 2010 Unified EFI, Inc.<BR> 
  Copyright (c) 2010, Intel Corporation. All rights reserved.<BR>
 
  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at 
  http://opensource.org/licenses/bsd-license.php
 
  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
 
**/
/*++

Module Name:
  
    EmsEftpRrqStrategy.h
    
Abstract:

    Incude header files EMS Eftp

--*/

#ifndef __EMS_EFTP_RRQ_STRATEGY_H__
#define __EMS_EFTP_RRQ_STRATEGY_H__

INT32
EmsEftpRrqStrategyOpen (
  Eftp_Strategy       *Strategy,
  CONST INT8          *FileName
  )
/*++

Routine Description:

  Open an Eftp read request strategy

Arguments:

  Strategy  - The strategy should be opened
  FileName  - The name of the file which will be accessed

Returns:

  -1 Failure
  0  Success

--*/
;

VOID
EmsEftpRrqStrategyClose (
  Eftp_Strategy *Strategy
  )
/*++

Routine Description:

  Close the EMS Eftp read requeset strategy

Arguments:

  Strategy  - The strategy should be closed

Returns:

  None

--*/
;

VOID
EmsEftpRrqStrategyHandlePkt (
  Eftp_Strategy *Strategy,
  CONST INT8    *PktBuffer,
  INT32         Length
  )
/*++

Routine Description:

  The routine be used to process packages which corresponding to read
  request

Arguments:

  Strategy  - The session's strategy
  PktBuffer - The data buffer of packet
  Length    - The length of the data buffer of packet

Returns:

  None

--*/
;

#endif
