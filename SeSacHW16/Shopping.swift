//
//  Shopping.swift
//  SeSacHW16
//
//  Created by 변정훈 on 1/15/25.
//

import Foundation

struct Shopping: Decodable {
    let items: [ShoppingDetail]
    let total: Int?
}

struct ShoppingDetail: Decodable {
//    let title: String?
//    let image: String?
//    let lprice: String?
//    let mallName: String?
    
    let title: String?
    let link: String?
    let image: String?
    let lprice, hprice, mallName, productID: String?
    let productType: String?
    let brand, maker: String?
    let category1: String?
    let category2: String?
    let category3: String?
    let category4: String?
}


