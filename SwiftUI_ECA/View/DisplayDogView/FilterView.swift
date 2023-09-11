//
//  FilterView.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 12/9/22.
//

import SwiftUI

enum PopularFilters: String, Codable, CaseIterable {
    case vaccinated = "Yes"
    case unvaccinated = "No"
}

struct FilterView: View {
    
    @StateObject private var vm: FilterViewModel
    @Environment(\.dismiss) var dismiss
    
    init(vm: FilterViewModel) {
        _vm = StateObject(wrappedValue: vm)
    }
    
//    var onFilterApplied: (FilterViewState) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filters")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            
            Text("Vaccination Status")
                .fontWeight(.bold)
            
            ForEach(PopularFilters.allCases, id: \.self) { filter in
                HStack {
                    Image(systemName: vm.containsFilter(filter.rawValue) ? "checkmark.square.fill": "square")
                        .onTapGesture{
                            if !vm.containsFilter(filter.rawValue) {
                                vm.popularFilters.append(filter)
                            } else {
                                vm.popularFilters.removeAll { $0.rawValue == filter.rawValue}
                            }
                        }
                    Text(filter.rawValue)
                }
            }
            Button {
                
            } label: {
                Text("Update the list")
                    .frame(maxWidth: .infinity, maxHeight: 44)
            }
            .padding(.top, 40)
            .buttonStyle(.borderedProminent)
        }
    }
}

//struct FilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterView(vm: FilterViewModel)
//    }
//}

//
//Rectangle()
//.fill(vm.filter == filter ? .blue: .gray)
//.frame(width: 50, height: 50)
//.overlay {
//    Text("\(filter)")
//        .foregroundColor(.white)
//}.onTapGesture {
//    vm.filter = filter
//}
