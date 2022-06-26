//
//  ViewController.swift
//  CompositionalLayout
//
//  Created by Venkata Ajay Sai Nellori on 11/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    private let images: [UIImage] = Array(1 ... 11).map({UIImage(named: String($0))!})
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.collectionViewLayout = createWamglamLayout()
    }
    private func createLayout() -> UICollectionViewCompositionalLayout{
        // first row contains 1 image
        // second row contains horizontal collection which contains two sections. First section contains 1 image. Second section contains vertical collection of 2 images
        // first row and second row is a vertical collection which occupies 50% of screen height
        let mainItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(0.4), spacing: 1)
        let itemInSecondRow = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 1)
        let itemInSecondRowColumn = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
        let subGroupInSecondRowColumn = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .fractionalHeight(1), item: itemInSecondRowColumn, count: 2)
        let subGroup = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.6), items: [itemInSecondRow,subGroupInSecondRowColumn])
        let mainGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [mainItem, subGroup])
        let section = NSCollectionLayoutSection(group: mainGroup)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createInstagramLayout() -> UICollectionViewCompositionalLayout{
        //Open Instagram and compare my layout
        let subItem = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 1)
        let subGroupSingleRow = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.5), item: subItem, count: 2)
        let subGroupVertical = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1-(1/3)), height: .fractionalHeight(1), item: subGroupSingleRow, count: 2)
        let mainItem = CompositionalLayout.createItem(width: .fractionalWidth(1/3), height: .fractionalHeight(1), spacing: 1)
        let subGroupHorizontal1 = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [subGroupVertical,mainItem])
        let subGroupHorizontal2 = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [mainItem,subGroupVertical])
        let mainGroup = CompositionalLayout.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.7), items: [subGroupHorizontal1,subGroupHorizontal2])
        let section = NSCollectionLayoutSection(group: mainGroup)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createWamglamLayout() -> UICollectionViewCompositionalLayout{
        let leftItem = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), top: 0, bottom: 20, leading: 12, trailing: 12)
        let rightItem = CompositionalLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), top: 20, bottom: 0, leading: 12, trailing: 12)
        let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1/3), items: [leftItem,rightItem])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //For Wamglam Layout
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionCell", for: indexPath) as? MyCollectionCell
        else{return MyCollectionCell()}
        cell.configureCell()
        cell.setImage(image: images[indexPath.row])

        // For Normal Layout
        /*guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell
        else{return CollectionCell()}
        cell.setImage(image: images[indexPath.row])*/
        return cell
    }
    
    
}

class MyCollectionCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    func setImage(image: UIImage){
        self.imageView.image = image
    }
    func configureCell(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.systemGray5.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
}

class CollectionCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
    func setImage(image: UIImage){
        self.imageView.image = image
    }
}
