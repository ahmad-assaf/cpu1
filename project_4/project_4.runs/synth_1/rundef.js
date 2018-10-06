//
// Vivado(TM)
// rundef.js: a Vivado-generated Runs Script for WSH 5.1/5.6
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//

var WshShell = new ActiveXObject( "WScript.Shell" );
var ProcEnv = WshShell.Environment( "Process" );
var PathVal = ProcEnv("PATH");
if ( PathVal.length == 0 ) {
<<<<<<< HEAD
  PathVal = "C:/Xilinx/SDK/2018.2/bin;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/lib/nt64;C:/Xilinx/Vivado/2018.2/bin;";
} else {
  PathVal = "C:/Xilinx/SDK/2018.2/bin;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/bin/nt64;C:/Xilinx/Vivado/2018.2/ids_lite/ISE/lib/nt64;C:/Xilinx/Vivado/2018.2/bin;" + PathVal;
=======
  PathVal = "E:/Xilinx2/SDK/2018.2/bin;E:/Xilinx2/Vivado/2018.2/ids_lite/ISE/bin/nt64;E:/Xilinx2/Vivado/2018.2/ids_lite/ISE/lib/nt64;E:/Xilinx2/Vivado/2018.2/bin;";
} else {
  PathVal = "E:/Xilinx2/SDK/2018.2/bin;E:/Xilinx2/Vivado/2018.2/ids_lite/ISE/bin/nt64;E:/Xilinx2/Vivado/2018.2/ids_lite/ISE/lib/nt64;E:/Xilinx2/Vivado/2018.2/bin;" + PathVal;
>>>>>>> 9f234ae7243396eb0e45841a488f94b5c496e2b7
}

ProcEnv("PATH") = PathVal;

var RDScrFP = WScript.ScriptFullName;
var RDScrN = WScript.ScriptName;
var RDScrDir = RDScrFP.substr( 0, RDScrFP.length - RDScrN.length - 1 );
var ISEJScriptLib = RDScrDir + "/ISEWrap.js";
eval( EAInclude(ISEJScriptLib) );


ISEStep( "vivado",
         "-log cpu1.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source cpu1.tcl" );



function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
