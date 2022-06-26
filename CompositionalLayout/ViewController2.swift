//
//  ViewController2.swift
//  CompositionalLayout
//
//  Created by Venkata Ajay Sai Nellori on 12/06/22.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    private let sections = MockData.shared.pageData
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout{
        .init { [weak self] (sectionIndex, layoutEnvironment) in
            // We will return different layouts for different sections
            guard let self = self else{return nil}
            let section = self.sections[sectionIndex]
            switch section{
            case .stories:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .absolute(70), height: .absolute(70), items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .popular:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(0.9), height: .fractionalHeight(0.6), items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            case .comingSoon:
                let item = CompositionalLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
                let group = CompositionalLayout.createGroup(alignment: .horizontal, width: .absolute(170), height: .absolute(80), items: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10)
                section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                section.supplementariesFollowContentInsets = false
                return section
            }
        }
    }
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

extension ViewController2: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeaderCell", for: indexPath) as? CollectionViewHeaderCell else{return CollectionViewHeaderCell()}
                    headerView.setUp(headerTitle: sections[indexPath.section].title)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section]{
        case .stories(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as? StoryCollectionViewCell else{return StoryCollectionViewCell()}
            cell.setUp(listItem: items[indexPath.row])
            return cell
        case .popular(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortraitCollectionViewCell", for: indexPath) as? PortraitCollectionViewCell else{return PortraitCollectionViewCell()}
            cell.setUp(listItem: items[indexPath.row])
            return cell
        case .comingSoon(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandScapeCollectionViewCell", for: indexPath) as? LandScapeCollectionViewCell else{return LandScapeCollectionViewCell()}
            cell.setUp(listItem: items[indexPath.row])
            return cell
        }
    }
}

class StoryCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var cellImgView: UIImageView!
    func setUp(listItem:ListItem){
        cellImgView.image = UIImage(named:listItem.image)
        cellImgView.layoutIfNeeded()
        cellImgView.layer.cornerRadius = cellImgView.frame.height/2
    }
}
class PortraitCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var cellTitleLbl: UILabel!
    @IBOutlet weak var cellImgView: UIImageView!
    func setUp(listItem:ListItem){
        cellTitleLbl.text = listItem.title
        cellImgView.image = UIImage(named: listItem.image)
        self.contentView.layer.cornerRadius = 10
    }
}
class LandScapeCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var cellTitleLbl: UILabel!
    @IBOutlet weak var cellImgView: UIImageView!
    func setUp(listItem:ListItem){
        cellTitleLbl.text = listItem.title
        cellImgView.image = UIImage(named: listItem.image)
        self.contentView.layer.cornerRadius = 10
    }
}
class CollectionViewHeaderCell: UICollectionReusableView{
    @IBOutlet weak var sectionTitleLbl: UILabel!
    func setUp(headerTitle:String){
        sectionTitleLbl.text = headerTitle
    }
}

