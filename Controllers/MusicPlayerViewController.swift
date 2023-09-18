//
//  MusicPlayerViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit
import SDWebImage

class MusicPlayerViewController: UIViewController {
    
    weak var dataSource : MusicPlaybackDataSource?
    
    let playbackController = PlaybackControllerView()
    
    private let albumArt : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        playbackController.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goToPreviousScreen))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePlayback))
        
        configureMusicPlaybackUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(albumArt)
        view.addSubview(playbackController)
        
        albumArt.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/2)
        
        playbackController.frame = CGRect(x: 0, y: albumArt.bottom + 50, width: view.width, height: view.height/3)
        
        
    }
    
    private func configureMusicPlaybackUI(){
        albumArt.sd_setImage(with: dataSource?.songArtwork,completed: nil)
        playbackController.configurePlaybackUI(with: PlaybackViewModel(songName: dataSource?.songName, artistName: dataSource?.artistName))
    }
    
    @objc func goToPreviousScreen(){
        dismiss(animated: true)
    }
    
    @objc func sharePlayback(){
        
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

extension MusicPlayerViewController : PlaybackControllerViewDelegate{
    func forwardPlayback(_ playbackControl: PlaybackControllerView) {
        
    }
    
    func rewindPlayback(_ playbackControl: PlaybackControllerView) {
        
    }
    
    func playPausepPlayback(_ playbackControl: PlaybackControllerView) {
        
    }
    
    
}
