
from urllib.request import urlopen


shakespeare = urlopen('https://www.composingprograms.com/shakespeare.txt')
print(shakespeare.read().decode('utf-8'))