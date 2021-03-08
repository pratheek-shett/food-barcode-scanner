//
//  HomeView.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/7/21.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @StateObject var router: Router
    
    var body: some View {
        Text("You are logged in!")
        Button(action: { signOut() }, label: {
            Text("SIGN OUT")
        })
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
}




//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
