import SwiftUI

struct LoginView: View {

     @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {

        VStack{
    
            Image("COCO")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
            Text("Welcome!")
                .fontWeight(.black)
                .foregroundColor(.black)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(height: 700)
        HStack {
            Image("google")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
            Button {
                viewModel.signIn()
            } label: {
                Text("Sign in with Google")
                    .fontWeight(.bold)
                .foregroundColor(.red)
            }
        }
            

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
    
}
