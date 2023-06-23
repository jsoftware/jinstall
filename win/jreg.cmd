@rem registers JEXEServer and JDLLServer
@rem run as Administrator
@rem /regserver to register the exe server
@rem /unregserver to unregister the exe server
"%~dp0bin\jqt.exe" /regserver
regsvr32 /s "%~dp0bin\j.dll"
