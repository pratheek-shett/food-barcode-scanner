//
//  food_barcode_scannerApp.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/6/21.
//

import SwiftUI
import Firebase

@main
struct food_barcode_scannerApp: App {
    
    init() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
    }
    
    @StateObject var router: Router = Router()
    
    var body: some Scene {
        WindowGroup {
            RouterView(router: router)
        }
    }
}


class Router: ObservableObject {
    @Published var currentPage: Page = .HomePage
}

enum Page {
    case SignInPage
    case RegisterPage
    case HomePage
}

