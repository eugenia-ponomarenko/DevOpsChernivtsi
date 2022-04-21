import os
from sys import argv
 
if __name__ == "__main__":
	path = argv[1]
	prefix = argv[2]
	counts = int(argv[3])
	mode = int(argv[4])
	for i in range(1, counts+1):
		name = prefix + str(i)
		pth = os.path.join(os.path.expanduser('~'), path, name)
		os.mkdir(pth, mode)
