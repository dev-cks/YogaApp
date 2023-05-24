//
//  PoseListView.swift
//  YogaPrototype
//
//  Created by Sergii Kutnii on 11.10.2021.
//

import SwiftUI

struct ExerciseListView: View {
    @ObservedObject var viewModel: ExerciseListViewModel
    
    var viewExercise: ViewExerciseAction?
    var openSettings: SettingsAction?
    
    var settingsButton: some View {
        Image(systemName: "gear")
            .onTapGesture {
                openSettings?()
            }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("POSES")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 36).bold())
                    .foregroundColor(Color.white)
                    .padding(.top, 24)
                
                VStack {
                    
                    let samples = viewModel.items
                    ForEach(samples, id: \.exercise.uid) {
                        sample in
                        ExerciseCell(viewModel: sample)
                            .setDetailEvent {
                                viewExercise?(sample)
                            }
                            .frame(maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .padding(.top, 4)
                            .padding(.bottom, 4)
                            .background(Color.HexToColor(hexString: Constant.Color.poseBackGround))
                            .cornerRadius(20)
                            

                            
                    }
                    
                }
                .padding(.top, 20)
                .frame(maxHeight: .infinity)
                    
                
                
            }
            .padding(.all, 20)
            

            if viewModel.isLoading {
                ProgressView()
            }
        }
        .background(Color.HexToColor(hexString: Constant.Color.mainBackGround))
        
        
    }
    
    func withItemAction(_ action: @escaping ViewExerciseAction) -> ExerciseListView {
        var clone = self
        clone.viewExercise = action
        return clone
    }
}
