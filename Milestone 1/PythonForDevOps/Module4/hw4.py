import sys, rpmfile

path_to_file = sys.argv[1]

with rpmfile.open(path_to_file) as rpm_file:
    print(rpm_file.headers.get('release').decode('ascii'), sep='\n')

# Execute command:
# /usr/bin/python3 /home/eugenia/python/module4/hw4.py /home/eugenia/python/module4/some_package.el6.x86_64.rpm