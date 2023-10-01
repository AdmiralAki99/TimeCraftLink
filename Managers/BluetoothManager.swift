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

class BluetoothManager : NSObject{
    
    static var bluetooth_manager = BluetoothManager()
    
    var smartWatchPeripheral : CBPeripheral!
    var bluetoothName : String = ""
    var peripheralManager : CBPeripheralManager? = nil
    var centralManager : CBCentralManager?
    
//    let smartWatchCategory = CBUUID(string: "0x003")
    
    enum APIServices{
        
    }
    
    
    private func updateState(){
        
    }
    
    func beginBluetooth(){
        print("Starting Bluetooth")
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    private func disconnect(){
        
    }
}

extension BluetoothManager : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            startScanning()
            print("Starting Scan")
        case .poweredOff:
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unknown:
            break
        case .unsupported:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
    }
    
    
}


