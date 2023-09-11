//
//  ViewModel.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 8/9/22.
//
import Firebase
import FirebaseAuth
import Foundation
import GoogleSignIn
import FirebaseStorage
import MapKit

class ViewModel: ObservableObject {
    
    @Published var list = [Dog]()
    @Published var myProfileDogList = [Dog]()
    @Published var dogWithVaccList = [Dog]()
    @Published var state: SignInState = .signedOut

    let db = Firestore.firestore()
    
    init() {
        getData()

    }
    
    // Google Sign in
    enum SignInState {
        case signedIn
        case signedOut
    }
        
    func signIn() {
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn() { [unowned self]
                user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController)
            { [ unowned self ] user, error in
                authenticateUser( for: user, with: error)
            }
        }
    }
    
    private func authenticateUser( for user: GIDGoogleUser?, with error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) {
            [ unowned self ] (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.state = .signedIn
            }
        }
    }
    
    func signOut() {
        
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            
            state = .signedOut
            
        } catch {
            print(error.localizedDescription)
        }
    }
    // Google Function ends here
    func addData(name: String, gender: String, age: String, breed: String, vaccStatus: String, ownerName: String, latitude: Double, longitude: Double) {
        
        let db = Firestore.firestore()
        
        // Getting user UID so that it can be filtered out later
        guard let userID = Auth.auth().currentUser?.uid else { return }
        // print("User's UID: \(userID)")
        
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let todayDate = formatter1.string(from: today)
   
        db.collection("dogs").addDocument(data: ["name": name,
                                                 "gender": gender,
                                                 "age": age,
                                                 "breed": breed,
                                                 "vaccStatus": vaccStatus,
                                                 "ownerUID": userID,
                                                 "date": todayDate,
                                                 "ownerName": ownerName,
                                                 "latitude": latitude,
                                                 "longitude": longitude,
                                                 "imageURL": ""
                                                 ]) { error in
            
            if error == nil {
                self.getData()
            }
            else {
                // Handle the error
            }
        }
    }
    
    func getData() {
        
        // Read document from collection
        db.collection("dogs").getDocuments { snapshot, error in
            
            if error == nil {
                // No errors
                
                if let snapshot = snapshot {
                    // Get all the documents
                    
                    DispatchQueue.main.async {
                        // print(snapshot.documents)
                        // return all memory address of document
//                        var profileImage: UIImage?
                        self.list = snapshot.documents.map { d in
//                            
//                            let storageRef = Storage.storage().reference()
//                            let fileRef = storageRef.child(d["imageURL"] as! String)
//                            
//                            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                                if error == nil && data != nil {
//                                    if let image = UIImage(data:  data!) {
//                                            profileImage = image}
//                                }
//                            }
                            return Dog(id: d.documentID,
                                       name: d["name"] as? String ?? "",
                                       gender: d["gender"] as? String ?? "",
                                       age: d["age"] as? String ?? "",
                                       imageURL: d["imageURL"] as? String ?? "",
                                       ownerUID: d["ownerUID"] as? String ?? "",
                                       vaccStatus: d["vaccStatus"] as? String ?? "",
                                       latitude: d["latitude"] as? Double ?? 1,
                                       longitude: d["longitude"] as? Double ?? 2,
                                       breed: d["breed"] as? String ?? "",
                                       ownerName: d["ownerName"] as? String ?? "",
                                       date: d["date"] as? String ?? "",
                                       imageList: [UIImage]()
                                       //image: profileImage ?? UIImage(named: "dog_2")!

                            )
                        }
                        self.getDogWithVacc()
                        self.getMyProfileDog()
                    }
                }
                else {
                    // Handle the error
                }

            }
        }
    }
    
    func getMyProfileDog() {

        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("dogs").whereField("ownerUID", isEqualTo: userID).getDocuments { snapshot, error in
            if error == nil {
                // No errors

                if let snapshot = snapshot {
                    // Get all the documents
                    
                    DispatchQueue.main.async {
                        // print(snapshot.documents)
                        // return all memory address of document
                        var profileImage: UIImage?
                        
                        self.myProfileDogList = snapshot.documents.map { d in
                            

                            return Dog(id: d.documentID,
                                       name: d["name"] as? String ?? "",
                                       gender: d["gender"] as? String ?? "",
                                       age: d["age"] as? String ?? "",
                                       imageURL: d["imageURL"] as? String ?? "",
                                       ownerUID: d["ownerUID"] as? String ?? "",
                                       vaccStatus: d["vaccStatus"] as? String ?? "",
                                       latitude: d["latitude"] as? Double ?? 1,
                                       longitude: d["longitude"] as? Double ?? 2,
                                       breed: d["breed"] as? String ?? "",
                                       ownerName: d["ownerName"] as? String ?? "",
                                       date: d["date"] as? String ?? "",
                                       imageList: [UIImage]()
                            )
                        }
//
                    }
                }
                else {
                    // Handle the error
                }
            }
        }
    }

    func getDogWithVacc() {

        // Read document from collection
        db.collection("dogs").whereField("vaccStatus", isEqualTo: "Yes").getDocuments  { snapshot, error in

            if error == nil {
                // No errors

                if let snapshot = snapshot {
                    // Get all the documents
                    
                    DispatchQueue.main.async {
                        // print(snapshot.documents)
                        // return all memory address of document
                        var profileImage: UIImage?
                        
                        self.dogWithVaccList = snapshot.documents.map { d in
                            
//                            let storageRef = Storage.storage().reference()
//                            let fileRef = storageRef.child(d["imageURL"] as! String)
//
//                            fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                                if error == nil && data != nil {
//                                    if let image = UIImage(data:  data!) {
//                                            profileImage = image}
//                                }
//                            }
//
                            
                            return Dog(id: d.documentID,
                                       name: d["name"] as? String ?? "",
                                       gender: d["gender"] as? String ?? "",
                                       age: d["age"] as? String ?? "",
                                       imageURL: d["imageURL"] as? String ?? "",
                                       ownerUID: d["ownerUID"] as? String ?? "",
                                       vaccStatus: d["vaccStatus"] as? String ?? "",
                                       latitude: d["latitude"] as? Double ?? 1,
                                       longitude: d["longitude"] as? Double ?? 2,
                                       breed: d["breed"] as? String ?? "",
                                       ownerName: d["ownerName"] as? String ?? "",
                                       date: d["date"] as? String ?? "",
                                       imageList: [UIImage]()

                            )
                        }
//
                    }
                }
                }
                else {
                    // Handle the error
                }
            }
        }
    
//    func getProfilePhoto(dog: Dog) -> UIImage {
//        let storageRef = Storage.storage().reference()
//        let fileRef = storageRef.child(dog.imageURL as! String)
//        
//        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//            if error == nil && data != nil {
//                if let image = UIImage(data:  data!) {
//                    return image
//                    
//                }
//            }
//        }
//    }
//    func uploadPhoto(selectedImage:UIImage?, dog: Dog) {
//
//        guard selectedImage != nil else {
//            return
//        }
//
//        //Create storage reference
//        let storageRef = Storage.storage().reference()
//        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
//
//        guard imageData != nil else {
//            return
//        }
//
//        let path = "images/\(UUID().uuidString).jpg"
//        let fileRef = storageRef.child(path)
//
//        let uploadTask = fileRef.putData(imageData!, metadata:  nil) {
//            metadata, error in
//
//            if error == nil && metadata != nil {
//                // Save reference
//                let db = Firestore.firestore()
//
//                let documentId = dog.id
//                db.collection("dogs").document(String(documentId)).setData(["imageURL": path], merge: true) {
//                    error in
//                    if error == nil {
//                        DispatchQueue.main.async {
//                            self.getData()
//                            self.retrieveProfilePhoto(dog: dog)
//                        }
//
//                    }
//                }
//
//            }
//        }
//    }
    
    func retrieveProfilePhoto(dog: Dog) {
        
        var profileImage: UIImage?
        
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(dog.imageURL)
        
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                if let image = UIImage(data:  data!) {
                    
                    profileImage = image
                }
            }
        }
        
    }
    
    func deleteData(dogtoDelete: Dog) {
        
        db.collection("dogs").document(dogtoDelete.id).delete(completion: {
            error in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    self.list.removeAll() { dog in
                        
                        return dog.id == dogtoDelete.id
                    }
                    self.myProfileDogList.removeAll() { dog in
                        
                        return dog.id == dogtoDelete.id
                    }
                }
            }
        })    }
}
    
    
    

