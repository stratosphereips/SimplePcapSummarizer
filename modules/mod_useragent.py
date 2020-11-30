import sys
try:
    from user_agents import parse
except ImportError as e:
    print("Run: pip install pyyaml ua-parser user-agents")
    sys.exit()

print(parse(sys.argv[1]))
