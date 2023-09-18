//
//  MusicPlaybackViewer.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-27.
//

import Foundation
import UIKit

protocol MusicPlaybackDataSource : AnyObject{
    var songName : String? {get}
    var artistName: String? {get}
    var songArtwork : URL? {get}
}

final class MusicPlaybackViewer{
    
    static let shared = MusicPlaybackViewer()
    
    private var song : Track?
    
    private var songFromAlbum : AlbumDetailsTrack?
    
    private var songQueue = [Track]()
    
    private var songQueueFromAlbum = [AlbumDetailsTrack]()
    
    var currentSong : Track? {
        if let track = song, songQueue.isEmpty{
            return track
        }else if !songQueue.isEmpty {
            return songQueue.first
        }
        
        return nil
    }
    
    
    
    func startPlayback(from viewController : UIViewController, track: Track){
        self.song = track
        self.songQueue = []
        let playerViewController = MusicPlayerViewController()
        playerViewController.dataSource = self
        let playerNavigationController = UINavigationController(rootViewController:playerViewController)
        playerNavigationController.modalPresentationStyle = .fullScreen
        playerViewController.title = track.name
        viewController.present(playerNavigationController, animated: true,completion: nil)
    }
    
    func startPlayback(from viewController : UIViewController, track: AlbumDetailsTrack){
        let playerViewController = MusicPlayerViewController()
//        playerViewController.modalPresentationStyle = .fullScreen
        playerViewController.title = track.name
        viewController.present(UINavigationController(rootViewController:playerViewController), animated: true,completion: nil)
    }
    
    func startPlayback(from viewController : UIViewController, tracks : [Track]){
        songQueue = tracks
        song = nil
    }
    
    func startPlayback(from viewController : UIViewController, tracks : [AlbumDetailsTrack]){
        
    }
    
    func pausePlayback(){
        
    }
}

extension MusicPlaybackViewer : MusicPlaybackDataSource{
    var songName: String? {
        return currentSong?.name
    }
    
    var artistName: String? {
        return currentSong?.artists.first?.name
    }
    
    var songArtwork: URL? {
        return URL(string: currentSong?.album?.images.first?.url ?? "" )
    }
    
    
}
