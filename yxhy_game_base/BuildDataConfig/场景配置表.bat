set ExcelFileName=�������ñ�
set ExcelSheetName=SceneConfig

call xlsc_lua.bat %ExcelFileName% %ExcelSheetName%
call xlsc_cs.bat %ExcelFileName% %ExcelSheetName%
pause