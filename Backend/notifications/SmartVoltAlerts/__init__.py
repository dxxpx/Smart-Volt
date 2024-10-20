import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate('\\smartvolt1\\Backend\\Credentials\\cred.json')  # Update with your JSON filename
firebase_admin.initialize_app(cred)
