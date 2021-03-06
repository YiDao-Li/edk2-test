# 
#  Copyright 2006 - 2010 Unified EFI, Inc.<BR> 
#  Copyright (c) 2010, Intel Corporation. All rights reserved.<BR>
# 
#  This program and the accompanying materials
#  are licensed and made available under the terms and conditions of the BSD License
#  which accompanies this distribution.  The full text of the license may be found at 
#  http://opensource.org/licenses/bsd-license.php
# 
#  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
#  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
# 
################################################################################
CaseLevel         CONFORMANCE
CaseAttribute     AUTO
CaseVerboseLevel  DEFAULT
set reportfile    report.csv

#
# test case Name, category, description, GUID...
#
CaseGuid        F15D362A-DBD3-44c9-A4DD-AFC41DFB1A56
CaseName        ReadDirectory.Conf1.Case6
CaseCategory    MTFTP4
CaseDescription {This case is to test the EFI_INVALID_PARAMETER conformance of \
                 Mtftp4.ReadDirectory - one or more options in Token.OptionList\
                 have wrong format.}
################################################################################

proc CleanUpEutEnvironment {} {
#
# DelEntryInArpCache
#
  DelEntryInArpCache
  
  Mtftp4ServiceBinding->DestroyChild {@R_Handle1, &@R_Status}
  GetAck
  
  EndScope _MTFTP4_READDIRECTORY_FUNCTION1_CASE1_
  EndLog
}

#
# Begin log ...
#
BeginLog

Include MTFTP4/include/Mtftp4.inc.tcl

BeginScope _MTFTP4_READDIRECTORY_FUNCTION1_CASE1_

UINTN                            R_Status
UINTN                            R_Handle1
EFI_MTFTP4_CONFIG_DATA           R_MtftpConfigData

UINTN                            R_Context
EFI_MTFTP4_TOKEN                 R_Token
EFI_MTFTP4_OVERRIDE_DATA         R_OverrideData

CHAR8                            R_NameOfFile(20)
CHAR8                            R_ModeStr(8)
EFI_MTFTP4_OPTION                R_OptionList(8)
CHAR8                            R_OptionStr0(10)
CHAR8                            R_ValueStr0(10)
CHAR8                            R_OptionStr1(10)
CHAR8                            R_ValueStr1(10)


#
# Add an entry in ARP cache.
#
AddEntryInArpCache

#
# Mtftp4
#
LocalEther          [GetHostMac]
RemoteEther         [GetTargetMac]
LocalIp             192.168.88.1
RemoteIp            192.168.88.88

Mtftp4ServiceBinding->CreateChild "&@R_Handle1, &@R_Status"
GetAck
SetVar     [subst $ENTS_CUR_CHILD]  @R_Handle1
set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Mtftp4SBP.CreateChild - Create Child 1"                       \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_MtftpConfigData.UseDefaultSetting   FALSE
SetIpv4Address R_MtftpConfigData.StationIp   "192.168.88.88"
SetIpv4Address R_MtftpConfigData.SubnetMask  "255.255.255.0"
SetVar R_MtftpConfigData.LocalPort           2048
SetIpv4Address R_MtftpConfigData.GatewayIp   "0.0.0.0"
SetIpv4Address R_MtftpConfigData.ServerIp    "192.168.88.1"
SetVar R_MtftpConfigData.InitialServerPort   69
SetVar R_MtftpConfigData.TryCount            10
SetVar R_MtftpConfigData.TimeoutValue        2

Mtftp4->Configure {&@R_MtftpConfigData, &@R_Status}
GetAck

set assert [VerifyReturnStatus R_Status $EFI_SUCCESS]
RecordAssertion $assert $GenericAssertionGuid                                  \
                "Mtftp4.Configure - Normal operation."                         \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_SUCCESS"

SetVar R_NameOfFile                          "directory"
SetVar R_ModeStr                             "octet"

SetIpv4Address R_OverrideData.GatewayIp      "0.0.0.0"
SetIpv4Address R_OverrideData.ServerIp       "192.168.88.1"
SetVar R_OverrideData.ServerPort             0
SetVar R_OverrideData.TryCount               0
SetVar R_OverrideData.TimeoutValue           0

SetVar R_Token.OverrideData                  &@R_OverrideData
SetVar R_Token.ModeStr                       &@R_ModeStr
SetVar R_Token.Filename                      &@R_NameOfFile
SetVar R_OptionStr0                          "timeout"
SetVar R_ValueStr0                           "256"
SetVar R_OptionList(0).OptionStr             &@R_OptionStr0
SetVar R_OptionList(0).ValueStr              &@R_ValueStr0
SetVar R_OptionStr1                          "blksize"
SetVar R_ValueStr1                           "1024"
SetVar R_OptionList(1).OptionStr             &@R_OptionStr1
SetVar R_OptionList(1).ValueStr              &@R_ValueStr1
SetVar R_Token.OptionCount                   2
SetVar R_Token.OptionList                    &@R_OptionList
SetVar R_Token.BufferSize                    0
SetVar R_Token.Buffer                        0
SetVar R_Token.Context                       NULL

Mtftp4->ReadDirectory {&@R_Token, 1, 1, 1, &@R_Status}
GetAck

set assert [VerifyReturnStatus R_Status $EFI_INVALID_PARAMETER]
RecordAssertion $assert $Mtftp4ReadDirectoryConfAssertionGuid012               \
                "Mtftp4.ReadDirectory - returns EFI_INVALID_PARAMETER with     \
                 invalid timeout option value.(This value should be 1~255)"    \
                "ReturnStatus - $R_Status, ExpectedStatus - $EFI_INVALID_PARAMETER"

CleanUpEutEnvironment