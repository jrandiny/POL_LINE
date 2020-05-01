#!/bin/bash
# Date : (2020-05-01)
# Last revision : (2020-05-01)
# Wine version used : 5.7
# Distribution used to test : Ubuntu 20.04
# Author : jrandiny

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="LINE Messenger"
PREFIX="LINEMessenger"
WORKING_WINE_VERSION="5.7"

POL_SetupWindow_Init

POL_SetupWindow_presentation "$TITLE" "LINE Corporation" "https://line.me" "jrandiny" "$PREFIX"

POL_System_SetArch "x86"

POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"

Set_OS "win7"

POL_Call POL_Install_msvc90
POL_Call POL_Install_gecko
POL_Call POL_Install_corefonts
POL_Call POL_Install_msxml3
POL_Call POL_Install_dotnet40
POL_Call POL_Install_dotnet20
POL_Call POL_Install_dotnet20sp2
POL_Call POL_Install_vcrun2008

POL_SetupWindow_InstallMethod "LOCAL, DOWNLOAD"

if [ "$INSTALL_METHOD" == "LOCAL" ]; then
  cd $HOME
  POL_SetupWindow_browse "$(eval_gettext "Please select the setup file")" "$TITLE"
  SETUP_FILE="$APP_ANSWER"
fi
  
if [ "$INSTALL_METHOD" == "DOWNLOAD" ]; then
  cd "$WINEPREFIX/drive_c"
  POL_Download "https://desktop.line-scdn.net/win/new/LineInst.exe"
  SETUP_EXE="LineInst.exe"
fi

POL_SetupWindow_message "Please read before continuing\n\nLINE installer will automatically open the app after installation. Please quit the app immediately as soon as that happen" "$TITLE"

POL_Wine_WaitBefore "$TITLE"
POL_Wine start "$SETUP_EXE"
POL_Wine_WaitExit "$TITLE" --allow-kill


POL_SetupWindow_message "There are currently some minor graphical glitch (border arround LINE window on top of every app) when running LINE on normal mode. To overcome this you can enable 'virtual desktop' mode but notification will not be shown outside of the 'virtual desktop'" "$TITLE"
POL_SetupWindow_menu "Please choose" "$TITLE" "Normal~Virtual Desktop" "~"

if [ "$APP_ANSWER" == "Virtual Desktop" ]; then
  Set_Desktop "On" "1366" "768"
fi

POL_Shortcut "LINE.exe" "$TITLE"

rm -f $HOME/Desktop/LINE.desktop
rm -f $HOME/Desktop/LINE Uninstall.desktop

rm -rf $HOME/.local/share/applications/wine/Programs/LINE

update-desktop-database ~/.local/share/applications/

POL_SetupWindow_Close
exit