//
//  RegisterView.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/7/21.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @StateObject var router: Router
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
//        NavigationView {
        VStack {
            Text("Create Account")
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
            Button(action: { Register() }, label: { Text("Register") })
                .padding(.top, 20)
                
//                NavigationLink(destination: SignInView()) {
//                    Text("Go To Sign In")
//                }
                    
//            }
        }
        
    }
    
    func Register() {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("Success")
            }
        }
    }
}









//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
