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
    
    let SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
    let  CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
    let TIME_CHARACTERISTIC_UUID = "b9dc3d38-4b22-11ee-be56-0242ac120002"
    
    static var bluetooth_manager = BluetoothManager()
    
    var smartWatchPeripheral : CBPeripheral!
    var bluetoothName : String = ""
    var peripheralManager : CBPeripheralManager? = nil
    var centralManager : CBCentralManager?
    var connectedPeripherals : Dictionary<UUID,CBPeripheral> = Dictionary<UUID,CBPeripheral>()
    
    var peripheralCharacteristics : [CBCharacteristic]!
    
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
        smartWatchPeripheral.setValue("Gravity", forKey: <#T##String#>)
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
        if peripheral.name == "Lazarus"{
            smartWatchPeripheral = peripheral
            smartWatchPeripheral.delegate = self
            centralManager?.connect(smartWatchPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to Device!")
        peripheral.discoverServices(nil)
    }
    
}

extension BluetoothManager : CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let peripheralServices = peripheral.services else{
            return
        }
        
        for services in peripheralServices{
            print(services)
            peripheral.discoverCharacteristics(nil, for: services)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else{
            return
        }
        
        peripheralCharacteristics = characteristics
        
        for characteristic in characteristics {
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {return}
        print(String(data: data, encoding: .utf8) ?? "NIL")
    }
}


