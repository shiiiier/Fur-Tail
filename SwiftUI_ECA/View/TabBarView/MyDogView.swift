//
//  MyDogView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 14/9/22.
//

import SwiftUI

struct MyDogView: View {
    
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                List(model.myProfileDogList, id: \.id) { dog in
                    NavigationLink(
                        destination: MyDogDetailsView(dog: dog), label: {
                            DogCellView(dog: dog)
                        }
                    )
                }
                
            }
            .navigationTitle("My Dog")
        }
    }
}

struct MyDogView_Previews: PreviewProvider {
    static var previews: some View {
        MyDogView()
    }
}
