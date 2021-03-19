//
//  BarcodeScannerWrapper.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/10/21.
//

import SwiftUI

struct BarcodeScannerWrapper: UIViewControllerRepresentable {
    @Binding var result: String?
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
    
    func makeUIViewController(context: Context) -> UIViewController {
//        let barcodeScanner = BarcodeScanner()
        let barcodeScannerViewControler = BarcodeScanner()
//        result = barcodeScanner.result
//        result = barcodeScanner.result
//        print("wrapper: \(result ?? "result is nil")")
//        barcodeScanner.dataSource = context.coordinator
        return barcodeScannerViewControler
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
//    class Coordinator: NSObject {
//        var parent: BarcodeScannerWrapper
//
//        init(_ barcodeScannerWrapper: BarcodeScannerWrapper) {
//            parent = barcodeScannerWrapper
//        }
//    }
    

}
