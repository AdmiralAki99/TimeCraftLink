//
//  BluetoothPlayerViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-29.
//

import UIKit

enum PlaybackPlayerState{
    case playing
    case paused
}

enum PlaybackShuffleState{
    case shuffled
    case notShuffled
}

enum PlaybackRepeatState{
    case context
    case track
    case off
}

class PlaybackViewController: UIViewController {
    
    static var playbackStatus : PlaybackPlayerState = .paused
    static var prevPlaybackStatus : PlaybackPlayerState = .paused
    static var playbackShuffleState : PlaybackShuffleState = .notShuffled
    static var playbackRepeatState : PlaybackRepeatState = .off
    
    let gradientLayer = CAGradientLayer()
    
    static var currentTrack : CurrentPlayingTrack? = {
        return nil
    }()
    
    static var tempTrack : CurrentPlayingTrack? = {
        return nil
    }()
    
    var playback_device_id = ""
    
    var old_track = ""
    
    let playbackController = PlaybackControllerView()
    
    private let albumArt : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        return imageView
    }()
    
    let playbackSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.setThumbImage(UIImage(), for: .normal)
        return slider
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22,weight: .bold)
        label.numberOfLines = 1
        
        return label
    }()
    
    let idLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22,weight: .bold)
        label.numberOfLines = 1
        
        return label
    }()
    
    let artistName : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.text = ""
        return label
    }()
    
    let rewindButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.end.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular )), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let forwardButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.end.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular )), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    let shuffleButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "shuffle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20,weight: .regular)), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let repeatButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "repeat",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20,weight: .regular)), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        albumArt.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/2)
        
        nameLabel.text = "Song Name"
        
        artistName.text = "Artist Name"
        
        view.backgroundColor = .black
        
        nameLabel.frame = CGRect(x:  5, y: albumArt.bottom, width: view.width, height: 40)
        artistName.frame = CGRect(x: 5, y: nameLabel.bottom - 15 , width: view.width, height: 40)
        playbackSlider.frame = CGRect(x: 10, y: artistName.bottom + 20, width: view.width - 20, height: 40)
        
        playButton.frame = CGRect(x: (view.width - 60)/2, y: playbackSlider.bottom + 30, width: 60, height: 60)
        
        rewindButton.frame = CGRect(x: playButton.left - 80, y: playbackSlider.bottom + 30, width: 60, height: 60)
        
        forwardButton.frame = CGRect(x: playButton.right + 20, y: playbackSlider.bottom + 30, width: 60, height: 60)
        
        shuffleButton.frame = CGRect(x: 10, y: playbackSlider.bottom + 30, width: 60, height: 60)
        
        repeatButton.frame = CGRect(x: forwardButton.right + 20, y: playbackSlider.bottom + 30, width: 60, height: 60)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Bluetooth Player"
        
        view.addSubview(albumArt)
        view.addSubview(nameLabel)
        view.addSubview(artistName)
        view.addSubview(playbackSlider)
        view.addSubview(rewindButton)
        view.addSubview(playButton)
        view.addSubview(forwardButton)
        view.addSubview(shuffleButton)
        view.addSubview(repeatButton)
        
//        gradientLayer.frame = view.frame
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        self.gradientLayer.colors = [UIColor.black.cgColor, UIColor.systemGreen.cgColor]
//        self.gradientLayer.locations = [0.0, 1.0]
        
        view.clipsToBounds = true
        
        view.backgroundColor = .black
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonPressed))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button
        
        let share_button = UIBarButtonItem(title:"Share",image:UIImage(systemName: "ellipsis"),target:self,action: nil)
        
        share_button.tintColor = .white
        
        navigationItem.rightBarButtonItem = share_button
        
        playButton.addTarget(self, action: #selector(playPausePlayback),for: .touchUpInside)
        
        forwardButton.addTarget(self, action: #selector(didTapForwardButton),for: .touchUpInside)
        
        rewindButton.addTarget(self, action: #selector(didTapRewindButton),for: .touchUpInside)
        
        shuffleButton.addTarget(self, action: #selector(didTapShuffleButton),for: .touchUpInside)
        
        
        repeatButton.addTarget(self, action: #selector(didTapRepeatButton),for: .touchUpInside)
        
//        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { timer in
//
//        }
        
//        updateCurrentTrack()
        
        SpotifyAPIManager.api_manager.getPlaybackState { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    if(model.is_playing == true){
                        SpotifyAPIManager.api_manager.getAvailableDevices { result in
                            switch result{
                            case .success(let device):
                                guard let id = device.devices.first?.id else{
                                    return
                                }
                                self.playback_device_id = id
                                SpotifyAPIManager.device_id = id
                            case .failure(let error):
                                break
                            }
                        }
                        self.playPausePlayback()
                    }
                case .failure(let error):
                    if self.playback_device_id == ""{
                        self.pollForID()
                    }
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true){timer in
//            print("Polling for playback update")
            self.updatePlayback()
        }
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
//            print("Polling for ID : \(self.playback_device_id)")
            SpotifyAPIManager.api_manager.getAvailableDevices { result in
                switch result{
                case .success(let device):
                    guard let id = device.devices.first?.id else{
                        return
                    }
                    self.playback_device_id = id
                    SpotifyAPIManager.device_id = id
//                    print(self.playback_device_id)
                case .failure(let error):
                    break
                }
            }
            
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            DispatchQueue.main.async {
                SpotifyAPIManager.api_manager.getCurrentlyPlayingTrack { result in
                    switch result{
                    case .success(let track):
                        self.updatePlayerUI(current_track: track)
                    case .failure(let error):
                        break
                    }
                }
            }
        }
        
        
        
      
        
        
//
        
//        SpotifyAPIManager.api_manager.seekToPositionSpotifyPlayback(with: 35000,device_id: playback_device_id) { result in
//            switch result{
//            case .success:
//                break
//            case .failure:
//                break
//            }
//        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }

    func obtainActiveDevice(with device: SpotifyActiveDevice) -> Void{
        // First Check if a device is active
        if !device.devices.isEmpty{
            if device.devices.first?.id == nil{
                
            }else{
                // Device Succssfully obtained
                // Now checking if stored device ID is empty
                if playback_device_id == ""{
                    playback_device_id = device.devices.first!.id
                    print(playback_device_id)
                }else{
                    // Device ID exists, now need to check if primary device is changed and update accordingly
                    if playback_device_id == device.devices.first!.id{
                        
                    }else{
                        // Primary Device has been changed
                        playback_device_id = device.devices.first!.id
                        print(playback_device_id)
                    }
                }
            }
        }
       
    }
}

extension PlaybackViewController{
    
    func didTapPausePlabackButton(){
        self.playButton.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
        SpotifyAPIManager.api_manager.playSpotifyPlayback(with: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackStatus = .playing
    }
    
    func didTapPlayButton(){
        self.playButton.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
        SpotifyAPIManager.api_manager.pauseSpotifyPlayback(with: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackStatus = .paused
    }
    
    @objc func playPausePlayback(){
        if PlaybackViewController.playbackStatus == .paused{
            didTapPausePlabackButton()
        }else{
            didTapPlayButton()
        }
    }
    
    func updateCurrentSeekTime(){
        print("Getting Seek Time")
        let group = DispatchGroup()
        
        group.enter()
        
        SpotifyAPIManager.api_manager.getCurrentlyPlayingTrack { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                break
            case.failure(let error):
                break
            }
        }
        
        group.notify(queue: .main){
            print("Button Pressed")
        }
    }
    
    @objc func didTapForwardButton(){
        SpotifyAPIManager.api_manager.forwardSpotifyPlayback(with: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        
    }
    
    @objc  func didTapRewindButton(){
        SpotifyAPIManager.api_manager.rewindSpotifyPlayback(with: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
    }
    
    @objc func didTapShuffleButton(){
        switch PlaybackViewController.playbackShuffleState{
        case .notShuffled:
            shufflePlayback()
        case .shuffled:
            stopShufflePlayback()
        }
    }
    
    func shufflePlayback(){
        SpotifyAPIManager.api_manager.togglePlaybackShuffle(with: "true", spotifyDeviceID: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackShuffleState = .shuffled
        shuffleButton.tintColor = .systemGreen
    }
    
    func stopShufflePlayback(){
        SpotifyAPIManager.api_manager.togglePlaybackShuffle(with: "false", spotifyDeviceID: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackShuffleState = .notShuffled
        shuffleButton.tintColor = .gray
    }
    
    func toggleContextPlaybackRepeat(){
        SpotifyAPIManager.api_manager.toggleRepeatPlayback(with: "context", spotifyDeviceID: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackRepeatState = .context
        repeatButton.tintColor = .green
    }
    
    func toggleTrackPlaybackRepeat(){
        SpotifyAPIManager.api_manager.toggleRepeatPlayback(with: "track", spotifyDeviceID: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackRepeatState = .track
        repeatButton.tintColor = .blue
    }
    
    func stopPlaybackRepeat(){
        SpotifyAPIManager.api_manager.toggleRepeatPlayback(with: "off", spotifyDeviceID: playback_device_id) { result in
            switch result{
            case .success:
                break
            case .failure:
                break
            }
        }
        PlaybackViewController.playbackRepeatState = .off
        repeatButton.tintColor = .gray
    }
    
    @objc func didTapRepeatButton(){
        switch PlaybackViewController.playbackRepeatState{
        case .off:
            toggleContextPlaybackRepeat()
        case .context:
            toggleTrackPlaybackRepeat()
        case .track:
            stopPlaybackRepeat()
        }
    }
    
    func pollForID(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            print("Polling for ID : \(self.playback_device_id)")
            SpotifyAPIManager.api_manager.getAvailableDevices { result in
                switch result{
                case .success(let device):
                    guard let id = device.devices.first?.id else{
                        return
                    }
                    self.playback_device_id = id
//                    print(self.playback_device_id)
                case .failure(let error):
                    break
                }
            }
            
            if self.playback_device_id != ""{
//                print("Obtained iD: \(self.playback_device_id)")
                timer.invalidate()
                self.pollForPlayback()
                print("Timer Stopped")
            }
        }
    }
    
    func pollForPlayback(){
        SpotifyAPIManager.api_manager.getPlaybackState { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    if(model.is_playing == true){
                        SpotifyAPIManager.api_manager.getAvailableDevices { result in
                            switch result{
                            case .success(let device):
                                guard let id = device.devices.first?.id else{
                                    return
                                }
                                self.playback_device_id = id
                            case .failure(let error):
                                break
                            }
                        }
                        if self.playback_device_id != "" && PlaybackViewController.prevPlaybackStatus != PlaybackViewController.playbackStatus{
                            PlaybackViewController.prevPlaybackStatus = PlaybackViewController.playbackStatus
                            self.updatePlayButtonIcon()
                        }
                    }
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func updatePlayback(){
        SpotifyAPIManager.api_manager.getPlaybackState { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    if(model.is_playing == true){
                        PlaybackViewController.playbackStatus = .playing
                    }else{
                        PlaybackViewController.playbackStatus = .paused
                    }
                        if self.playback_device_id != "" && PlaybackViewController.prevPlaybackStatus != PlaybackViewController.playbackStatus{
                            PlaybackViewController.prevPlaybackStatus = PlaybackViewController.playbackStatus
                            print("Playback has changed")
                            self.updatePlayButtonIcon()
                        }
                case .failure(let error):
                    break
                }
            }
        }
    }
    
    func updatePlayButtonIcon(){
        if PlaybackViewController.playbackStatus == .playing{
            self.playButton.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
            
        }else{
            self.playButton.setImage(UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
        }
    }
    
    func updatePlayerUI(current_track : CurrentPlayingTrack){
        DispatchQueue.main.async {
            self.nameLabel.text = current_track.item?.name
            self.artistName.text = current_track.item?.artists.first?.name
            self.albumArt.sd_setImage(with: URL(string: current_track.item?.album?.images.first?.url ?? ""))
            
            guard let trackName = current_track.item?.name else{
                return
            }
            
            guard let trackArtist = current_track.item?.artists.first?.name else{
                return
            }
            
            if trackName != self.old_track{
                BluetoothManager.bluetooth_manager.sendMessage(message: "\(trackName);\(trackArtist)", characteristic: .MusicState)
                self.old_track = trackName
            }
            
            
            
            guard let albumColor = self.albumArt.image?.averageColor else{
                return
            }
            
//            let avgcolor = (albumColor as! UIColor)
            
//            self.view.backgroundColor = avgcolor

            
        }
       
    }
    
    
    
    
}

//Optional(UIExtendedSRGBColorSpace 0.34902 0.113725 0.141176 1)
