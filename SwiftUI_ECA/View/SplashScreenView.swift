//
//  SplashScreenView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 11/9/22.
//

import SwiftUI
import Foundation

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack{
                VStack {
                    Image("COCO")
                        .resizable()
                        .frame(width: 300, height: 300)
                    Text("Dog Mate")
                        .fontWeight(.black)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Text("Your Only DogNetworking App")
                        .lineLimit(2)
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.7))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
//                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }

    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
