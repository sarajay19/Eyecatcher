//
//  Onboarding.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import SwiftUI
import UIKit

struct Onboarding: View {
    @EnvironmentObject var vm: ViewModel
    @State private var isAnimating: Bool = false

    @Environment(\.colorScheme) var colorScheme

//    @Binding var hasCompletedOnboarding: Bool
//    @Binding var hasCompletedLanguageSelection: Bool

    @State private var currentTab = 0
    
    let MaxNumberOfTabs = 3
    
//    @State private var firstLanguageSelection: DropdownMenuOption? = nil
//    @State private var secondLanguageSelection: DropdownMenuOption? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if colorScheme == .light {
                        lightModeBackground
                    } else {
                        darkModeBackground
                    }
                }
                .ignoresSafeArea()
                .overlay{
                    VStack{
                        
                        
                        HStack(alignment: .top) {
                            
                            Button {
                                vm.hasCompletedOnboarding = true
                            } label: {
                                Text("Skip")
                                    .padding(.vertical)
                                    .padding(.leading, 310)
//                                    .padding(.leading, 710)
                                    .foregroundColor(Color.white)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        TabView(selection: $currentTab) {
                            ForEach(OnboardingData.list) { viewData in
                                OnboardingScreen(data: viewData, colorScheme: self.colorScheme)
                                // OnboardingScreen view here
                                    .tag(viewData.id)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        //            .accentColor(Color("Orange"))
                        
                        HStack(alignment: .bottom) {
                            if currentTab == 2 {
                                Button {
                                    vm.hasCompletedOnboarding = true
                                } label: {
                                    Text("Go")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical)
                                        .background(Color("Orange"))
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .cornerRadius(16)
                                }
                            } else {
                                Button(action: {
                                    if currentTab == MaxNumberOfTabs - 1 {
                                        vm.hasCompletedOnboarding = true
                                    } else {
                                        currentTab += 1
                                    }
                                }) {
                                    Text("Continue")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical)
                                        .background(Color("Orange"))
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding()
                        .frame(alignment: .bottom)
                    }
                    .preferredColorScheme(colorScheme)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

var lightModeBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("Orange"), Color("Orange").opacity(0.15), .white, .white]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

var darkModeBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("Orange").opacity(0.15),Color("Orange").opacity(0.15), .black]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

struct OnboardingScreen: View {
    var data: OnboardingData
    var colorScheme: ColorScheme
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 50) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 295, height: 295)
                .scaleEffect(isAnimating ? 1 : 0.6)
            
            VStack(spacing: 15){
                Text(data.primaryText)
                    .font(.title)
                    .bold()
                
                Text(data.secondaryText)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 290)
            }
        }
        .padding(.bottom, 50)
        .onAppear(perform: {
            isAnimating = false
            withAnimation(.easeOut(duration: 0.5)) {
                self.isAnimating = true
            }
        })
    }
    
    var imageName: String {
        if colorScheme == .light {
            return data.objectImageLight
        } else {
            return data.objectImageDark
        }
    }
}



struct OnboardingData: Hashable, Identifiable {
        let id: Int
        let objectImageLight: String
        let objectImageDark: String
        let primaryText: String
        let secondaryText: String

        static let list: [OnboardingData] = [
            OnboardingData(id: 0, objectImageLight: "CameraLight", objectImageDark: "CameraDark", primaryText: "Set up the camera", secondaryText: "Please ensure that your phone camera is connected and the app has access to it."),
            OnboardingData(id: 1, objectImageLight: "ObjectLight", objectImageDark: "ObjectDark", primaryText: "Locate the object", secondaryText: "After you open the camera, make sure to locate the object properly for the app to detect it."),
            OnboardingData(id: 2, objectImageLight: "CaptureLight", objectImageDark: "CaptureDark", primaryText: "Capture it", secondaryText: "Capture a photo or upload an image. This will enable the system to identify the object, along with a pronunciation feature.")
        ]
}


//struct Onboarding_Previews: PreviewProvider {
//    static var previews: some View {
////            LanguageSelection(
////                hasCompletedLanguageSelection: .constant(false),
////                selectedFirstOption: .constant(nil),
////                selectedSecondOption: .constant(nil),
////                placeholder: "Select Language",
////                firstOptions: DropdownMenuOption.testAllLanguage,
////                secondOptions: DropdownMenuOption.testAllLanguage
////            )
//    }
//}
