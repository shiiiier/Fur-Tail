//
//  AddANewDog.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 9/9/22.
//

import SwiftUI
import MapKit

struct AddANewDogView: View {
    
//    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var model: ViewModel
    @ObservedObject var locationManager = LocationViewModel()
    @State var showAlert: Bool = false
    
    @State var name = ""
    @State var gender = ""
    @State var age = ""
    @State var breed = ""
    @State var vaccStatus = ""
    @State var selection = ""
    
    @State var ownerName = ""

    let option: [String] = [
    "Yes", "No"]
    
    var body: some View {
        
        NavigationView{
            VStack {
                Form {
                Section(header: Text("Dog Information")) {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                    TextField("Breed", text: $breed)
                    HStack{
                        Text("Gender")
                            .foregroundColor(.gray)
                        Spacer()
                        Picker("Gender", selection: $gender) {
                            Text("F").tag("Female")
                            Text("M").tag("Male")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    HStack{
                        Text("Vaccinated?")
                            .foregroundColor(.gray)
                        Spacer()
                        Picker("Vaccination Status", selection: $selection) {
                            Text("Yes").tag("Yes")
                            Text("No").tag("No")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                }
                Section(header: Text("Owner Details")) {
                    TextField("Name", text: $ownerName)
                }
                }
                Spacer()
                }
            .navigationTitle("Add A Dog")
            .toolbar {
                Button("Save") {
                    model.addData(name: name,
                                  gender: gender,
                                  age: age,
                                  breed: breed,
                                  vaccStatus: selection,
                                  ownerName: ownerName,
                                  latitude: 1.2837,
                                  longitude: 103.8509
                    )
                    name = ""
                    gender = ""
                    age = ""
                    breed = ""
                    vaccStatus = ""
                    selection = ""
                    ownerName = ""
                    showAlert.toggle()
                }
                .disabled(name.isEmpty || age.isEmpty || breed.isEmpty)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("Dog added successfully!"))})
                .foregroundColor(.red)
            }
            }
        }
}
                           

