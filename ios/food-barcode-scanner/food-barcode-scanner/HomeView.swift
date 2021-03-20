//
//  HomeView.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/7/21.
//

import CodeScanner
import SwiftUI
import Firebase

struct HomeView: View {
    @StateObject var router: Router
    @State var isPresented = false
    @State var scannedCode: String?
    @StateObject var barcodeVM = BarcodeScanViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("You Are Logged In!")
                
                Button("Scan Code") {
                    self.isPresented = true
                }
                .sheet(isPresented: $isPresented) {
                    self.scannerSheet
                }
                
                Text(scannedCode ?? "No value")
                
                if scannedCode != nil, barcodeVM.barcodeData != nil {
                    DisplayBarcodeInfo(scannedCode: self.scannedCode, barcodeVM: barcodeVM)
                }
                
                Button(action: { signOut() }, label: { Text("SIGN OUT") })
                    .padding()
            }
            .navigationTitle(Text("Home"))
        }
    }
    
    var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.ean8, .ean13, .pdf417],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code
                    DispatchQueue.main.async {
                        self.barcodeVM.getData(scannedCode: code)
                    }
                    self.isPresented = false
                }
            }
        )
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

struct DisplayBarcodeInfo: View {
    var scannedCode: String?
    @StateObject var barcodeVM: BarcodeScanViewModel

    var body: some View {
        Text(scannedCode ?? "no code")
        Text("Ingredients")
        ForEach(barcodeVM.barcodeData!.ingredients, id: \.self) { item in
            Text(item)
        }

        Text("Nutrition Facts")
        VStack {
            Text("Cholesterol: \(barcodeVM.barcodeData!.nutritionFacts.cholesterol)")
            Text("Cholesterol Percentage: \(barcodeVM.barcodeData!.nutritionFacts.cholesterolPercentage)")
            Text("Protein: \(barcodeVM.barcodeData!.nutritionFacts.protein)")
            Text("Protein Percentage: \(barcodeVM.barcodeData!.nutritionFacts.proteinPercentage)")
            Text("Sodium: \(barcodeVM.barcodeData!.nutritionFacts.sodium)")
            Text("Sodium Percentage: \(barcodeVM.barcodeData!.nutritionFacts.sodiumPercentage)")
            Text("Total Carbohydrate: \(barcodeVM.barcodeData!.nutritionFacts.totalCarbohydrate)")
            Text("Total Carbohydrate Percentage: \(barcodeVM.barcodeData!.nutritionFacts.totalCarbohydratePercentage)")
            Text("Total Fat: \(barcodeVM.barcodeData!.nutritionFacts.totalFat)")
            Text("Total Fat Percentage: \(barcodeVM.barcodeData!.nutritionFacts.totalFatPercentage)")
        }

    }

}

class BarcodeScanViewModel: ObservableObject {
    @Published var barcodeData: BarcodeTemplate?
    
    func getData(scannedCode: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("barcodes").child(scannedCode).getData { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value! as Any, options: []) else { return }
                DispatchQueue.main.sync {
                    self.barcodeData = try? JSONDecoder().decode(BarcodeTemplate.self, from: data)
                }
                print(self.barcodeData?.ingredients ?? "No Value")
            }
            else {
                print("No data available")
            }

        }
    }
}

struct BarcodeTemplate: Codable, Identifiable {
    var id: String
    var ingredients: [String]
    var nutritionFacts: NutritionFactsTemplate
}

struct NutritionFactsTemplate: Codable {
    var cholesterol: String
    var cholesterolPercentage: String
    var protein: String
    var proteinPercentage: String
    var sodium: String
    var sodiumPercentage: String
    var totalCarbohydrate: String
    var totalCarbohydratePercentage: String
    var totalFat: String
    var totalFatPercentage: String
}


//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
