//
//  HomePageViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-12.
//

import UIKit
import ARKit

enum HomePageSections{
    case Category(viewModel: [UIViewController])
    case Widget(viewModel: [Location])
    
    var title : String{
        switch self{
        case .Category:
            return "Category"
        case .Widget:
            return "Widgets"
        }
    }
}

class HomePageViewController: UIViewController {
    
    var home_sections = [HomePageSections]()
    
    var watchBarButton : UIBarButtonItem?
    
    var menuButton : UIBarButtonItem?
    
    let watchRender : UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.cornerRadius = 20
        return button
    }()
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomePageViewController.generateCollectionView(with: sectionIndex)
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationBar()
        createWatchFaceRender()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        createSections()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        view.addSubview(watchRender)
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: watchRender.bottom, width: view.width, height: (view.height - watchRender.bottom))
    }
    
    func createNavigationBar(){
        watchBarButton = UIBarButtonItem(title: "Back",image: UIImage(systemName: "applewatch"), target: self, action: #selector(smartWatchButtonTouched))
        watchBarButton?.tintColor = .white
        
        menuButton = UIBarButtonItem(title: "Back",image: UIImage(systemName: "line.3.horizontal"), target: self, action: #selector(drawNavigationDrawer))
        menuButton?.tintColor = .white
        
        navigationItem.rightBarButtonItem = watchBarButton
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.title = "TimeCraft"
    }
    
    @objc func smartWatchButtonTouched(){
        navigationController?.pushViewController(BluetoothDiscoveryViewController(), animated: true)
    }
    
    @objc func drawNavigationDrawer(){
        let navigationDrawer = DrawerMenuViewController()
        
        present(navigationDrawer, animated: true)
    }
    
    func createWatchFaceRender(){
        watchRender.frame = CGRect(x: 0, y: 0, width: view.width, height: 300)
    }
    
    func createSections(){
        home_sections.append(.Category(viewModel: [MapViewController(),PlaybackViewController(),ToDoListViewController()]))
    }
    
    static func generateCollectionView(with sectionIndex : Int) -> NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        
        let horizontal_group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(125)), subitem: item, count: 1)
        
        let vertical_group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(125)), subitem: horizontal_group, count: 1)
        
        let section = NSCollectionLayoutSection(group: vertical_group)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
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

extension HomePageViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = home_sections[indexPath.section]
        
        switch section{
        case .Category(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,for: indexPath) as? CategoryCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.layer.cornerRadius = 12
            print(type(of: viewModel[indexPath.row]))
            cell.generateCell(with: viewModel[indexPath.row], image: "", title: "Map")
            return cell
        case .Widget(let viewModel):
            return UICollectionViewCell()
        }
       
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = home_sections[indexPath.section]
        
        switch section{
        case .Category(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,for: indexPath) as? CategoryCollectionViewCell else{
                return
            }
            navigationController?.pushViewController(viewModel[indexPath.row], animated: true)
        case .Widget(let viewModel):
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = home_sections[section]
        
        switch section{
        case .Category(let viewModel):
            return viewModel.count
        case .Widget(let viewModel):
            return viewModel.count
        }
    }
}
