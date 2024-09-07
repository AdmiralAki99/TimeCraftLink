//
//  BluetoothDiscoveryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-02.
//

import UIKit
import SwiftUI
import CoreBluetooth

class BluetoothDiscoveryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.overrideUserInterfaceStyle = .dark
        
        let bluetoothView = BluetoothDiscoveryView()
        
        let hostingController = UIHostingController(rootView: bluetoothView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        hostingController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}

struct BluetoothDiscoveryView : View {
    
    @State private var firstCircleTrigger : Bool = false
    @State private var secondCircleTrigger : Bool = false
    @State private var bluetoothTriggered : Bool = false
    @State var peripherals : [CBPeripheral] = []
    
    private var numberOfDevicesInOneRing : Int = 10
    
    @StateObject private var bluetoothManager = BluetoothManager.bluetooth_manager
    
    
    private let baseRadius : Int = 100
    private let radiusIncrement: CGFloat = CGFloat(100 / 1.75)
    
    @State private var buttonAngles : [(Double,Double)] = []
    
    func createButtons(radius : CGFloat,numberOfButtonsInLevel : Int){
        let angleDiff = Double.pi * 2.0 / Double(numberOfButtonsInLevel)
        let centerX = (UIScreen.main.bounds.width / 2)
        let centerY = (UIScreen.main.bounds.height / 2) - 55 // Adjust this for the desired spacing around the center
        
        for placementIndex in 0..<numberOfButtonsInLevel{
            let angle = Double(placementIndex) * angleDiff
            let xOffset = radius * cos(angle)
            let yOffset = radius * sin(angle)
            self.buttonAngles.append((Double(centerX) + xOffset, Double(centerY) + yOffset))
        }
    }
    
    func createRings(numberOfButtons : Int){
        let levels = ceil(Double(numberOfButtons) / Double(numberOfDevicesInOneRing))
        var remainingButtons = numberOfButtons
        
        for level in 1...Int(levels) {
            let radius: CGFloat
            if level == 1 {
                radius = CGFloat(baseRadius)
            } else {
                radius = CGFloat(baseRadius) + CGFloat(level - 1) * radiusIncrement
            }
            let buttonsInLevel: Int
            
            if remainingButtons >= numberOfDevicesInOneRing {
                buttonsInLevel = numberOfDevicesInOneRing
            } else {
                buttonsInLevel = remainingButtons
            }
            
            remainingButtons -= buttonsInLevel
            
            //             Create the buttons with the calculated number and radius
            createButtons(radius: radius, numberOfButtonsInLevel: buttonsInLevel)
        }
        
    }
    
    
    var body: some View {
        Button {
            bluetoothTriggered.toggle()
            bluetoothManager.startScanning()
        } label: {
            ZStack{
                if bluetoothTriggered{
                    Circle().stroke(lineWidth: 40).frame(width:100,height:100).foregroundColor(.pink).foregroundColor(.pink).scaleEffect(firstCircleTrigger ? 2: 1).opacity(firstCircleTrigger ? 0.7 : 0.0).animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(0.5)).onAppear(){
                        self.firstCircleTrigger.toggle()
                    }
                    Circle().stroke(lineWidth: 40).frame(width:80,height:80).foregroundColor(.pink).foregroundColor(.pink).scaleEffect(secondCircleTrigger ? 2: 1).opacity(secondCircleTrigger ? 0.6 : 0.0).animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(0.7)).onAppear(){
                        self.secondCircleTrigger.toggle()
                    }
                    if bluetoothManager.getScannedPeripherals().count == 0{
                        
                    }else{
                        ForEach(0...bluetoothManager.getScannedPeripherals().count-1,id:\.self){ num in
                            BluetoothDeviceButton(peripheral: (bluetoothManager.getDeviceFromScannedPeripherals(index: num))).position(x:self.buttonAngles[num].0,y:self.buttonAngles[num].1).animation(Animation.easeIn(duration: 1).delay(1 * Double((num+1))))
                        }
                    }
                }
                Circle().frame(width:100,height:100).foregroundColor(.pink).shadow(radius: 25)
                Image(systemName: "iphone.gen3.radiowaves.left.and.right").font(.system(size: 25)).foregroundColor(.white).shadow(radius: 25)
            }.onAppear(){
                createRings(numberOfButtons: 20)
            }.onDisappear(){
                bluetoothManager.stopScanning()
                bluetoothManager.clearScannedDevices()
            }
        }
    }
    
}

struct BluetoothDeviceButton : View {
    
    @State var peripheral : CBPeripheral
    
    init(peripheral: CBPeripheral){
        self.peripheral = peripheral
//        print(peripheral.name ?? "")
    }
    
    var body: some View {
        Button {
            
        } label: {
            VStack{
                Image(systemName: "iphone.circle").font(.system(size: 25)).foregroundColor(.white).shadow(radius: 25)
//                Text(String(self.peripheral.name ?? "")).font(.caption2).truncationMode(.tail).lineLimit(1)
            }
        }.clipShape(Circle())
        
    }
}
    
