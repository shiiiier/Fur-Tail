import SwiftUI
import FirebaseStorage
import Firebase

struct MyDogDetailsView: View {
    @ObservedObject var model:ViewModel = ViewModel()
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var image: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var imagePathList = [String]()
    @State var showAlert: Bool = false
    @State var imageURL: String = ""
    
    var dog: Dog
    var body: some View {
        
        VStack {
            Image(uiImage: image ?? UIImage(named: "dog_2")!)
//            Image("dog_2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            
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
//            Text("Owner")
//                .fontWeight(.medium)
//                .multilineTextAlignment(.leading)
                    HStack {
                        Text("Owner's Name")
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
                    HStack {
                        Text("Image URL")
                        Spacer()
                        Text(imageURL)
                            .foregroundColor(.gray)
                            .font(.callout)
                    }
                }
                Button("Choose Picture") {
                    self.showSheet = true
                }
                .foregroundColor(.red)
                .actionSheet(isPresented: $showSheet) {
                    ActionSheet(title: Text("Select Photo"),
                                buttons: [
                                    .default(Text("Photo Library")) {
                                        self.showImagePicker = true
                                        self.sourceType = .photoLibrary
                                    },
                                    .default(Text("Camera")) {
                                        self.showImagePicker = true
                                        self.sourceType = .camera
                                    },
                                    .cancel()
                                ])
                }
                
                Button("Delete Dog") {
                    model.deleteData(dogtoDelete: dog)
                    model.getData()
                    self.mode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker2(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType)
            }
        }
        .toolbar(content: {
            if image != nil {
                Button("Upload") {
                    uploadPhoto()
                    model.getData()
                }
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Photo uploaded!"))})
                .foregroundColor(.red)
            }
        })

    }
    func uploadPhoto() {
        guard image != nil else {
            return
        }
        
        //Create storage reference
        let storageRef = Storage.storage().reference()
        let imageData = image!.jpegData(compressionQuality: 0.7)
        
        guard imageData != nil else {
            return
        }

        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let uploadTask = fileRef.putData(imageData!, metadata:  nil) {
            metadata, error in
            
            if error == nil && metadata != nil {

                    print("Did Upload function executed?4")
                    let db = Firestore.firestore()
                    let path = "images/\(UUID().uuidString).jpg"
                    self.imageURL = path
                    let documentId = dog.id
                    db.collection("dogs").document(String(documentId)).setData(["imageURL": path], merge: true) {
                        error in
                        if error == nil {
//                            model.getData()
                            let storage = Storage.storage()
                            let pathReference = storage.reference(withPath: path)
                            pathReference.downloadURL { url, error in
                                if let error = error {
                                    // Handle any errors
//                                    print(error)
                                } else {
                                    guard let urlString = url?.absoluteString else {
                                        return
                                    }
                                    print(url?.absoluteString)
//                                    self.imageURL = urlString
                                }
                            }
                            
                            
                            print("Path is \(path)")
//                            DispatchQueue.main.async {
//                                model.getData()
//                                self.imagePathList.append(path)
//                                self.retrievedImages.append(self.image!)
//                                print(self.retrievedImages)
//                                self.retrievedImages = dog.imageList
//                                print(dog.imageList)
//                            }
                        }
                    }
                }
            }
        model.getData()
        }
    
    func retrievePhotos() {
        
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(dog.imageURL as! String)
        
        fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                if let image = UIImage(data:  data!) {
                    self.image = image}
            }
        }
}
}
