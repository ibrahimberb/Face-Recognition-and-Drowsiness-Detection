# Application of Image Processing Tecniques on Vehicles

### Group Member
Fahrulnisa Sema Özbaş
Ibrahim Berber

### Requirements

```
* MATLAB R2019a
* USB/Internal webcam
```


## Face Recognition

### Database
Download the  FEI Database from following link.

https://fei.edu.br/~cet/facedatabase.html

> `originalimages_part1 (~ 84MB)`
> `originalimages_part2 (~ 87MB)`
> `originalimages_part3 (~ 86MB)`
> `originalimages_part4 (~ 87MB)`
 
 
### Prepare folders

Run the python foldering code for creating separate folders for each individual.

1. Extract four achieves on the same folder.

2. Move the images inside the folder into `database_processing\images`.

3. Execute `foldering.py`. Further modification can be done with code.

4. Now the database is ready. The directory should contain the following folders:

```
1 2 3 ... 200
images
test_1  test_2  test_3  ... test_200
```
 
### Register yourself (optional)

You can register yourself with GUI registration. 

1. Run the `GUI_Registration\Registering_Driver.m`

2. Write your *name* and click on *Activate Camera*

3. Capture your images, make sure your face is detected.

4. Include the created folder inside downloaded database.

 
### Train the model

1. Run the `face_registration\train_architecture.m` and train the architecture.

2. Store trained model `trainedNet` file.
 
 
### Specify authorized users

Specify the authorized user names in `face_registration\authorized_users.txt` file. For convenience, you can use `face_registration\driver.py` GUI app add/remove users.
 
 
### Test the model with given input

1. Run `input_testing.m` file. 

2. Select subject image from file dialog to see its testing accuracy.


## Drowsiness Detection

### Create a template of your open eye (optional)

1. Copy your captured image inside `drowsiness_detection` folder.

2. Run `templateProcessing.m` to generate your open eye template image.

### Testing with real-time video stream

> Note: For better performance, make sure your eyes are illuminated with a direct light projected on your face with frontal angle. Also, keep a distance of 35 to 50 cm to your webcam.

1. Run the `eyeTrack.m` file. 

2. Wait for it to register your eyes. (R > 0.10)


## Demo videos
### Face recognition
https://youtu.be/xd6nh1Ohc3Y

### Drowsiness detection
https://www.youtube.com/watch?v=UbYcYF4xsbY
