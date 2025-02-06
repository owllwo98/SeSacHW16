//
//  ShoppingTitleViewModel.swift
//  SeSacHW16
//
//  Created by 변정훈 on 2/6/25.
//

import Foundation

class ShoppingTitleViewModel {
    
    let inputTextField: Observable<String?> = Observable(nil)
    
    let outputText: Observable<String> = Observable("")
    let outputPlaceHolder: Observable<String> = Observable("")
    let outputNav: Observable<Bool> = Observable(false)
    
    init() {
        inputTextField.lazyBind { text in
            self.validationText(text: text)
        }
    }
    
    private func validationText(text: String?) {
        guard let text else {
            print("text nil 값 발생")
            return
        }
        
        if text.count < 2 {
            outputText.value = ""
            outputPlaceHolder.value = "2글자 이상 입력해주세요"
        } else {
            outputNav.value.toggle()
        }
    }
}
