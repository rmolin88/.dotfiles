import os
import subprocess

USER_PROFILE = os.getenv('USERPROFILE')

BACKUP_DIRS = [
    r'{USER_PROFILE}\Documents\apps',
    r'{USER_PROFILE}\AppData\Roaming\gnupg',
    r'{USER_PROFILE}\.password-store',
    r'D:\1.WINGS',
    r'D:\2.Office',
    r'D:\3.Other',
    r'D:\cdats',
    r'D:\wiki',
    r'D:\wings-dev',
]

DRIVE = 'E'
DEST_DIR = fr'{DRIVE}:\StationBackups\reinaldo_laptop'
THREADS = 2
LOG = r'%TEMP%\robo.log'
ROBOCOPY_OPTS = f'''/MIR /W:0 /R:1 /MT:{THREADS} /FFT /XJD /NP /NDL /ZB /ETA /E /CREATE'''
ROBOCOPY_EXE = r'C:\Windows\System32\Robocopy.exe'

def main():
    """main"""

    for dir in BACKUP_DIRS:
        base = os.path.basename(dir)
        dst = os.path.join(DEST_DIR, base)
        cmd = f'{ROBOCOPY_EXE} {dir} {dst} {ROBOCOPY_OPTS}'
        print(f"Executing:\n\t{cmd}....")
        sub = subprocess.Popen(cmd)
        sub.wait()


if __name__ == "__main__":
    main()
