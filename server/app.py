import firebase_admin
from firebase_admin import credentials, storage, firestore

import time
import datetime
import os

import functions
from functions import compare_two_faces, send_an_email


# Initializing the Admin SDK

credential_path = (r"C:\Users\Radu\HE\proiect\serviceAccountKey.json")
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path

cred = credentials.Certificate(r"C:\Users\Radu\HE\proiect\serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'rtech-1e4b2.appspot.com'
})

# Variables 

bucket = storage.bucket()
db = firestore.Client()

# Getting a list of all images
def get_images_list(bucket_f):
    image_names = []
    for blob in bucket_f.list_blobs():
        name = str(blob.name)
        image_names.append(name)
    return image_names


app_run = True
first_run = True
image_list_1 = []

# Waiting for users to upload pictures

while image_list_1 == []:
    image_list_1 = get_images_list(bucket)

while app_run:
    image_list_2 = image_list_1
    print(image_list_2)
    if first_run == False:
        #time.sleep(5)
        image_list_1 = []
        while image_list_1 == []:
            image_list_1 = get_images_list(bucket)
    elif first_run == True:
        first_run = False
        image_list_2 = [] # Modifying the second list
    
    # Checking differences

    if(image_list_1 != image_list_2):
        
        # Verifying the documents
        lost_coll = db.collection(u'lost_posts')
        found_coll = db.collection(u'found_posts')

        lost_docs = []
        found_docs = []

        while lost_docs == [] and found_docs == []:
            lost_docs = lost_coll.get()
            found_docs = found_coll.get()
            print(lost_docs)
            print(found_docs)

        for lost_doc in lost_docs:
            lost_doc_dict = lost_doc.to_dict()
            image_name = lost_doc_dict["images"][0]
            blob1 = bucket.blob("images/" + str(image_name))
            link1 = blob1.generate_signed_url(datetime.timedelta(seconds=300), method='GET')
            
            for found_doc in found_docs:
                found_doc_dict = found_doc.to_dict()
                image_name = found_doc_dict["images"][0]
                blob2 = bucket.blob("images/" + str(image_name))
                link2 = blob2.generate_signed_url(datetime.timedelta(seconds=300), method='GET')
                
                result = compare_two_faces(link1, link2)
                
                # Match found

                if result == [True]:
                    print(str(lost_doc_dict["name"]) + " was found.")

                    # Sending emails

                    lost_match = str(lost_doc_dict["email"])
                    found_match = str(found_doc_dict["email"])
                    name = str(lost_doc_dict["name"])
                    lost_number = str(lost_doc_dict["number"])
                    found_number = str(found_doc_dict["number"])

                    send_an_email(name, found_match, lost_match, lost_number)
                    send_an_email(name, lost_match, found_match, found_number)

                    # Deleting files

                    db.collection(u'lost_posts').document(lost_doc.id).delete()
                    db.collection(u'found_posts').document(found_doc.id).delete()
                    blob1.delete()
                    blob2.delete()

                    break
