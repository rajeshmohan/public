import json
import fileinput

for line in fileinput.input():
    d = json.loads(line)
    print d['firewall_policy']['id']
