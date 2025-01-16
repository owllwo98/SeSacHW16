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
    var shoppingDetailViewTitle: String = ""
    var list: [ShoppingDetail] = []
    var total: Int = 0
    
    var start: Int = 1
    var isEnd: Bool = false
    var status: String = "sim"
    
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
        print(shoppingDetailViewTitle)
        
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
        collectionView.prefetchDataSource = self
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
        
        return layout
    }

}

extension ShoppingDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingDetailCollectionViewCell", for: indexPath) as! ShoppingDetailCollectionViewCell
       
        cell.configureData(list[indexPath.item])
        
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
    
//    enum Sorted {
//        case dsc
//        case asc
//        case date
//        case sim
//    }
    
    @objc
    func descending() {
        status = "dsc"
        start = 1
        sort("dsc")
    }
    
    @objc
    func Ascending() {
        status = "asc"
        start = 1
        sort("asc")
    }
    
    @objc
    func dateSort() {
        status = "date"
        start = 1
        sort("date")
    }
    
    @objc
    func similar() {
        status = "sim"
        start = 1
        sort("sim")
    }
    
    func fetchShoppingData(_ sort: String = "sim", completion: @escaping () -> Void) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(shoppingDetailViewTitle)&display=30&start=\(start)&sort=\(sort)"
        let headers: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverID, "X-Naver-Client-Secret" : APIKey.naverSecret]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
                
            case.success(let value):
                
                // 로직으로 처리하려고 했는데 Naver API 에서 total 갯수를 초가하는 값을 요구하면 그냥 빈배열만 보냐줘서 따로 처리할게 없었습니다.
                if self.total > self.start {
                    self.isEnd = false
                } else {
                    self.isEnd = true
                }
                
                if self.start == 1 {
                    self.total = value.total ?? 0
                    self.list = value.items
                } else {
                    self.total = value.total ?? 0
                    self.list.append(contentsOf: value.items)
                }
        
                if self.start == 1 {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
               
                completion()
            case.failure(let error) :
                print(error)
            }
        }
    }
    
    func sort(_ sort: String) {
        fetchShoppingData(sort) {
            [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }

}

extension ShoppingDetailViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if list.count - 2 == item.item {
                start += 30
                fetchShoppingData(status) {
                    [weak self] in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
       
    }
    
    
}
