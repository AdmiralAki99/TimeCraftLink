//
//  RecommendedSongsViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-15.
//

import UIKit


class RecommendedSongsViewController: UIViewController {
    
    private let selectedSong : Track
    
    init(recommendedSong: Track){
        self.selectedSong = recommendedSong
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Track"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
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

}

