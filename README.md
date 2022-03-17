Requirements:
Operating System: Linux
Required packages: bc, screen

This monitoring "system" is only for Linux!

Please make sure you have the crontabs installed for AutoRestart and AutoDatabaseClear

AutoRestart:
@reboot bash /monitor/runMonitoring.sh

AutoClear:
0 0 * * * bash /monitor/cleanDatabase.sh
