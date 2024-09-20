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

struct MusicPlaybackView : View {
    
    @StateObject var playbackManager = SpotifyAPIManager.api_manager
    
    var body: some View {
        VStack(alignment: .center){
            AsyncImage(url: URL(string: "")).frame(width: 100,height: 100).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            SpectrumView().frame(height: 100)
        }
    }
}

struct SpectrumView: View {
    @State private var phase: Double = 0.0
    @State private var completionPercentage: CGFloat = 0.0 // Represents the audio progress
    @State private var isAnimating: Bool = true // Control for animation
    @State private var barWidth: CGFloat = 4.0 // Width of the bars
    let amplitude: CGFloat = 60.0 // Amplitude for visualizer effect
    let speed: Double = 0.02 // Speed of the wave (smaller = faster)
    let spacing: CGFloat = 8.0 // Spacing between bars
    let cornerRadius: CGFloat = 4.0 // Radius for rounded corners

    var body: some View {
        GeometryReader { geometry in
            let totalBars = Int((geometry.size.width + spacing) / (barWidth + spacing)) // Calculate total bars based on width

            VStack {
                HStack(spacing: spacing) {
                    ForEach(0..<totalBars, id: \.self) { i in
                        Rectangle()
                            .fill(self.getBarColor(i: i))
                            .frame(width: barWidth, // Set the width for thinner lines
                                   height: self.getRectangleHeight(i: i, width: geometry.size.width))
                            .cornerRadius(cornerRadius) // Set the corner radius for rounded bars
                    }
                }
                .onAppear {
                    if isAnimating {
                        startAnimation()
                    }
                }
            }
            .background(Color.black) // Optional: Set a background color
            .edgesIgnoringSafeArea(.all) // Optional: Extend background to edges
        }
    }

    func startAnimation() {
        // Continuously update the phase to create a smooth wave
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if isAnimating {
                self.phase += speed
                updateCompletionPercentage()
            } else {
                timer.invalidate() // Stop the timer if animation is disabled
            }
        }
    }

    func getRectangleHeight(i: Int, width: CGFloat) -> CGFloat {
        let barCount = Int((width + spacing) / (barWidth + spacing)) // Recalculate based on current width
        let x = CGFloat(i) * (width / CGFloat(barCount)) // Use width divided by total bars for spacing
        let angle = (x / width) * 2 * .pi + phase
        // Height will vary between 0 and `amplitude`
        let height = amplitude * (sin(angle) + 1) // +1 to ensure non-negative heights
        return height
    }
    
    func getBarColor(i: Int) -> Color {
        // Determine the color based on completion percentage
        let barCount = Int((UIScreen.main.bounds.width + spacing) / (barWidth + spacing)) // Recalculate based on screen width
        return CGFloat(i) < (completionPercentage * CGFloat(barCount)) ? .white : .gray
    }
    
    func updateCompletionPercentage() {
        // Update the completion percentage over time (this could be tied to your audio duration)
        completionPercentage = min(completionPercentage + 0.001, 1.0) // Incrementally increase percentage
    }
}
