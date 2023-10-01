//
//  BluetoothDiscoveryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-02.
//

import UIKit

class BluetoothDiscoveryViewController: UIViewController {
    
    var rippleLayer = [CAShapeLayer]()
    
    var rippleLayerAnimated = false
    
    var deviceButton : [UIButton] = []
    
    let deviceButtonCoordinates : [(CGFloat,CGFloat)] = [(5,(UIScreen.main.bounds.height - 10)/2.0),(UIScreen.main.bounds.width/2 - 15,UIScreen.main.bounds.height/2 - 180),(UIScreen.main.bounds.width - 50,UIScreen.main.bounds.height/2),(UIScreen.main.bounds.width/2,UIScreen.main.bounds.height/2 + 135)]
    
    
    
    
    let bluetoothButton : UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .red
        button.setImage(UIImage(systemName: "antenna.radiowaves.left.and.right",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular )), for: .normal)
        button.tintColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(returnToPreviousScreen))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button
        
        createDeviceButtons()
        
        bluetoothButton.addTarget(self, action: #selector(createRipple), for: .touchUpInside)
        title = "Discovery Screen"
        
        view.backgroundColor = .black
        
        BluetoothManager.bluetooth_manager.beginBluetooth()
        
//        createRipple()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(bluetoothButton)
        displayDeviceButtons()
        bluetoothButton.frame = CGRect(x: view.width/2 - 40, y: view.height/2 - 40, width: 80, height: 80)
        bluetoothButton.layer.cornerRadius = 40
//        bluetoothButton.layer.masksToBounds = true
        
     

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func returnToPreviousScreen(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func createRipple(){
        if rippleLayerAnimated == false{
            for index in 0...2{
                let bezierPath = UIBezierPath(arcCenter: .zero, radius: (UIScreen.main.bounds.width - 20)/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                let rippleLayer = CAShapeLayer()
                rippleLayer.path = bezierPath.cgPath
                rippleLayer.lineWidth = 2.0
                rippleLayer.fillColor = UIColor.clear.cgColor
                rippleLayer.strokeColor = UIColor.white.cgColor
                rippleLayer.lineCap = CAShapeLayerLineCap.round
                rippleLayer.position = CGPoint(x: bluetoothButton.frame.size.width-40, y: bluetoothButton.frame.size.height-40)
                bluetoothButton.layer.addSublayer(rippleLayer)
                self.rippleLayer.append(rippleLayer)
                
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animateRipple(with: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                    self.animateRipple(with: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                        self.animateRipple(with: 2)
                    }
                }
            }
            rippleLayerAnimated = true
        }
     
    }
    
    func createDeviceButtons(){
        for coordinates in deviceButtonCoordinates{
            let button = UIButton()
            button.backgroundColor = .black
            button.layer.borderColor = UIColor.white.cgColor
            button.setImage(UIImage(systemName: "iphone.gen2"), for: .normal)
            button.tintColor = .white
            button.layer.borderWidth = 2
            button.layer.cornerRadius = 20
            deviceButton.append(button)
        }
    }
    
    func displayDeviceButtons(){
        for index in 0..<deviceButtonCoordinates.count{
            view.addSubview(deviceButton[index])
            let xCoord = deviceButtonCoordinates[index].0
            let yCoord = deviceButtonCoordinates[index].1
            deviceButton[index].frame = CGRect(x: xCoord, y: yCoord, width: 40, height: 40)
        }
    }
    
    func animateRipple(with index: Int){
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 3.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount =  .greatestFiniteMagnitude
//        scaleAnimation.autoreverses = true
        rippleLayer[index].add(scaleAnimation, forKey: "scale")
        
        let opacity = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacity.duration = 2.0
        opacity.fromValue = 0.9
        opacity.toValue = 0.0
        opacity.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacity.repeatCount =  .greatestFiniteMagnitude
        
        rippleLayer[index].add(scaleAnimation, forKey: "opacity")
    }

}
