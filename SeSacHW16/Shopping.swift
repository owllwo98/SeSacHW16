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
    let title: String?
    let image: String?
    let lprice: String?
    let mallName: String?
}


