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
    @State var barcodeScanner: BarcodeScanner
    @State var action: Int? = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("You Are Logged In!")
                
                NavigationLink(destination: BarcodeScannerWrapper(), tag: 1, selection: $action) {
                    Button(action: {
                        action = 1
                    }, label: { Text("SCAN BARCODE") })
                    .padding()
                }
                
                Button(action: { signOut() }, label: { Text("SIGN OUT") })
                    .padding()
            }
            .navigationTitle(Text("Home"))
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            router.currentPage = .SignInPage
            
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
