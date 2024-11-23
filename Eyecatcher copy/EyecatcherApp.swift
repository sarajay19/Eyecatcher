//
//  EyecatcherApp.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import SwiftUI
import SwiftData

@main
struct EyecatcherApp: App {
        
        @StateObject var vm = ViewModel()
         
        var body: some Scene {
            WindowGroup {
                FirstView()
                    .environmentObject(vm)
                    .modelContainer(for: [Category.self, Photo.self])
                
                }
            
            }
        }



    struct FirstView: View {
        @EnvironmentObject var vm: ViewModel
        var body: some View {
            VStack{
                if vm.hasCompletedOnboarding{
                    CameraView()
                }
                else{
                    Onboarding()
                }
            }
        }
    }
