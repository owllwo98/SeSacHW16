//
//  ShoppingDetailViewController.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/15/25.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class ShoppingDetailViewController: UIViewController {
    var shoppingDetailViewTitle: String?
    var list: [ShoppingDetail] = []
    var total: Int = 0
    
    let totalLabel: UILabel = UILabel()
    
    lazy var standardButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.backgroundColor = .white
        button.setTitle("  정확도  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return button
    }()
    
    lazy var dateSortButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.backgroundColor = .white
        button.setTitle("  날짜순  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
      
        
        return button
    }()
    
    lazy var highPriceSortButton:  UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.backgroundColor = .white
        button.setTitle("  가격높은순  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return button
    }()
    
    lazy var lowPirceSortBurron:  UIButton = {
        let button = UIButton()
        button.setTitleColor(.black , for: .normal)
        button.backgroundColor = .white
        button.setTitle("  가격낮은순  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        
        return button
    }()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        self.navigationItem.title = shoppingDetailViewTitle
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        [totalLabel, standardButton, dateSortButton, highPriceSortButton, lowPirceSortBurron].forEach {
            view.addSubview($0)
        }
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ShoppingDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ShoppingDetailCollectionViewCell")
    }
    
    func configureLayout() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(8)
        }
        
        standardButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalToSuperview().inset(8)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalTo(standardButton.snp.trailing).inset(-10)
        }
        
        highPriceSortButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalTo(dateSortButton.snp.trailing).inset(-10)
        }
        
        lowPirceSortBurron.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).inset(-4)
            make.leading.equalTo(highPriceSortButton.snp.trailing).inset(-10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(highPriceSortButton.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView() {
        totalLabel.textColor = .green
        totalLabel.text = total.formatted() + " 개의 검색 결과"
        totalLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        collectionView.backgroundColor = .black
    
    }
    
    func collectionViewLayout() -> UICollectionViewLayout {
        
        let sectionInset: CGFloat = 8
        let cellSpacing: CGFloat = 8
        
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (sectionInset * 2) - (cellSpacing * 1)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2)
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset / 2, bottom: sectionInset, right: sectionInset / 2)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 60
        
        print(deviceWidth)
        print(cellWidth / 2)
        return layout
    }

}

extension ShoppingDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingDetailCollectionViewCell", for: indexPath) as! ShoppingDetailCollectionViewCell
       
        
        cell.configureData(list[indexPath.row])
        cell.itemImageView.layer.cornerRadius = 8
       
        return cell
    }
    
    
}
