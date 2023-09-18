//
//  ToDoListCategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-17.
//

import UIKit

class ToDoListCategoryViewController: UIViewController {
    
    let blurView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.alpha = 0.4
        return view
    }()
    
    let dismissButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    let addCategoryButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()

    
    private let categoryCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)),subitem: item , count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
        
        return NSCollectionLayoutSection(group: group)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        dismissButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        
        addCategoryButton.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        
        categoryCollectionView.backgroundColor = .clear
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        categoryCollectionView.register(CategoryViewCollectionViewCell.self, forCellWithReuseIdentifier: CategoryViewCollectionViewCell.identifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initalizeBlurView()
        view.addSubview(categoryCollectionView)
        view.addSubview(dismissButton)
        view.addSubview(addCategoryButton)
        view.bringSubviewToFront(dismissButton)
        view.bringSubviewToFront(addCategoryButton)

        dismissButton.frame = CGRect(x: view.width - 40, y: 40, width: 30, height: 30)
        
        addCategoryButton.frame = CGRect(x: dismissButton.left - 30, y: 40, width: 30, height: 30)
        
        categoryCollectionView.frame = CGRect(x: 0, y: dismissButton.bottom + 10, width: view.width , height: view.height - (dismissButton.bottom - 10))
        
       
    }
    
    func initalizeBlurView(){
        
        blurView.frame = view.frame
        
        blurView.effect = UIBlurEffect(style: .regular)
        
        view.addSubview(blurView)
    }
    
    @objc func didDismiss(){
        dismiss(animated: true)
    }
    
    @objc func createCategory(){
        let newCategoryViewController = NewCategoryViewController()
        
        if let categorySheet = newCategoryViewController.sheetPresentationController{
            categorySheet.prefersGrabberVisible = true
            categorySheet.detents = [.medium()]
            present(newCategoryViewController, animated: true)
        }
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

extension ToDoListCategoryViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCollectionViewCell.identifier, for: indexPath) as? CategoryViewCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.generateViewCell(category: ToDoListManager.categories[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ToDoListManager.categories.count
    }
    
}
