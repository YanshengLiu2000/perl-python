import sys
import re

target_word = sys.argv[1]
#print(target_word)
count_number = 0
for line in sys.stdin:
    # print(line)
    for i in re.findall('[a-z]+', line):
        if i == target_word:
            count_number += 1
print(target_word+" occurred "+str(count_number)+" times")
