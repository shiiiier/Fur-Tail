//
//  DogDetailView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 9/9/22.
//

import SwiftUI

struct DogDetailView: View {
    
    @ObservedObject var model:ViewModel = ViewModel()
    var dog: Dog
    var body: some View {
        
        VStack {
//            Image(uiImage: dog.image)
            Image("dog_2")
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
                
            }
            }
        }
    }
}

//struct DogDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DogDetailView()
//    }
//}
