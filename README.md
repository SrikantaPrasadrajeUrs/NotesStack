# 📒 Notes Stack  

A **Flutter notes app** with **Email/Password Authentication**, **Fingerprint Login**, and **Notes CRUD functionality**.  

---

## 🚀 Features  

✅ **Authentication**  
- Email & Password **Login / Register**  
- Fingerprint / Biometric **Login Support**  

✅ **Notes Management (CRUD)**  
- Create 📝  
- Read 👀  
- Update ✏️  
- Delete 🗑️  

✅ **Profile**  
- Upload & update **Profile Picture** 👤  
- User details stored securely  

✅ **Storage & Database**  
- **Firebase** → Authentication & Database  
- **Supabase** → Profile image storage  

---

## 🛠️ Tech Stack  

- **Flutter** (UI framework)  
- **Dart** (Programming language)  
- **Firebase Auth & Firestore** (Login, Register, Notes DB)  
- **Supabase Storage** (Profile Images)  

---

## 📸 Screenshots  

<p align="center">
  <img src="https://github.com/user-attachments/assets/28f8aaa6-0098-4454-bd87-a2b8a09d235b" width="250" />
  <img src="https://github.com/user-attachments/assets/71d947ee-9a4f-4c78-8baa-9ee8dcc0764b" width="250" />
  <img src="https://github.com/user-attachments/assets/61bdc46a-99d5-4290-9f9e-bef06d48e3db" width="250" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/4b7d5ced-38b3-4209-8767-22f8419f1c7a" width="250" />
  <img src="https://github.com/user-attachments/assets/858de958-2a2e-40f6-bc88-8b884ff2dbbd" width="250" />
  <img src="https://github.com/user-attachments/assets/19b236b5-3c48-4a44-bb5e-114a3b4a9bc1" width="250" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/9f44ce9c-ddb9-4fd9-9dac-881f0fe0e61a" width="250" />
</p>  

---

## 📲 Getting Started  

1. Clone this repository:  
   ```bash
   git clone https://github.com/SrikantaPrasadrajeUrs/NotesStack.git
   cd NotesStack

2. flutter pub get
3. Configure Firebase & Supabase:
    - Add google-services.json (Android) or GoogleService-Info.plist (iOS).
    - Setup Supabase project & update storage bucket details (make sure to change constants/Env.dart).
4. flutter run
