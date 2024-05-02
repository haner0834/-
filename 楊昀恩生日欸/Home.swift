//
//  Home.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/4/21.
//

import SwiftUI

struct Home: View {
    @State private var isCountdownForBD = false
    @State private var isTapped: Bool = true
    @State private var isAbleToShowGreeting = false
    
    @EnvironmentObject var globalViewModel: GlobalViewModel
    
    @State private var displayType: [DisplayType] = []
    @State private var scrollID: DisplayType? = .countdown
    
    ///Record how many times screen has been tapped
    @State private var tapTimes: Int = 0
    var nonsense: String {
        let nonsenses = NonsenseContext.smartHumanSaid
        
        for nonsense in nonsenses where nonsense.range ~= tapTimes { return nonsense.content }
        
        return ""
    }
    
    @State private var isCAPCountdownEnabled = true
    let isGraduationPassed: Bool
    
    let graduationDate = DateComponents(year: 2024, month: 6, day: 8, hour: 0, minute: 0, second: 0)
    let calendar = Calendar.current
    let userDefault = UserDefaults.standard
    
    init() {
        let isDayPassed = graduationDate.isPassed()
        isGraduationPassed = isDayPassed
    }
    
    var body: some View {
        NavigationStack(path: $displayType) {
            VStack {
                Text(nonsense)
                    .bold()
                    .foregroundStyle(.black)
                    .clockTextAnimation()
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(DisplayType.allCases, id: \.self) { type in
                            VStack {
                                ScrollViewContent(type)
                            }
                            .foregroundStyle(.black)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 16)
                            .onTapGesture {
                                displayType = [type]
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $scrollID)
                .scrollIndicators(.hidden)
                .navigationDestination(for: DisplayType.self) { displayType in
                    DestinationView(displayType)
                }
                .onChange(of: isTapped) { oldValue, newValue in
                    if let first = displayType.first,
                       !newValue && ((first == .newThing || first == .memories) || (first == .graduationBook && !isGraduationPassed)) {
                        displayType = []
                    }
                }
                .onAppear {
                    isTapped = true
//                    
                    let key = UserDefaultKeys.isCAPCountdownEnabled
                    isCAPCountdownEnabled = (userDefault.object(forKey: key) as? Bool) ?? false
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        displayType = [.countdown]
                    }
                }
                .animation(.easeInOut, value: isTapped)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .onTapGesture {
                withAnimation {
                    tapTimes += 1
                }
            }
        }
    }
    
    func processDisappear() {
        let key = UserDefaultKeys.isCAPCountdownEnabled
        if userDefault.object(forKey: key) as? Bool == nil {
            userDefault.set(true, forKey: key)
            isCAPCountdownEnabled = true
            withAnimation {
                scrollID = .countdown
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.displayType = [.countdown]
            }
        }
    }
    
    @ViewBuilder
    func DestinationView(_ type: DisplayType) -> some View {
        switch type {
        case .birthdayGreeting:
            ContentView(isForBD: !isCAPCountdownEnabled, isAbleToShowGreeting: true)
                .onAppear { isTapped = false }
        case .countdown:
            let isForBD = !isCAPCountdownEnabled
            ContentView(isForBD: isForBD)
                .environmentObject(GlobalViewModel())
        case .newThing:
            CardContent(isTapped: $isTapped, forContent: .newNonsence)
                .onDisappear(perform: processDisappear)
                .navigationBarBackButtonHidden(isTapped)
        case .graduationBook:
            if isGraduationPassed {
                BookView()
            }else {
                CardContent(isTapped: $isTapped, forContent: .noGraduation)
            }
        case .memories:
            if isGraduationPassed {
                CardContent(isTapped: $isTapped, forContent: .memories)
                    .navigationBarBackButtonHidden(true)
            }else {
                CardContent(isTapped: $isTapped, forContent: .noGraduation2)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    @ViewBuilder
    func ScrollViewContent(_ type: DisplayType) -> some View {
        switch type {
        case .birthdayGreeting:
            BirthdayCardView(flapHeight: 113)
        case .countdown:
            Image(systemName: "clock.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 250)
        case .newThing:
            Image("HangyodoSanrio")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .shadow(color: .yellow.opacity(0.3), radius: 5)
        case .graduationBook:
            OpenableBook { size in
                
            } front: { size in
                CoverPage(size)
            } insideLeft: { size in
                
            } insideRight: { size in
                
            }
            .opacity(isGraduationPassed ? 1: 0.3)
            .overlay {
                if !isGraduationPassed {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.white)
                        .padding(20)
                        .padding(.bottom, 5)
                        .background(Circle())
                }
            }
        case .memories:
            Image(.sharkMelon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 350)
                .clipShape(.rect(cornerRadius: 16))
        }
        
        Text(type.text)
            .font(.title2)
            .bold()
            .padding()
    }
}

#Preview {
    Home()
        .environmentObject(GlobalViewModel())
}
