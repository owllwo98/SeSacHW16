//
//  ShoppingTitleViewController.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/15/25.
//

import UIKit
import Alamofire
import SnapKit

class ShoppingTitleViewController: UIViewController {
    
    var query: String = ""

    var total: Int = 0
    var list: [ShoppingDetail] = []
    
    lazy var shoppingSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchTextField.textColor = .white
//        searchBar.tintColor = UIColor(red: 0.51, green: 0.51, blue: 0.537, alpha: 1)
//        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: textfield)
        searchBar.barTintColor = .black
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingSearchBar.delegate = self

        configureHierarchy()
        configureLayout()
        configureView()
        
        fetchShoppingData()
        
    }
    
    func fetchShoppingData() {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=캠핑카&display=100"
        let headers: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverID, "X-Naver-Client-Secret" : APIKey.naverSecret]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            switch response.result {
                
            case.success(let value):
                print(value.items[0].title)
                self.total = value.total
                self.list = value.items
            case.failure(let error) :
                print(error)
            }
        }
    }
    
    func configureHierarchy() {
        view.addSubview(shoppingSearchBar)
        
    }
    
    func configureLayout() {
        
        shoppingSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
    }
    
    func configureView() {
        view.backgroundColor = .black
        self.navigationItem.title = "도봉러의 쇼핑쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "back"), style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .lightGray
    }

}

extension ShoppingTitleViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        query = searchBar.text ?? ""
        fetchShoppingData()
        let vc = ShoppingDetailViewController()
        
        vc.shoppingDetailViewTitle = query
        vc.list = list
        vc.total = total
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
