//
//  MusicPlayerViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit
import SDWebImage
import SwiftUI

//class MusicPlayerViewController: UIViewController {
//    
//    weak var dataSource : MusicPlaybackDataSource?
//    
//    let playbackController = PlaybackControllerView()
//    
//    private let albumArt : UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.image = UIImage(systemName: "photo")
//        
//        return imageView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .systemBackground
//        
//        playbackController.delegate = self
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(goToPreviousScreen))
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePlayback))
//        
//        configureMusicPlaybackUI()
//
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        view.addSubview(albumArt)
//        view.addSubview(playbackController)
//        
//        albumArt.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/2)
//        
//        playbackController.frame = CGRect(x: 0, y: albumArt.bottom + 50, width: view.width, height: view.height/3)
//        
//        
//    }
//    
//    private func configureMusicPlaybackUI(){
//        albumArt.sd_setImage(with: dataSource?.songArtwork,completed: nil)
//        playbackController.configurePlaybackUI(with: PlaybackViewModel(songName: dataSource?.songName, artistName: dataSource?.artistName))
//    }
//    
//    @objc func goToPreviousScreen(){
//        dismiss(animated: true)
//    }
//    
//    @objc func sharePlayback(){
//        
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    
//
//}
//
//extension MusicPlayerViewController : PlaybackControllerViewDelegate{
//    func forwardPlayback(_ playbackControl: PlaybackControllerView) {
//        
//    }
//    
//    func rewindPlayback(_ playbackControl: PlaybackControllerView) {
//        
//    }
//    
//    func playPausepPlayback(_ playbackControl: PlaybackControllerView) {
//        
//    }
//    
//    
//}

class MusicPlaybackViewController : UIViewController{
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
        let playbackView = MusicPlaybackView()
        
        let hostingController = UIHostingController(rootView: playbackView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        hostingController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct MusicPlaybackView: View {
    
    @StateObject var playbackManager = SpotifyAPIManager.api_manager
    @State var track: Track?
    @State private var isPlaying: Bool = false
    @State private var timer: Timer? = nil
    @State private var currentProgress : CGFloat = 0.0
    
    func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in

            playbackManager.getPlaybackState { res in
                DispatchQueue.main.async {
                    switch res {
                    case .success(let state):
                        self.isPlaying = state.is_playing
                        self.currentProgress = CGFloat(self.playbackManager.getCurrentSeekPercentage())
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            playbackManager.getCurrentlyPlayingTrack { res in
                switch res {
                case .success(let playback):
                    DispatchQueue.main.async {
                        self.track = playback.item
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let track = track, let imageUrlString = track.album?.images.first?.url, let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .padding()
                Text(track.name).font(.title3).bold()
            } else {
                Image(systemName: "music.note")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .padding()
            }
            
            SpectrumView(isPlaying: $isPlaying,completionPercentage: $currentProgress).frame(height: 100)
            HStack(alignment: .center) {
                Button(action: {
                    playbackManager.togglePlaybackShuffle { res in
                        
                    }
                }) {
                    Image(systemName: "shuffle.circle.fill").font(.largeTitle).foregroundColor(.white)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Spacer()
                Button(action: {
                    playbackManager.rewindSpotifyPlayback { res in
                        
                    }
                }) {
                    Image(systemName: "backward.fill").font(.largeTitle).foregroundColor(.white)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Spacer()
                Button(action: {
                    if isPlaying {
                        playbackManager.pauseSpotifyPlayback() { res in
                            
                        }
                    } else {
                        playbackManager.playSpotifyPlayback() { res in
                            
                        }
                    }
                    isPlaying.toggle()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Spacer()
                Button(action: {
                    playbackManager.forwardSpotifyPlayback { res in
                        
                    }
                }) {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Button(action: {
                    playbackManager.toggleRepeatPlayback { res in
                        
                    }
                }) {
                    Image(systemName: "repeat.circle.fill").font(.largeTitle).foregroundColor(.white)
                }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                Spacer()
            }.padding(.top)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
}

struct SpectrumView: View {
    @Binding var isPlaying: Bool
    @State private var phase: Double = 0.0
    @Binding private var completionPercentage: CGFloat
    @State private var barWidth: CGFloat = 4.0
    let amplitude: CGFloat = 60.0
    let speed: Double = 0.02
    let spacing: CGFloat = 8.0
    let cornerRadius: CGFloat = 4.0
    @State private var timer: Timer?


    init(isPlaying: Binding<Bool>, completionPercentage : Binding<CGFloat>) {
        self._isPlaying = isPlaying
        self._completionPercentage = completionPercentage
        print("Progress : \(completionPercentage)")
    }

    var body: some View {
        GeometryReader { geometry in
            let totalBars = Int((geometry.size.width + spacing) / (barWidth + spacing))
            
            VStack {
                HStack(spacing: spacing) {
                    ForEach(0..<totalBars, id: \.self) { i in
                        Rectangle()
                            .fill(self.getBarColor(i: i))
                            .frame(width: barWidth, height: self.getRectangleHeight(i: i, width: geometry.size.width))
                            .cornerRadius(cornerRadius)
                    }
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                startAnimation()
            }
            .onDisappear {
                stopAnimation()
            }
            .onChange(of: isPlaying) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    stopAnimation()
                }
            }
        }
    }

    func startAnimation() {
        stopAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if self.isPlaying {
                self.phase += self.speed
                self.updateCompletionPercentage()
            } else {
                timer.invalidate()
            }
        }
    }

    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }

    func getRectangleHeight(i: Int, width: CGFloat) -> CGFloat {
        let barCount = Int((width + spacing) / (barWidth + spacing))
        let x = CGFloat(i) * (width / CGFloat(barCount))
        let angle = (x / width) * 2 * .pi + phase
        return amplitude * (sin(angle) + 1)
    }
    
    func getBarColor(i: Int) -> Color {
        let barCount = Int((UIScreen.main.bounds.width + spacing) / (barWidth + spacing))
        return CGFloat(i) < (completionPercentage * CGFloat(barCount)) ? .white : .gray
    }
    
    func updateCompletionPercentage() {
//        completionPercentage = min(completionPercentage + 0.001, 1.0)
    }
}
