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
    
    let SERVICE_UUID = "4FAFC201-1FB5-459E-8FCC-C5C9C331914B"
    let musicCharacteristicUUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
    let DateTimeCharacteristicUUID = "B9DC3D38-4B22-11EE-BE56-0242AC120002"
    let musicStateCharacteristicUUID = "0x2BA3"
    var currentMusicPlaybackState : MusicPlaybackState = MusicPlaybackState.Paused
    
    static var bluetooth_manager = BluetoothManager()
    
    enum BLECharacteristics : String{
        case MusicState = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
        case todoListChar = "B9DC3D38-4B22-11EE-BE56-0242AC120002"
        case MusicMetadataChar = "37253d54-6107-11ee-8c99-0242ac120002"
        case Initialization = "-"
    }
    
    enum MusicPlaybackState{
        case Playing
        case Paused
    }
    
    var smartWatchPeripheral : CBPeripheral!
    var bluetoothName : String = ""
    var peripheralManager : CBPeripheralManager? = nil
    var centralManager : CBCentralManager?
    var connectedPeripherals : Dictionary<UUID,CBPeripheral> = Dictionary<UUID,CBPeripheral>()
    var connectedCharacteristics : Dictionary<String,CBCharacteristic> = Dictionary<String,CBCharacteristic>()
    
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
    
    func sendMessage(message: String, characteristic : BLECharacteristics){
        guard let encoded_message = message.encodeString() else {return}
        guard let selectedCharacteristic = connectedCharacteristics[characteristic.rawValue] else{
            return
        }
        smartWatchPeripheral.writeValue(encoded_message, for: selectedCharacteristic, type: .withResponse)
    }
    
    private func handleMessage(message : String, characteristic: BLECharacteristics){
        switch characteristic{
        case .MusicState:
            parseMusicData(metadata: message)
        case .todoListChar:
            parseToDoList(metadata: message)
        case .MusicMetadataChar:
//            parseMusicData(metadata: message)
            break
        default:
            fatalError("Characteristic Not Set")
        }
    }
    
    func parseMusicData(metadata : String){
        if SpotifyAPIManager.device_id != ""{
            if metadata == "Pause"{
                print("Pausing Music")
                SpotifyAPIManager.api_manager.pauseSpotifyPlayback(with: SpotifyAPIManager.device_id) { result in
                    print(result)
                }
                currentMusicPlaybackState = .Paused
            }else if metadata == "Play"{
                print("Playing Music")
                currentMusicPlaybackState = .Playing
                SpotifyAPIManager.api_manager.playSpotifyPlayback(with: SpotifyAPIManager.device_id) { result in
                    print(result)
                }
            }else if metadata == "Rewind"{
                print("Rewinding Music")
                currentMusicPlaybackState = .Playing
                SpotifyAPIManager.api_manager.rewindSpotifyPlayback(with: SpotifyAPIManager.device_id) { result in
                    print(result)
                }
            }else if metadata == "Skip"{
                print("Skipping Music")
                currentMusicPlaybackState = .Playing
                SpotifyAPIManager.api_manager.forwardSpotifyPlayback(with: SpotifyAPIManager.device_id) { result in
                    print(result)
                }
            }
        }
    }
        
    func parseToDoList(metadata : String){
        guard let index = ToDoListManager.todays_tasks.firstIndex(where: {$0.name == metadata}) else{
            return
        }
        
        var task = ToDoListManager.todays_tasks[index]
        
        switch task.taskStatus{
        case .Finished:
            task.taskStatus = TaskStatus.Ongoing
            print("\(task.name) is Ongoing")
        case .Ongoing:
            task.taskStatus = TaskStatus.Finished
            print("\(task.name) is Finished")
        }
        
        ToDoListManager.todays_tasks[index] = task
        
        ToDoListManager.collectionView.reloadData()
        
    }
        
    func parseMusicState(metadata: String){
        
    }
    
    private func createConnection(){
        
    }
    
    private func determineCharacteristic(uuid : String) -> BLECharacteristics{
        var selectedCharacteristic = BLECharacteristics.Initialization
        if uuid == musicCharacteristicUUID{
            selectedCharacteristic = BLECharacteristics.MusicState
        }else if uuid == DateTimeCharacteristicUUID{
            selectedCharacteristic = BLECharacteristics.todoListChar
        }
        return selectedCharacteristic
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
            connectedCharacteristics[characteristic.uuid.uuidString] = characteristic
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {return}
        guard let message = String(data: data, encoding: .utf8) else{
            return
        }
        handleMessage(message: message, characteristic: determineCharacteristic(uuid: characteristic.uuid.uuidString))
    }
}

extension String {
    func encodeString()->Data?{
        let data = self.data(using: .utf8)
        return data
    }
    
    func decodeString()->String{
        let data = self.data(using: .utf8)
        let decodedString = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return decodedString
    }
}


