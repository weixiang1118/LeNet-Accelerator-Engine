import subprocess
import os
import shutil

root_dirs = ["./actstart", "./actend", "./weightstart", "./weightend"]
for root_dir in root_dirs:
    os.makedirs(root_dir, exist_ok=True)


# List of script files to execute in order
scripts = [
    "convert.py",
    "weight.py",
    "golden.py",
    "input.py",
    "convert_h.py",
]

for script in scripts:
    try:
        print(f"Running {script}...")
        result = subprocess.run(["python", script], check=True)
        print(f"{script} executed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error occurred while executing {script}: {e}")


print('Removed some folders\n')


shutil.rmtree('./actstart')
print('Removed actstart folder successfully\n')
shutil.rmtree('./actend')
print('Removed actend folder successfully\n')
shutil.rmtree('./weightstart')
print('Removed weightstart folder successfully\n')
shutil.rmtree('./weightend')
print('Removed weightend folder successfully\n')

print('Removed successfully')
print('Done!\n')