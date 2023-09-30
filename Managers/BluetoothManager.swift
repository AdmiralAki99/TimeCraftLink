//
//  BluetoothManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

//todo: Implement Bluetooth API for Watch

import Foundation
import CoreBluetooth

protocol BluetoothManagerDelegate{
    func peripheralsUpdate()
}

protocol BluetoothManagerProtocol{
    var peripherals : Dictionary<UUID,CBPeripheral> {get}
    var delegate : BluetoothManagerDelegate {get set}
    func beginAdvertising(with name: String)
    func startScanningForDevices()
}

class BluetoothManager{
    static let bluetooth_manager = BluetoothManager()
    
    var peripheral : CBPeripheral!
    var bluetoothName : String = ""
    var peripheralManager : CBPeripheralManager? = nil
    var centralManager : CBCentralManager? = nil
    
    
    private func updateState(){
        
    }
    
    private func sendMessage(){
        
    }
    
    private func handleMessage(){
        
    }
    
    private func createConnection(){
        
    }
    
    private func scanBluetoothDevices(){
        
    }
    
    private func startAdvertising(name : String){
        bluetoothName = name
        peripheralManager = CBPeripheralManager()
    }
    
    private func startScanning(){
        centralManager = CBCentralManager()
    }
}

//extension BluetoothManager : CBPeripheralManagerDelegate{
//    
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn{
//            if peripheral.isAdvertising == true{
//                peripheral.stopAdvertising()
//            }
//        }
//    }
//    
//    func isEqual(_ object: Any?) -> Bool {
//        <#code#>
//    }
//    
//    var hash: Int {
//        <#code#>
//    }
//    
//    var superclass: AnyClass? {
//        <#code#>
//    }
//    
//    func `self`() -> Self {
//        <#code#>
//    }
//    
//    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//    
//    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//    
//    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
//        <#code#>
//    }
//    
//    func isProxy() -> Bool {
//        <#code#>
//    }
//    
//    func isKind(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//    
//    func isMember(of aClass: AnyClass) -> Bool {
//        <#code#>
//    }
//    
//    func conforms(to aProtocol: Protocol) -> Bool {
//        <#code#>
//    }
//    
//    func responds(to aSelector: Selector!) -> Bool {
//        <#code#>
//    }
//    
//    var description: String {
//        <#code#>
//    }
//    
//    
//}
//
//extension BluetoothManager : CBCentralManagerDelegate{
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        switch central.state{
//            case .poweredOff:
//                print("Is Powered Off.")
//            case .poweredOn:
//                print("Is Powered On.")
//                startScanning()
//            case .unsupported:
//                print("Is Unsupported.")
//            case .unauthorized:
//                print("Is Unauthorized.")
//            case .unknown:
//                print("Unknown")
//            case .resetting:
//                print("Resetting")
//        default:
//            break
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        self.peripheral = peripheral
//        self.peripheral.delegate = self
//        
//        print("Peripheral Discovered: \(peripheral)")
//              print("Peripheral name: \(peripheral.name)")
//            print ("Advertisement Data : \(advertisementData)")
//        
//    }
//    
//    
//}
