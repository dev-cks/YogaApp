//
//  SettingsView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 04.11.2021.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: YogaAppViewModel
    
    var close: CloseAction?
    
    var body: some View {
        List {
            HStack {
                Spacer()
                
                Text("Detector models")
                
                Spacer()
            }
            
            ForEach(KeypointDetectorModelType.allCases, id: \.self) {
                item in
                DetectorModelCell(modelType: item, isSelected: viewModel.modelType == item, onSelect: {
                    modelType in
                    viewModel.modelType = modelType
                })
            }

            HStack {
                Spacer()
                
                Button(action: {
                    close?()
                }, label: {
                    Text("Close")
                })
                
                Spacer()
            }
        }
    }
}
