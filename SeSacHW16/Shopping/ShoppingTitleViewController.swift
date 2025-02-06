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
    lazy var shoppingSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.textColor = .white
        searchBar.barTintColor = .black
        
        return searchBar
    }()
    
    let posterImageView: UIImageView = UIImageView()
    
    let viewModel = ShoppingTitleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shoppingSearchBar.delegate = self

        configureHierarchy()
        configureLayout()
        configureView()
        
        bindData()
        
    }
    
    func bindData() {
        viewModel.outputText.lazyBind { text in
            self.shoppingSearchBar.text = text
        }
        
        viewModel.outputPlaceHolder.lazyBind { text in
            self.shoppingSearchBar.placeholder = text
        }
        
        viewModel.outputNav.lazyBind { value in
            let vc = ShoppingDetailViewController()
            
            guard let text = self.shoppingSearchBar.text else {
                return
            }
            
            vc.viewModel.inputQuery.value = text
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        viewModel.inputTextField.value = searchBar.text
    }
}
