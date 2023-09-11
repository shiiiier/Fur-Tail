//
//  DogList.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 9/9/22.
//

import SwiftUI
import Foundation
import Firebase

struct DogListView: View {
    @EnvironmentObject var model: ViewModel
    
    @State private var isPresented: Bool = false
    @State var searchingFor = ""
    @State var selection: String = "All"
    let filterOptions: [String] = ["All", "Vaccinated"]
    
    var body: some View {
        
        NavigationView{
            
            VStack{
            if selection == "All" {
                List(model.list, id: \.id) { dog in
                    NavigationLink(
                        destination: DogDetailView(dog: dog), label: {
                            DogCellView(dog: dog)
                        })
                }
            } else {
                List(model.dogWithVaccList, id: \.id) { dog in
                    NavigationLink(
                        destination: DogDetailView(dog: dog), label: {
                            DogCellView(dog: dog)
                        })
                }
            }
            }
                .navigationTitle("Dog Listings")
                .toolbar{
                    Picker(
                        selection: $selection,
                        label:
                            HStack {
                                Text("Filter: ")
                                Text(selection)
                            }
                        ,
                        content: {
                            ForEach(filterOptions, id: \.self) { option in
                                Text(option)
                                    .tag(option)
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                    )
                    .pickerStyle(MenuPickerStyle())
                }
        }
    }
}

struct DogList_Previews: PreviewProvider {
    static var previews: some View {
        DogListView()
            .environmentObject(ViewModel())
    }
}


//NavigationView{
//    List(model.list, id: \.id) { dog in
//        NavigationLink(
//            destination: DogDetailView(dog: dog), label: {
//                DogCellView(dog: dog)
//            })
//    }
//    .navigationTitle("Dog Listings")
//    .toolbar{
//        Button("Filters") {
//            isPresented = true
//        }
//    }
//    .sheet(isPresented: $isPresented) {
//        FilterView(vm: FilterViewModel())
//    }
//}
