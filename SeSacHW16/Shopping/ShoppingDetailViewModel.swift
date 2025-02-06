//
//  ShoppingDetailViewModel.swift
//  SeSacHW16
//
//  Created by 변정훈 on 2/6/25.
//

import Foundation

class ShoppingDetailViewModel {
    let inputStatus: Observable<String> = Observable("sim")
    let inputStart: Observable<Int> = Observable(1)
    let inputQuery: Observable<String> = Observable("")
    let inputSortButtonTapped: Observable<String> = Observable("sim")
    let inputIndexPath: Observable<[IndexPath]> = Observable([])
    
    let outputShoppingTotal: Observable<Int> = Observable(0)
    let outputShoppingitem: Observable<[ShoppingDetail]> = Observable([])
    let outputScrollTop: Observable<Bool> = Observable(false)
    
    init() {
        inputQuery.lazyBind { String in
            self.requestShoppingData(query: String, start: self.inputStart.value, sort: self.inputStatus.value)
        }
        
        inputSortButtonTapped.lazyBind { sort in
            self.inputStatus.value = sort
            
            self.requestShoppingData(query: self.inputQuery.value, start: self.inputStart.value, sort: self.inputStatus.value)
        }
        
        inputStart.lazyBind { _ in
            self.requestShoppingData(query: self.inputQuery.value, start: self.inputStart.value, sort: self.inputStatus.value)
        }
        
        inputIndexPath.lazyBind { _ in
            self.prefetchCell()
        }
    }
    
    private func requestShoppingData(query: String, start: Int, sort: String) {
        NetworkManager.shared.request(url: URLValue.naver + "query=\(query)&start=\(start)&sort=\(sort)", headers: HttpHeader.naver, T: Shopping.self) { [weak self] (shopping: Shopping) in
            guard let self = self else {return}
            
            if inputStart.value == 1 {
                outputShoppingTotal.value = shopping.total ?? 0
                outputShoppingitem.value = shopping.items
            } else {
                outputShoppingTotal.value = shopping.total ?? 0
                outputShoppingitem.value.append(contentsOf: shopping.items)
            }
            
            if inputStart.value == 1 {
                outputScrollTop.value.toggle()
            }
        }
    }
    
    private func prefetchCell() {
        for item in inputIndexPath.value {
            if  (outputShoppingitem.value.count) - 2 == item.item {
                inputStart.value += 100
                requestShoppingData(query: inputQuery.value, start: inputStart.value, sort: inputStatus.value)
                print(inputStart.value)
            }
        }
    }
}
