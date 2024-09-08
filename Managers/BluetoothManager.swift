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

class BluetoothManager : NSObject,ObservableObject{
    
    let SERVICE_UUID = "4FAFC201-1FB5-459E-8FCC-C5C9C331914B"
    let musicCharacteristicUUID = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
    let DateTimeCharacteristicUUID = "B9DC3D38-4B22-11EE-BE56-0242AC120002"
    let TodoListStatusCharertisticUUID = "28bd3c28-635d-11ee-8c99-0242ac120002"
    let nutritionCharacteristicUUID = "14106c51-249e-4dc4-baa8-0966dda5c8eb"
    let musicStateCharacteristicUUID = "0x2BA3"
    var currentMusicPlaybackState : MusicPlaybackState = MusicPlaybackState.Paused
    
    static var bluetooth_manager = BluetoothManager()
    
    enum BLECharacteristics : String{
        case MusicState = "BEB5483E-36E1-4688-B7F5-EA07361B26A8"
        case todoListChar = "B9DC3D38-4B22-11EE-BE56-0242AC120002"
        case MusicMetadataChar = "37253d54-6107-11ee-8c99-0242ac120002"
        case TodoListStatusChar = "28bd3c28-635d-11ee-8c99-0242ac120002"
        case NutritionalInfoChar = "14106c51-249e-4dc4-baa8-0966dda5c8eb"
        case Initialization = "-"
    }
    
    enum MusicPlaybackState{
        case Playing
        case Paused
    }
    
    var smartWatchPeripheral : CBPeripheral?
    var bluetoothName : String = ""
    var peripheralManager : CBPeripheralManager? = nil
    var centralManager : CBCentralManager?
    var connectedPeripherals : CBPeripheral?
    var connectedCharacteristics : Dictionary<String,CBCharacteristic> = Dictionary<String,CBCharacteristic>()
    var isConnected = false
    
    @Published var scannedPeripherals : [CBPeripheral] = []
    
    var peripheralCharacteristics : [CBCharacteristic]!
    
//    let smartWatchCategory = CBUUID(string: "0x003")
    
    override init(){
        super.init()
        self.beginBluetooth()
    }
    
    
    private func updateState(){
        
    }
    
    func beginBluetooth(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func sendMessage(message: String, characteristic : BLECharacteristics){
        guard let encoded_message = message.encodeString() else {return}
        guard let selectedCharacteristic = connectedCharacteristics[characteristic.rawValue] else{
            return
        }
        if let smartWatchPeripheral = smartWatchPeripheral{
            smartWatchPeripheral.writeValue(encoded_message, for: selectedCharacteristic, type: .withResponse)
        }
        
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
        case .TodoListStatusChar:
            parseTodoTaskStatus(metadata: message)
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
        case .Ongoing:
            task.taskStatus = TaskStatus.Finished
        }
        
        ToDoListManager.todays_tasks[index] = task
        
        ToDoListManager.collectionView.reloadData()
        
    }
        
    func parseMusicState(metadata: String){
        
    }
    
    func parseTodoTaskStatus(metadata: String){
        
    }
    
    func connectToDevice(peripheral: CBPeripheral){
        self.centralManager?.connect(peripheral,options: nil)
    }
    
    private func determineCharacteristic(uuid : String) -> BLECharacteristics{
        var selectedCharacteristic = BLECharacteristics.Initialization
        if uuid == musicCharacteristicUUID{
            selectedCharacteristic = BLECharacteristics.MusicState
        }else if uuid == DateTimeCharacteristicUUID{
            selectedCharacteristic = BLECharacteristics.todoListChar
        }else if uuid == TodoListStatusCharertisticUUID{
            selectedCharacteristic = BLECharacteristics.TodoListStatusChar
        }
        return selectedCharacteristic
    }
    
    private func scanBluetoothDevices(timeout: TimeInterval,scheduledTask: @escaping ()-> Void) {
        let task = DispatchWorkItem(block: scheduledTask)
        
        DispatchQueue.global().async(execute: task)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout){
            if task.isCancelled == false{
                task.cancel()
            }
        }
    }
    
    private func startAdvertising(name : String){
        bluetoothName = name
        peripheralManager = CBPeripheralManager()
    }
    
    func startScanning(){
        self.centralManager?.scanForPeripherals(withServices: nil)
    }
    
    func getScannedPeripherals() -> [CBPeripheral]{
        return self.scannedPeripherals.removeDuplicates()
    }
    
    func disconnect(){
        
    }
    
    func stopScanning(){
        self.centralManager?.stopScan()
    }
    
    func clearScannedDevices(){
        self.scannedPeripherals = []
    }
}

extension BluetoothManager : CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn:
            print("Powered On")
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
        if peripheral.name != nil{
            self.scannedPeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to Device!")
        peripheral.discoverServices(nil)
        isConnected = true
        self.smartWatchPeripheral = peripheral
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
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed To Connect To : \(peripheral.name ?? "")")
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
    
    func newLineEachWord(){
        let words = self.components(separatedBy: " ")
    }
}

extension Sequence where Iterator.Element : Hashable{
    func removeDuplicates() -> [Iterator.Element]{
        var seen : Set<Iterator.Element> = []
        return filter{seen.insert($0).inserted}
    }
}


