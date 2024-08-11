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

class NutritionScreenViewController : UIViewController{
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .dark
        let vc = UIHostingController(rootView: CameraScanner(navigationController:navigationController))
        let camView = vc.view!
        camView.translatesAutoresizingMaskIntoConstraints = false
//        camView.backgroundColor = .clear
        addChild(vc)
        view.addSubview(camView)
        
        NSLayoutConstraint.activate([camView.centerXAnchor.constraint(equalTo: view.centerXAnchor),camView.centerYAnchor.constraint(equalTo: view.centerYAnchor), camView.widthAnchor.constraint(equalToConstant: view.bounds.width),camView.heightAnchor.constraint(equalToConstant: view.bounds.height)])

    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct CameraScanner : View {
    @State private var barcodeResult : String = ""
    @State private var isScanning : Bool = true
    private var navigationController : UINavigationController?
    
    private var macroColors: [Color] = [Color.pink,Color.cyan,Color.green]
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack(alignment: .center){
                ScrollView{
                    HStack{
                        NutritionChartCard()
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    HStack{
                        NutrientMacroTracker(macroColors: self.macroColors)
                    }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    VStack{
                        List{
                            SwiftUI.Section(header: NutiritionSectionHeader(macroColors: self.macroColors)) {
                                FoodItemListCell(navigationController: navigationController!)
                                FoodItemListCell(navigationController: navigationController!)
                                FoodItemListCell(navigationController: navigationController!)
                                HStack(alignment:.center){
                                    Button("+ Add"){
                                        
                                    }.frame(maxWidth: .infinity,alignment:.leading).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)).tint(Color.pink)
                                    Spacer()
                                    Button(){
                                        
                                    }label: {
                                        Label(
                                            title: { },
                                            icon: { Image(systemName: "ellipsis").foregroundColor(Color.pink)}
                                        )
                                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                }
                            }
                        }.frame(height: 275).cornerRadius(10)
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    VStack{
                        List{
                            SwiftUI.Section(header: NutiritionSectionHeader(macroColors: self.macroColors)) {
                                FoodItemListCell(navigationController: navigationController!)
                                FoodItemListCell(navigationController: navigationController!)
                                FoodItemListCell(navigationController: navigationController!)
                                HStack(alignment:.center){
                                    Button("+ Add"){
                                        
                                    }.frame(maxWidth: .infinity,alignment:.leading).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)).tint(Color.pink)
                                    Spacer()
                                    Button(){
                                        
                                    }label: {
                                        Label(
                                            title: { },
                                            icon: { Image(systemName: "ellipsis").foregroundColor(Color.pink)}
                                        )
                                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                }
                            }
                        }.frame(height: 275).cornerRadius(10)
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    VStack{
                        List{
                            SwiftUI.Section(header: NutiritionSectionHeader(macroColors: self.macroColors)) {
                                FoodItemListCell(navigationController: navigationController!)
                                FoodItemListCell(navigationController: navigationController!)
                                FoodItemListCell(navigationController: navigationController!)
                                HStack(alignment:.center){
                                    Button("+ Add"){
                                        
                                    }.frame(maxWidth: .infinity,alignment:.leading).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)).tint(Color.pink)
                                    Spacer()
                                    Button(){
                                        
                                    }label: {
                                        Label(
                                            title: { },
                                            icon: { Image(systemName: "ellipsis").foregroundColor(Color.pink)}
                                        )
                                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                }
                            }
                        }.frame(height: 275).cornerRadius(10)
                    }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
                
            }
            HStack(alignment: .center){
                Button(){
                    
                }label: {
                    Label(
                        title: { Text("") },
                        icon: { Image(systemName: "plus").tint(Color.white) }
                    )
                }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 5))
                Button(){
                    navigationController?.pushViewController(BarcodeScannerViewController(barcodeResult: barcodeResult, isScanning: isScanning), animated: false)
                }label: {
                    Label(
                        title: { Text("") },
                        icon: { Image(systemName: "barcode.viewfinder").tint(Color.white)  }
                    )
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                Button(){
                    
                }label: {
                    Label(
                        title: { Text("") },
                        icon: { Image(systemName: "gearshape").tint(Color.white)  }
                    )
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                Button(){
                    
                }label: {
                    Label(
                        title: { Text("") },
                        icon: { Image(systemName: "pencil").tint(Color.white) }
                    )
                }.padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }.background(Color.pink.opacity(0.5)).cornerRadius(15.0).frame(height: 20)
        }
    }
}

class BarcodeScannerViewController: UIViewController{
    
    private var barcodeResult : String = ""
    private var isScanning : Bool = true
    private var dataScanner : DataScannerViewController?
    
    init(barcodeResult: String, isScanning: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.barcodeResult = barcodeResult
        self.isScanning = isScanning
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.dataScanner = DataScannerViewController(recognizedDataTypes: [.barcode()], qualityLevel: .fast, recognizesMultipleItems: false, isHighFrameRateTrackingEnabled: false, isPinchToZoomEnabled: true, isGuidanceEnabled: false, isHighlightingEnabled: true)
        dataScanner?.delegate = self
        guard let scannerView = dataScanner?.view! else{
            fatalError()
        }
        scannerView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let dataScanner = dataScanner else{
            fatalError()
        }
        addChild(dataScanner)
        view.addSubview(scannerView)
        
        NSLayoutConstraint.activate([scannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),scannerView.centerYAnchor.constraint(equalTo: view.centerYAnchor), scannerView.widthAnchor.constraint(equalToConstant: view.bounds.width),scannerView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
        startScanning()
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func startScanning(){
        do{
            try dataScanner?.startScanning()
        }catch{
            fatalError("Cannot Start Scanning: \(String(describing: error))")
        }
    }
    
    func stopScanning(){
        dataScanner?.stopScanning()
    }
}

extension BarcodeScannerViewController : DataScannerViewControllerDelegate{
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item{
        case .barcode(let barcode):
            self.barcodeResult = barcode.payloadStringValue ?? ""
            print("Barcode Text Scanned : \(self.barcodeResult)")
            _Concurrency.Task{
                NutritionManager.nutritionManager.searchBarcodeID(with: String(String(self.barcodeResult).dropFirst())) { res in
                    switch res{
                    case .success(let food):
                        print(food)
                        DispatchQueue.main.async{
                            let vc = FoodItemScannedViewController()
                            vc.modalPresentationStyle = .formSheet
                            vc.preferredContentSize = .init(width: UIScreen.screenWidth/3, height: UIScreen.screenHeight/3)
                            self.present(vc,animated:true)
                        }
                        break
                    case .failure(let error):
                        print(error)
                        break
                    }
                }
            }
            break
        case .text(let text):
            self.barcodeResult = text.transcript
            break
        default:
            break
        }
    }
}
