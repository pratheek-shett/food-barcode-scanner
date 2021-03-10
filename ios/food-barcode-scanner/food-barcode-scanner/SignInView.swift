//
//  ContentView.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/6/21.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @StateObject var router: Router
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
            
        VStack {
            Text("Sign In")
                .font(.title)
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(width: 150, height: 30, alignment: .center)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(width: 150, height: 30, alignment: .center)
                .padding(.horizontal, 20)
            
            Button(action: { signIn() }, label: { Text("Sign In") })
                .padding(.top, 20)
            Button(action: { router.currentPage = .RegisterPage }, label: { Text("New User? Create an Account") })
                .padding()
        }
        
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                router.currentPage = .HomePage
                print("Success")
            }
        }
    }
    
    
}

















//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
