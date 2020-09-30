//
//  DualChoiceViewModel.swift
//  YToke
//
//  Created by Lyt on 9/28/20.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Foundation

struct DualChoiceViewModel<T> {
    
    let question: String
    let subtitle: String
    
    let titleA: String
    let contentA: T
    let titleB: String
    let contentB: T
    private let onSelect: (T) -> Void
    
    init(question: String,
         subtitle: String,
         titleA: String,
         contentA: T,
         titleB: String,
         contentB: T,
         onSelect: @escaping (T) -> Void) {
        self.question = question
        self.subtitle = subtitle
        self.titleA = titleA
        self.contentA = contentA
        self.titleB = titleB
        self.contentB = contentB
        self.onSelect = onSelect
    }
    
    func onASelect() {
        onSelect(contentA)
    }
    
    func onBSelect() {
        onSelect(contentB)
    }
    
}
