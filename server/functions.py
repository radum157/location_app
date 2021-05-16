import face_recognition

import urllib.request

import smtplib, ssl

import os

def compare_two_faces(l1, l2):
    
    # Opening the links

    response1 = urllib.request.urlopen(l1) 
    response2 = urllib.request.urlopen(l2)
    
    # Loading images

    image1 = face_recognition.load_image_file(response1)
    image2 = face_recognition.load_image_file(response2)

    TOLERANCE = 0.6

    # Encoding

    image1_encoding = face_recognition.face_encodings(image1)[0]
    image2_encoding = face_recognition.face_encodings(image2)[0]

    result = face_recognition.compare_faces([image1_encoding], image2_encoding)

    print(result)
    return result

def send_an_email(name, user_email, match_email, match_number):
    port = 465  # For SSL
    smtp_server = "smtp.gmail.com" 
    sender_email = "rtech12121@gmail.com"
    receiver_email = user_email
    password = os.getenv("PASSWORD")
    text = "Looks like we found a match for " + name + ". You can ask for further details via email: " + match_email + " or phone number: " + match_number + "."
    subject = "Match found"
    message = "Subject: {}\n\n{}".format(subject, text)

    context = ssl.create_default_context()
    with smtplib.SMTP_SSL(smtp_server, port, context=context) as server:
        server.login(sender_email, password)
        server.sendmail(sender_email, receiver_email, message)    
        server.quit()
