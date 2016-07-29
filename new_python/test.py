import os

list = os.listdir(".")
for file in list:
    index = file.find(".py")
    if index >= 0:
        filename = file[:index]
        print filename
