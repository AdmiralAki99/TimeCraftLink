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

class NutrionManager : NSObject{
    
    static let nutritionManager = NutrionManager()
    
    struct API{
        static let apiURL = "https://api.nal.usda.gov/fdc/v1"
    }
    
    enum APIResponseError : Error{
        case FailedToGetData
        case AuthenticationError
        case NoFoodHits
    }
    
    enum HTTPResp : String{
        case GET
        case POST
        case PUT
    }
    
    override init(){
        
    }
    
    func searchBarcodeID(with barcodeNumber: String,completion: @escaping (Result<Food,Error>)->Void){
        guard let url = URL(string: "\(API.apiURL)/foods/search?api_key=Fb4ewYXWfglKqzNXndfKc9G16rAyqbi71h0VcSiI&query=\(barcodeNumber)") else{
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { data, resp, err in
            guard let data = data , err == nil else{
                completion(.failure(APIResponseError.FailedToGetData))
                return
            }
            do{
                var data = try JSONDecoder().decode(FoodRequest.self, from: data)
                
                if data.totalHits == 0{
                    completion(.failure(APIResponseError.NoFoodHits))
                }
                
                completion(.success(data.foods[0]))
            }catch{
                print("Barcode Search Info: \(String(describing: err?.localizedDescription))")
                completion(.failure(error))
            }
        }
        
        apiTask.resume()
        
    }
    
    func searchFoodList(with foodName: String){
        
    }
    
}

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
                _Concurrency.Task{
                    NutritionManager.nutritionManager.searchBarcodeID(with: String(String(parent.barcodeText).dropFirst())) { res in
                        switch res{
                        case .success(let food):
                            print(food)
                            break
                        case .failure(let error):
                            print(error)
                            break
                        }
                    }
                }
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
