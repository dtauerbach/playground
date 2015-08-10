#!/usr/bin/env python

import copy
import sys

whitelisted_letters = list(sys.argv[1])
minimal_letters = list(sys.argv[2])

def contains_minimally(word):
    wordlist = list(word)
    for letter in minimal_letters:
        if letter not in wordlist:
            return False
        wordlist.remove(letter)
    return True

def banned(word):
    tmp_whitelisted_letters = copy.deepcopy(whitelisted_letters)
    for letter in word:
        if letter not in tmp_whitelisted_letters:
            return True
        tmp_whitelisted_letters.remove(letter)
    return False

with open('/usr/share/dict/words', 'r') as f:
    words = f.read().split()
    new_words = [word for word in words if contains_minimally(word) and not banned(word)]
    new_words.sort(key=len)
    for word in new_words:
        print word
