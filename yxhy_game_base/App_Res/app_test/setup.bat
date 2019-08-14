echo.
echo =================Prepare test resources=======================


::---------------------------------------------------
::��һ����ɾ��Assets/Ŀ¼���ϵ���Դ
::---------------------------------------------------
@echo off
set AssetPath=G:\dstars\chess_u3d\yxhy_game_base\Assets
set SourcePath=G:\dstars\chess_u3d\yxhy_game_base\App_Res\app_test
cd %AssetPath%

@echo on
echo try to delete old assets, please wait for a moment:
cd Res_XYHY
rd /s /q "."
echo clear Res_XYHY over.
cd ..
for /f "delims=" %%a in ('dir /b/ad/s YX_app_*' ) do (
	if exist "%%a" rd /s/q "%%a" 
)
echo clear YX_app_* over.
for /f "delims=" %%a in ('dir /b/ad/s YX_game_*' ) do (
	if exist "%%a" rd /s/q "%%a" 
)
echo clear YX_game_* over.


::---------------------------------------------------
::�ڶ���������Ҫ���е�Assets��Դ��������ǰĿ¼
::---------------------------------------------------
mkdir YX_app_4
xcopy %SourcePath%\YX_app_4 %AssetPath%\YX_app_4 /S
xcopy %SourcePath%\YX_app_4.meta %AssetPath% /S
mkdir YX_game_11
xcopy %SourcePath%\YX_game_11 %AssetPath%\YX_game_11 /S
xcopy %SourcePath%\YX_game_11.meta %AssetPath% /S
mkdir YX_game_18
xcopy %SourcePath%\YX_game_18 %AssetPath%\YX_game_18 /S
xcopy %SourcePath%\YX_game_18.meta %AssetPath% /S

::---------------------------------------------------
::������������Ҫ���е�Prefab��Դ������Res_XYHY
::---------------------------------------------------
mkdir Res_XYHY
xcopy %SourcePath%\Res_XYHY Res_XYHY /S
pause
