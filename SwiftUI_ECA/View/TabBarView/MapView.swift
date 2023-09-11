//
//  MyProfileView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 12/9/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
//    @StateObject private var vm = ViewModel()
    @EnvironmentObject var vm: ViewModel
//    @ObservedObject var vm = ViewModel()
    @StateObject private var locationVM = LocationViewModel()
    @EnvironmentObject private var locVM: LocationViewModel
    
    var body: some View {

        NavigationView{
        Map(coordinateRegion: $locationVM.region, showsUserLocation: true, annotationItems: vm.list) {
            place in

            MapAnnotation(coordinate: place.location) {
                NavigationLink(
                    destination: DogDetailView(dog: place), label: {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text(place.name)
                                .foregroundColor(.black)
                        }
                        .font(.system(size: 13))
                        .padding(7.5)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    })

            }
        }
        .ignoresSafeArea()
        .accentColor(Color(.systemPink))
        .onAppear {
            locationVM.checkIfLocationServicesIsEnabled()
            vm.getData()
        }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

