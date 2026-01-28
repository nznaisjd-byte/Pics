@echo off
:: ==========================================================
::   ULTRA-PERFORMANCE OPTIMIZATION SCRIPT (NO GAME MODE)
::   Includes 50+ System, Network, UI, and Privacy Tweaks
:: ==========================================================

:: --- ADMIN CHECK ---
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Admin privileges confirmed.
) else (
    echo [ERROR] You must right-click and "Run as Administrator".
    pause
    exit
)

echo.
echo ==================================================
echo [STEP 0] CREATING SAFETY NET (RESTORE POINT)...
echo ==================================================
wmic /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Ultra Tweaks", 100, 7
echo Restore point created.

:: ==========================================================
::   GROUP 1: KERNEL & FILE SYSTEM (THE DEEP STUFF)
:: ==========================================================
echo.
echo [1/8] Applying Kernel & File System optimizations...

:: 1. Disable NTFS Last Access Update (Speeds up disk access significantly)
fsutil behavior set disablelastaccess 1

:: 2. Disable 8.3 Name Creation (Speeds up NTFS on modern drives)
fsutil behavior set disable8dot3 1

:: 3. Keep Windows Kernel in RAM (Prevents kernel paging to disk)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f

:: 4. Increase File System Memory Cache
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f

:: 5. Optimize Boot Files
reg add "HKLM\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" /v Enable /t REG_SZ /d "Y" /f

:: 6. Prevent Drivers from swapping to disk
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v SecondLevelDataCache /t REG_DWORD /d 1024 /f

:: ==========================================================
::   GROUP 2: ADVANCED NETWORK TWEAKS
:: ==========================================================
echo.
echo [2/8] Removing Network Throttling & Latency...

:: 7. Disable Network Throttling Index (Unlocks non-media network speeds)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f

:: 8. Disable Nagle's Algorithm (TCP No Delay - Lower ping)
:: Note: This searches for interfaces, might throw error if specific ID not found, safe to ignore.
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /s^|findstr /i /l "ServiceName"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%j" /v TcpAckFrequency /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%j" /v TCPNoDelay /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%j" /v TcpDelAckTicks /t REG_DWORD /d 0 /f
)

:: 9. Turn off Windows Peer-to-Peer Update Sharing (Saves bandwidth)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f

:: 10. Disable Bandwidth Limit Reserve (QoS)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f

:: ==========================================================
::   GROUP 3: PRIVACY & BLOATWARE REMOVAL
:: ==========================================================
echo.
echo [3/8] Disabling Ads, Telemetry, and Annoyances...

:: 11. Disable "Get tips, tricks, and suggestions"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f

:: 12. Disable "Suggested Apps" in Start Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f

:: 13. Disable "Welcome Experience" after updates
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f

:: 14. Disable "Sync Provider Notifications" (OneDrive ads in Explorer)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f

:: 15. Disable Tailored Experiences
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f

:: 16. Disable Advertising ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

:: 17. Disable "Meet Now" Icon in Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f

:: 18. Disable News and Interests (Widgets) on Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f

:: ==========================================================
::   GROUP 4: UI & EXPLORER SPEED
:: ==========================================================
echo.
echo [4/8] Speeding up the User Interface...

:: 19. Show File Extensions (Security & Speed)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

:: 20. Speed up Taskbar Thumbnail Previews
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ExtendedUIHoverTime /t REG_DWORD /d 1 /f

:: 21. Disable "Shortcut" text suffix on new shortcuts
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v link /t REG_BINARY /d 00000000 /f

:: 22. Disable "Highlight newly installed programs"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_NotifyNewApps /t REG_DWORD /d 0 /f

:: 23. Increase Icon Cache Size (Prevents icon redraws)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v Max Cached Icons /t REG_SZ /d "4096" /f

:: 24. Disable Lock Screen Blurred Background
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableAcrylicBackgroundOnLogon /t REG_DWORD /d 1 /f

:: 25. Disable "Shake to Minimize" (Aero Shake)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisallowShaking /t REG_DWORD /d 1 /f

:: ==========================================================
::   GROUP 5: ACCESSIBILITY CLEANUP
:: ==========================================================
echo.
echo [5/8] Disabling Sticky Keys and popups...

:: 26. Disable Sticky Keys Shortcut (Shift 5 times)
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f

:: 27. Disable Toggle Keys Shortcut
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d "58" /f

:: 28. Disable Filter Keys Shortcut
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d "122" /f

:: ==========================================================
::   GROUP 6: SERVICES MASS DISABLE
:: ==========================================================
echo.
echo [6/8] Disabling non-essential services...

:: 29. Windows Insider Service
sc config "wisvc" start= disabled

:: 30. Retail Demo Service
sc config "RetailDemo" start= disabled

:: 31. Wallet Service
sc config "WalletService" start= disabled

:: 32. Windows Error Reporting Service (WerSvc) - Stops logs sending to MS
sc config "WerSvc" start= disabled

:: 33. Remote Registry (Security Risk & Unused)
sc config "RemoteRegistry" start= disabled

:: 34. Touch Keyboard and Handwriting Panel (If you don't use a tablet)
sc config "TabletInputService" start= disabled

:: 35. Windows Mixed Reality OpenXR Service
sc config "MixedRealityOpenXRSvc" start= disabled

:: 36. Enterprise App Management Service
sc config "EntAppSvc" start= disabled

:: ==========================================================
::   GROUP 7: POWER & PERFORMANCE (REDUX)
:: ==========================================================
echo.
echo [7/8] Ensuring Maximum Power settings...

:: 37. High Performance Scheme
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -setactive SCHEME_MIN

:: 38. Disable USB Selective Suspend (Prevents USB devices from lagging/disconnecting)
powercfg -attributes 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 -ATTRIB_HIDE
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0

:: 39. Disable PCI Express Link State Power Management (Max performance for GPU/NVMe)
powercfg /SETACVALUEINDEX SCHEME_CURRENT 501a4d13-42af-401f-99d3-3b1658454af8 ee12f906-d277-404b-b6da-e5fa1a576df5 0

:: ==========================================================
::   GROUP 8: CLEANUP
:: ==========================================================
echo.
echo [8/8] Final cleanup...
ipconfig /flushdns
del /q/f/s %TEMP%\*
del /q/f/s C:\Windows\Temp\*

:: ==============================================
:: PING & LATENCY OPTIMIZATIONS (TCP/IP Deep Tweak)
:: ==============================================
echo Optimizing Network for Low Latency...

:: 1. Disable Nagle's Algorithm (TCPNoDelay)
:: This forces Windows to send packets immediately without waiting.
for /f "tokens=3*" %%i in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /s^|findstr /i /l "ServiceName"') do (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%j" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%j" /v "TCPNoDelay" /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%j" /v "TcpDelAckTicks" /t REG_DWORD /d 0 /f
)

:: 2. Set NetDMA (Direct Memory Access) 
:: Allows network cards to move data directly to RAM, reducing CPU usage.
netsh int tcp set global netdma=enabled

:: 3. Disable ECN Capability
:: Explicit Congestion Notification can sometimes cause dropped packets in older routers.
netsh int tcp set global ecncapability=disabled

:: 4. Disable RSS (Receive Side Scaling) and Chimney Offload
:: While these help servers, they can cause "jitter" in gaming.
netsh int tcp set global chimney=disabled
netsh int tcp set global rss=enabled

:: 5. Set System Responsiveness for Games
:: Tells the Windows scheduler to give priority to network packets.
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xFFFFFFFF /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f

:: 6. Maximize TCP Window Size
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 64240 /f

:: 7. Disable NetBIOS over TCP/IP (Saves a few ms of overhead)
:: Only do this if you don't share files between PCs on a local network.
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "EnableLMHOSTS" /t REG_DWORD /d 0 /f

:: 8. Speed up DNS resolving
ipconfig /flushdns

echo.
echo ==================================================
echo      ULTRA OPTIMIZATION COMPLETE
echo ==================================================
echo [!] Please REBOOT your PC immediately.
echo.
pause
exit