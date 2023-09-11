//
//  DogCellView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 12/9/22.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct DogCellView: View {
    var dog: Dog
    @State var profileImage: UIImage?
    @State var urlString: String = ""
    
    var body: some View {
        HStack{

            Image("dog_2")
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5) {
                Text(dog.name)
                    .fontWeight(.bold)
                Text(dog.breed)
                    .foregroundColor(.gray)
            }
        }
    
    .onAppear {self.featchImageUrl()}

}

    func featchImageUrl() {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: dog.imageURL)
        pathReference.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print(error)
            } else {
                guard let urlString = url?.absoluteString else {
                    return
                }
                self.urlString = urlString
            }
        }
    }
}

//
//struct Loader : UIViewRepresentable {
//
//    func makeUIView(context: UIViewControllerRepresentableContext<Loader>) -> UIActivityIndicatorView {
//
//        let indicator = UIActivityIndicatorView(style: large)
//        indicator.startAnimating()
//        return indicator
//    }
//    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewControllerRepresentableContext<Loader>) {
//        <#code#>
//    }
//}

