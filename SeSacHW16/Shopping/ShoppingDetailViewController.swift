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
    
    var shoppingDetailView = ShoppingDetailView()
    
    let viewModel = ShoppingDetailViewModel()
    
    override func loadView() {
        self.view = shoppingDetailView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = viewModel.inputQuery.value
        
        configureView()
        configureActions()
   
        bindData()
    }
    
    func bindData() {
        viewModel.outputShoppingTotal.bind { total in
            self.shoppingDetailView.totalLabel.text = "\(total) 개의 검색 결과"
        }
        
        viewModel.outputShoppingitem.lazyBind { value in
            self.shoppingDetailView.collectionView.reloadData()
        }
        
        viewModel.outputScrollTop.lazyBind { _ in
            self.shoppingDetailView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }

    func configureView() {
        shoppingDetailView.collectionView.dataSource = self
        shoppingDetailView.collectionView.delegate = self
        shoppingDetailView.collectionView.prefetchDataSource = self
        shoppingDetailView.collectionView.register(ShoppingDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ShoppingDetailCollectionViewCell")
    }
    
    func configureActions() {
        [shoppingDetailView.standardButton,
         shoppingDetailView.dateSortButton,
         shoppingDetailView.highPriceSortButton,
         shoppingDetailView.lowPriceSortButton].forEach {
            $0.addTarget(self, action: #selector(radioButton(_:)), for: .touchUpInside)
        }
        shoppingDetailView.standardButton.addTarget(self, action: #selector(similar), for: .touchUpInside)
        shoppingDetailView.dateSortButton.addTarget(self, action: #selector(dateSort), for: .touchUpInside)
        shoppingDetailView.highPriceSortButton.addTarget(self, action: #selector(descending), for: .touchUpInside)
        shoppingDetailView.lowPriceSortButton.addTarget(self, action: #selector(Ascending), for: .touchUpInside)
    }
}

extension ShoppingDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputShoppingitem.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShoppingDetailCollectionViewCell", for: indexPath) as! ShoppingDetailCollectionViewCell
        
        let data = viewModel.outputShoppingitem.value
        cell.configureData(data[indexPath.item])
        
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
        [shoppingDetailView.standardButton,
         shoppingDetailView.dateSortButton,
         shoppingDetailView.highPriceSortButton,
         shoppingDetailView.lowPriceSortButton].forEach {
            if $0.tag == sender.tag {
                $0.backgroundColor = .white
                $0.setTitleColor(.black, for: .normal)
            } else {
                $0.backgroundColor = .black
                $0.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @objc
    func descending() {
        viewModel.inputSortButtonTapped.value = "dsc"
        viewModel.inputStart.value = 1
    }
    
    @objc
    func Ascending() {
        viewModel.inputSortButtonTapped.value = "asc"
        viewModel.inputStart.value = 1
    }
    
    @objc
    func dateSort() {
        viewModel.inputSortButtonTapped.value = "date"
        viewModel.inputStart.value = 1
    }
    
    @objc
    func similar() {
        viewModel.inputSortButtonTapped.value = "sim"
        viewModel.inputStart.value = 1
    }
}

extension ShoppingDetailViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.inputIndexPath.value = indexPaths
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}

//extension ShoppingDetailViewController {
//    func requestShoppingData() {
//        NetworkManager.shared.request(url: URLValue.naver + "query=\(shoppingDetailViewTitle)&start=\(start)&sort=\(status)", headers: HttpHeader.naver, T: Shopping.self) { [weak self] (shopping: Shopping) in
//            guard let self = self else {return}
//            
//            print(URLValue.naver + "query=\(shoppingDetailViewTitle)&start=\(start)&sort=\(status)")
//            
//            if total > start {
//                self.isEnd = false
//            } else {
//                isEnd = true
//            }
//            
//            if start == 1 {
//                total = shopping.total ?? 0
//                list = shopping.items
//            } else {
//                total = shopping.total ?? 0
//                list.append(contentsOf: shopping.items)
//            }
//            
//            if start == 1 {
//                shoppingDetailView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//            }
//            shoppingDetailView.collectionView.reloadData()
//        }
//    }
//}


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
