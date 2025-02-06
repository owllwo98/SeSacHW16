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
        searchBar.searchTextField.textColor = .white
        searchBar.barTintColor = .black
        
        return searchBar
    }()
    
    let posterImageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingSearchBar.delegate = self

        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    func configureHierarchy() {
        view.addSubview(shoppingSearchBar)
        view.addSubview(posterImageView)
    }
    
    func configureLayout() {
        shoppingSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(shoppingSearchBar.snp.bottom).inset(-120)
            make.width.equalTo(300)
            make.height.equalTo(230)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func configureView() {
        view.backgroundColor = .black
        self.navigationItem.title = "도봉러의 쇼핑쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "back"), style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .lightGray
        
        shoppingSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필, 태그 등", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.51, green: 0.51, blue: 0.537, alpha: 1)])
       
        posterImageView.image = UIImage(named: "poster")
    }

}

extension ShoppingTitleViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        
        guard let text = shoppingSearchBar.text else {
            return
        }
        
        if text.count < 2 {
            shoppingSearchBar.text = ""
            shoppingSearchBar.placeholder = "2글자 이상 입력해주세요"
        } else {
            query = shoppingSearchBar.text ?? "네이버"
            NetworkManager.shared.request(url: URLValue.naver + "query=\(query)", headers: HttpHeader.naver, T: Shopping.self) { [weak self] (shopping: Shopping) in
                guard let self = self else {return}
                
                let vc = ShoppingDetailViewController()
                
                vc.shoppingDetailViewTitle = query
                vc.list = shopping.items
                vc.total = shopping.total ?? 0
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}
