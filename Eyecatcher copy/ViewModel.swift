//
//  ViewModel.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import SwiftUI

class ViewModel: ObservableObject{
    
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("hasCompletedLanguageSelection") var hasCompletedLanguageSelection: Bool = false
}
