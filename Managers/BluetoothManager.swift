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
    
    static var peripherals : Dictionary<UUID,CBPeripheral> = Dictionary<UUID,CBPeripheral>()
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
//        <#code#>
//    }
//    
//    
//}
