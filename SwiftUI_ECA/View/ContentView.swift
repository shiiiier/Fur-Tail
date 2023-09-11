//
//  ContentView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 8/9/22.
//

import SwiftUI
import Firebase
import Foundation


struct ContentView: View {
    
    @ObservedObject var model:ViewModel = ViewModel()
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        switch viewModel.state {
        case .signedIn:
            TabView {
                MapView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home ")
                    }
                DogListView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Full Listing")
                    }
                AddANewDogView()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add")
                    }
                MyDogView()
                    .tabItem {
                        Image(systemName: "heart.square")
                        Text("My Dog")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("My Profile")
                    }
            }.accentColor(.gray)

                
                
        case .signedOut: LoginView()
        }
    }
}



// DogListView()
//                .environmentObject(ViewModel())
//                .navigationTitle("Dog Listings")
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



