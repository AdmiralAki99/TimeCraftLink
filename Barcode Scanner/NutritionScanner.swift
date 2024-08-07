//
//  NutritionScanner.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-05.
//

import Foundation
import AVFoundation
import Vision
import SwiftUI
import VisionKit

struct NutritionScannerScreen : View {
    var body: some View {
        CameraScanner()
    }
}

//struct BarcodeScanner : View {
//    
//    @State private var captureSession: AVCaptureSession?
//    @State private var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    func startCapture(){
//        guard let device = AVCaptureDevice.default(for: .video) else{
//            return
//        }
//        do{
//            let input = try AVCaptureDeviceInput(device: device)
//            captureSession = AVCaptureSession()
//            captureSession?.addInput(input)
//            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//            previewLayer?.videoGravity = .resizeAspectFill
//            previewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight)
//            captureSession?.startRunning()
//        }catch{
//            print(String(describing: error))
//        }
//    }
//    
//    var body: some View {
//        ZStack{
//            CameraView(captureSession: $captureSession, previewLayer: $previewLayer)
//        }.onAppear(){
//            startCapture()
//        }.onDisappear(){
//            captureSession?.stopRunning()
//        }
//    }
//}
//
//struct CameraView: UIViewRepresentable{
//    @Binding var captureSession: AVCaptureSession?
//    @Binding var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    func makeUIView(context: Context) -> some UIView {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        previewLayer?.removeFromSuperlayer()
//        if let previewLayer = previewLayer{
//            uiView.layer.addSublayer(previewLayer)
//        }
//    }
//}

struct CameraScanner : View {
    @State private var barcodeResult : String = ""
    @State private var isScanning : Bool = true
    
    var body: some View {
        NavigationView{
            BarcodeScannerViewController(isScanning: $isScanning, barcodeText: $barcodeResult)
        }
    }
}

struct BarcodeScannerViewController : UIViewControllerRepresentable{
    
    @Binding var isScanning: Bool
    @Binding var barcodeText: String
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(recognizedDataTypes: [.barcode()], qualityLevel: .fast, recognizesMultipleItems: false, isHighFrameRateTrackingEnabled: false, isPinchToZoomEnabled: true, isGuidanceEnabled: false, isHighlightingEnabled: true)
        
        vc.delegate = context.coordinator
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if isScanning{
            do{
                try uiViewController.startScanning()
            }catch{
                fatalError("Cannot Start Scanning: \(String(describing: error))")
            }
        }else{
            uiViewController.stopScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator : DataScannerViewControllerDelegate{
        
        var parent : BarcodeScannerViewController
        
        init(parent: BarcodeScannerViewController) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item{
            case .barcode(let barcode):
                self.parent.barcodeText = barcode.payloadStringValue ?? ""
                print("Barcode Text Scanned : \(parent.barcodeText)")
                break
            case .text(let text):
                self.parent.barcodeText = text.transcript
                break
            default:
                break
            }
        }
    }
    
}
