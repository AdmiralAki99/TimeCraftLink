//
//  SplashViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit

class LoginScreen: UIViewController {
    
    private var signIn: UIButton = {
        let signIn = UIButton()
        signIn.setTitle("Sign In", for: .normal)
        signIn.backgroundColor = .black
        signIn.setTitleColor(.white, for: UIControl.State.normal)
        return signIn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Welcome"
        
        view.backgroundColor = .systemGreen
        
        view.addSubview(signIn)
        
        signIn.addTarget(self, action: #selector(UserSignIn), for: .touchUpInside)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signIn.frame = CGRect(x: 20, y: view.height - 50 - view.safeAreaInsets.bottom , width: view.width - 40, height: 50)
    }
    
    @objc func UserSignIn(){
        let viewController = LoginViewController()
        viewController.requestComplete = { [weak self] result in
            DispatchQueue.main.async {
                self?.signInRequest(success: result)
            }
        }
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func signInRequest(success:Bool){
        guard success else{
            let alert_message = UIAlertController(title: "SIGN IN ERROR", message: "Error in Sign In function", preferredStyle: .alert)
            alert_message.addAction(UIAlertAction(title: "Close", style: .cancel,handler: nil))
            present(alert_message,animated: true)
            return
        }
        
        let tabBarVC = TabBarViewController()
        
        tabBarVC.modalPresentationStyle = .fullScreen
        
        present(tabBarVC,animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
