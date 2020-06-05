"""
A handy way of creating folders for downloaded face database

Put the images of each individual into separate folder

"""


import os
import shutil

from os import listdir
from os.path import isfile, join

# Put the images inside 'images' folder
# Make sure the folder contains 2800 images
image_database_path = os.getcwd() + '\images'

# List of all images
image_files = [f for f in listdir(image_database_path) if isfile(join(image_database_path, f))]

# Construction of dictionaries for each person
people_dict = {}
for image_file in image_files:
    people_no = image_file.split('-')[0]

    if people_no not in people_dict:
        people_dict[people_no] = [image_file]
    else:
        people_dict[people_no].append(image_file)


# for person, images in people_dict.items():
#     print('→', person, images, '(' + str(len(images)) + ' images.)', '\n')


# print(os.getcwd())
folders_path = os.getcwd() + '\\_FaceDatabase' + '\\'
print(folders_path)

people = list(people_dict.keys())
print(people)

for person, images in people_dict.items():
    # creating images for train folder
    train_folder_name = person
    os.makedirs(folders_path + train_folder_name)
    for image in images[0:10]:
        shutil.copy('images/' + image, folders_path + train_folder_name + '/' + image)

    # creating images for test folder
    test_folder_name = 'test_' + person
    os.makedirs(folders_path + test_folder_name)
    # for image in images[10]:
    #     shutil.copy('images/' + image, test_folder_name + '/' + image)

    # just image-11 test foldering
    shutil.copy('images/' + images[10], folders_path + test_folder_name + '/' + images[10])

    for image in images[11:13]:
        shutil.copy('images/' + image, folders_path + train_folder_name + '/' + image)

# for image_file in image_files:
#     people_no = image_file.split('-')[0]
#     os.mkdir(people_no)
#     shutil.copy(f, 'test/' + f[:-3] + '/' + f)

# print(len(image_files))
# print(image_files)
