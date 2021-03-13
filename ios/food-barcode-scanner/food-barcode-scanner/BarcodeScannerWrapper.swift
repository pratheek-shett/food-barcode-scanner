//
//  BarcodeScannerWrapper.swift
//  food-barcode-scanner
//
//  Created by Lor Worwag on 3/10/21.
//

import SwiftUI

struct BarcodeScannerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let barcodeScanner = BarcodeScanner()
        return barcodeScanner
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }

}
