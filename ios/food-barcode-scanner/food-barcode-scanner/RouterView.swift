//
//  Router.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/7/21.
//

import SwiftUI
//import Firebase

struct RouterView: View {
    
    @StateObject var router: Router

    var body: some View {
        switch router.currentPage {
        case .SignInPage:
            SignInView(router: router)
        case .RegisterPage:
            RegisterView(router: router)
        case .HomePage:
            HomeView(router: router)
        }
    }
    
}
