//
//  DetectorModelCell.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 04.11.2021.
//

import SwiftUI

struct DetectorModelCell: View {
    
    var modelType: KeypointDetectorModelType
    var isSelected: Bool
    
    var caption: String {
        switch(modelType) {
        case .modelII:
            return "Model II"
        case .RTModel:
            return "RT model"
        case .RTLiteModel:
            return "RT lite model"
        }
    }
    
    typealias SelectAction = (KeypointDetectorModelType) -> Void
    
    var onSelect: SelectAction?
    
    var body: some View {
        HStack{
            Text(caption)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .onTapGesture {
            onSelect?(modelType)
        }
    }
}
