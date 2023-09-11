//
//  FilterViewModel.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 13/9/22.
//
import SwiftUI
import Foundation

class FilterViewModel: ObservableObject {
    
    @Published var popularFilters: [PopularFilters] = []
}

extension FilterViewModel {
    
    func containsFilter(_ filter: String) -> Bool {
//        return PopularFilters.contains { $0.rawvalue == filter }
        return true
    }
}
