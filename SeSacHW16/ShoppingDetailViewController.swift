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
        button.tag = 0
        button.addTarget(self, action: #selector(similar), for: .touchUpInside)
        
        return button
    }()
    
    lazy var dateSortButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white , for: .normal)
        button.backgroundColor = .black
        button.setTitle("  날짜순  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = 1
        button.addTarget(self, action: #selector(dateSort), for: .touchUpInside)
        
        return button
    }()
    
    lazy var highPriceSortButton:  UIButton = {
        let button = UIButton()
        button.setTitleColor(.white , for: .normal)
        button.backgroundColor = .black
        button.setTitle("  가격높은순  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = 2
        button.addTarget(self, action: #selector(descending), for: .touchUpInside)
        
        return button
    }()
    
    lazy var lowPirceSortBurron:  UIButton = {
        let button = UIButton()
        button.setTitleColor(.white , for: .normal)
        button.backgroundColor = .black
        button.setTitle("  가격낮은순  ", for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.tag = 3
        button.addTarget(self, action: #selector(Ascending), for: .touchUpInside)
        
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
        
        [standardButton, dateSortButton, highPriceSortButton, lowPirceSortBurron].forEach {
            $0.addTarget(self, action: #selector(self.radioButton(_ :)), for: .touchUpInside)
        }
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
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingDetailCollectionViewCell", for: indexPath) as! ShoppingDetailCollectionViewCell
       
        cell.configureData(list[indexPath.row])
        
        DispatchQueue.main.async {
            cell.itemImageView.layer.cornerRadius = 10
            cell.itemImageView.clipsToBounds = true
        }
        
       
        return cell
    }
}

extension ShoppingDetailViewController {
    @objc
    func radioButton(_ sender: UIButton) {
        [standardButton, dateSortButton, highPriceSortButton, lowPirceSortBurron].forEach {
            if $0.tag == sender.tag {
                $0.backgroundColor = .white
                $0.setTitleColor(.black, for: .normal)
            } else {
                $0.backgroundColor = .black
                $0.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    // MARK: 과제를 착각해서 기존 배열에서 정렬하는 건 줄 알았는데 중간에 깨달았습니다.. 지우긴 아까워서 ㅎㅎ;
    /*
    @objc
    func descending() {
        let newList = list.sorted(by: {Int($0.lprice ?? "") ?? 0 > Int($1.lprice ?? "") ?? 0})
        list = newList
        
        collectionView.reloadData()
    }
    
    @objc
    func Ascending() {
        let newList = list.sorted(by: {Int($0.lprice ?? "") ?? 0 < Int($1.lprice ?? "") ?? 0})
        list = newList
        
        collectionView.reloadData()
    }
    
    @objc
    func dateAscending() {
        
    }
    
    @objc
    func accuracy() {
        
    }
    */
    
    @objc
    func descending() {
        fetchShoppingData("dsc") {
            [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    @objc
    func Ascending() {
        fetchShoppingData("asc") {
            [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    @objc
    func dateSort() {
        fetchShoppingData("date") {
            [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    @objc
    func similar() {
        fetchShoppingData("sim") {
            [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func fetchShoppingData(_ sort: String = "sim" ,completion: @escaping () -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(String(describing: shoppingDetailViewTitle))&display=100&sort=\(sort)"
        let headers: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverID, "X-Naver-Client-Secret" : APIKey.naverSecret]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
                
            case.success(let value):
                self.total = value.total ?? 0
                self.list = value.items
                completion()
            case.failure(let error) :
                print(error)
            }
        }
    }
    
}
