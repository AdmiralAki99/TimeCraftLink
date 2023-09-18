//
//  PlaybackController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-27.
//

import Foundation
import UIKit

protocol PlaybackControllerViewDelegate : AnyObject{
    func forwardPlayback(_ playbackControl : PlaybackControllerView)
    func rewindPlayback(_ playbackControl: PlaybackControllerView)
    func playPausepPlayback(_ playbackControl : PlaybackControllerView)
}

struct PlaybackViewModel{
    let songName : String?
    let artistName : String?
}

class PlaybackControllerView : UIView{
    
    weak var delegate : PlaybackControllerViewDelegate?
    
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
    
    let artistName : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        
        return label
    }()
    
    let rewindButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular )), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let forwardButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular )), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular)), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(artistName)
        addSubview(playbackSlider)
        addSubview(rewindButton)
        addSubview(playButton)
        addSubview(forwardButton)
        
        clipsToBounds = true
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        rewindButton.addTarget(self, action: #selector(rewindButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(x:  0, y: 0, width: width, height: 40)
        artistName.frame = CGRect(x: 0, y: nameLabel.bottom - 15 , width: width, height: 40)
        playbackSlider.frame = CGRect(x: 0, y: artistName.bottom, width: width - 20, height: 40)
        
        playButton.frame = CGRect(x: (width - 60)/2, y: playbackSlider.bottom + 30, width: 60, height: 60)
        
        rewindButton.frame = CGRect(x: playButton.left - 60, y: playbackSlider.bottom + 30, width: 60, height: 60)
        
        forwardButton.frame = CGRect(x: playButton.right, y: playbackSlider.bottom + 30, width: 60, height: 60)
    }
    
    @objc func playButtonTapped(){
        delegate?.playPausepPlayback(self )
    }
    
    @objc func rewindButtonTapped(){
        delegate?.rewindPlayback(self)
    }
    
    @objc func forwardButtonTapped(){
        delegate?.forwardPlayback(self )
    }
    
    func configurePlaybackUI(with model : PlaybackViewModel){
        nameLabel.text = model.songName
        artistName.text = model.artistName
        
        
    }
}
