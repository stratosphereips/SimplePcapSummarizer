import sys
try:
    import woothee
except ImportError as e:
    print("Install woothee via pip3 to use this module")
    sys.exit()

print(woothee.parse(sys.argv[1])[sys.argv[2]])
