//
//  ContentView.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @StateObject var viewModel = ViewModel()
    @State private var isTapped: Bool = false
    
    let isForBD: Bool
    let isAbleToShowGreeting: Bool?
    
    let userDefault = UserDefaults.standard
    
    init(isForBD: Bool = false, isAbleToShowGreeting: Bool? = nil) {
        self.isForBD = isForBD
        self.isAbleToShowGreeting = isAbleToShowGreeting
    }
    
    var isFirstVisitCAPCountdown: Bool {
        let key = UserDefaultKeys.isFirstVisitCAPCountdown
        return (userDefault.object(forKey: key) as? Bool) ?? false
    }
    
    var body: some View {
        VStack {
            if isFirstVisitCAPCountdown {
                Text("EY吧我真的做ㄌ")
            }
            
            let condition = isAbleToShowGreeting == nil ? isAbleToShowGreeting(isForBD: isForBD): isAbleToShowGreeting!
            if condition {
                if !isTapped {
                    BirthdayCard(isTapped: $isTapped)
                        .transition(.offset(CGSize(width: 0, height: -20)))
                }else {
                    CardContent(isTapped: $isTapped)
                }
            }else {
                WaitingForBirthday(isForBirthday: isForBD)
                    .environmentObject(globalViewModel)
            }
        }
        .onAppear {
            if !isForBD {
                let key = UserDefaultKeys.isFirstVisitCAPCountdown
                ///UserDefaults hasn't stored this value
                if userDefault.object(forKey: key) == nil {
                    userDefault.set(true, forKey: key)
                }
            }
            viewModel.processInit()
        }
        .background {
            Color("Background")
        }
        .onDisappear {
            let key = UserDefaultKeys.isFirstVisitCAPCountdown
            ///UserDefaults has stored this value
            if let value = userDefault.object(forKey: key) as? Bool, value {
                userDefault.set(false, forKey: key)
            }
        }
        .navigationBarBackButtonHidden(isTapped)
    }
    
    func isAbleToShowGreeting(isForBD: Bool) -> Bool {
        let gapToCAP = globalViewModel.gapToCAP
        let isCAPPassed: Bool = globalViewModel.isDayPassed(gap: gapToCAP)
        let gapToHerBD = globalViewModel.gap
        let isHerBDPassed: Bool = globalViewModel.isDayPassed(gap: gapToHerBD)
        
        return isForBD ? isHerBDPassed: isCAPPassed
    }
}

struct NavigationButton: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding()
        .font(.headline)
        .bold()
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.05))
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalViewModel())
}

#Preview {
    Home()
        .environmentObject(GlobalViewModel())
}
