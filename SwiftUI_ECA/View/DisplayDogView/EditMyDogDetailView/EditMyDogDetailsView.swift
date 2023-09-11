//
//  EditMyDogDetailsView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 14/9/22.
//

import SwiftUI
import FirebaseStorage
import Firebase
//import FirebaseFirestore

struct EditMyDogDetailsView: View {
    
    @ObservedObject var model:ViewModel = ViewModel()
    @ObservedObject private var locationManager = LocationViewModel()
    
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var profileImage: UIImage?
    @State var showAlert: Bool = false
    
    var dog: Dog
    var body: some View {
        
            VStack {
            Button {
                //show imagePicker
                isPickerShowing = true
                
            } label: {
                if selectedImage == nil {
                    ZStack(alignment: .bottomTrailing){
                        Image("dog_1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        
                    }
                } else {
                    ZStack(alignment: .bottomTrailing){
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
                }
            }

            Text(dog.name)
                .font(.title)
                . fontWeight(.medium)
            
            Form {
                Section {
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(dog.gender)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    HStack {
                        Text("Age")
                        Spacer()
                        Text(String(dog.age))
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    HStack {
                        Text("Breed")
                        Spacer()
                        Text(dog.breed)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    HStack {
                        Text("Vaccination Status")
                        Spacer()
                        Text(dog.vaccStatus)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                }
            }
            
            VStack{
            Text("Owner")
                //.font(.title2)
                .fontWeight(.medium)
              
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(dog.ownerName)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                    HStack {
                        Text("Date created")
                        Spacer()
                        Text(dog.date)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                }
            }
            }
        }
        .toolbar(content: {
            if selectedImage != nil {
                Button("Upload") {
                    uploadPhoto()
                }
//                .alert(isPresented: $showAlert, content: {
//                    Alert(title: Text("Photo uploaded!"))})
                .foregroundColor(.red)
            }
        })
        
        Divider()
        
        HStack {
            ForEach(retrievedImages, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
        
        .sheet(isPresented:  $isPickerShowing, onDismiss: nil) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
        .onAppear {
            self.retrievePhotos()
        }
    }
    
    
    func uploadPhoto() {
            
        print("Did Upload function executed?")
        guard selectedImage != nil else {
            return
        }
        
        print("Did Upload function executed?2")
        //Create storage reference
        let storageRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        print("Did Upload function executed?3")
//        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let uploadTask = fileRef.putData(imageData!, metadata:  nil) {
            metadata, error in
            
            if error == nil && metadata != nil {

                    print("Did Upload function executed?4")
                    let db = Firestore.firestore()

                    let documentId = dog.id
                    db.collection("dogs").document(String(documentId)).setData(["imageURL": "images/\(UUID().uuidString).jpg"], merge: true) {
                        error in
                        if error == nil {
                            print("Path is \("images/\(UUID().uuidString).jpg")")
                            DispatchQueue.main.async {
                                self.retrievedImages.append(self.selectedImage!)
                            }
                        }
                    }
                }
            }
        }
    

    func retrievePhotos() {

        let db = Firestore.firestore()

        db.collection("dogs").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {

                var paths = [String]()

                for doc in snapshot!.documents {
                    paths.append(doc["imageURL"] as! String)
                }

                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(path)

                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            if let image = UIImage(data:  data!) {
                                
                                DispatchQueue.main.async {
                                    
                                    retrievedImages.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
