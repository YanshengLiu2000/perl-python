import sys
import re

total_number = 0
for line in sys.stdin:
    for i in re.findall('[a-z]+', line):
        total_number += 1
print(str(total_number) + " words")
