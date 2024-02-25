//
//  CardContent.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI

struct CardContent: View {
    @Binding var isTapped: Bool
    
    @State private var tapTimes: Int = 0
    @State private var isBack: Bool = false
    @State private var isShowBackButton: Bool = false
    let userDefault = UserDefaults.standard
    static let key = UserDefaultKeys.cardVisitTimes
    let visitTimes = UserDefaults.standard.integer(forKey: key)
    
    let card = CardContext()
    
    var body: some View {
        ZStack {
            VStack {
                let count: Int = visitTimes >= 10 && visitTimes < 12 ? card.contentAfterVisit10Times.count: card.content.count
                
                ForEach(0..<count, id: \.self) { i in
                    let content = visitTimes >= 10 && visitTimes < 12 ? card.contentAfterVisit10Times[i]: card.content[i]
                    
                    if tapTimes >= i && tapTimes < i + 1 {
                        Text(content.text)
                            .font(.title)
                            .bold()
                            .transition(
                                .asymmetric(insertion: .move(edge: isBack ? .top: .bottom).combined(with: .opacity),
                                            removal: .move(edge: isBack ? .bottom: .top).combined(with: .opacity))
                            )
                        
                        if let image = content.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 400)
                                .clipShape(RoundedRectangle(cornerRadius: 16.0))
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
            .foregroundStyle(Color.black)
            
            VStack {
                HStack(spacing: 0) {
                    Color.black.opacity(visitTimes >= 10 && visitTimes < 12 ? 0.001: (tapTimes == 1 ? 0.3: 0.001))
                        .onTapGesture(perform: processBack)
                    
                    Color.black.opacity(visitTimes >= 10 && visitTimes < 12 ? 0.001: (tapTimes == 2 ? 0.3: 0.001))
                        .onTapGesture(perform: processContinue)
                }
                .ignoresSafeArea(edges: .all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if isShowBackButton {
                    Button(action: leaveCard) {
                        Text("Back")
                            .foregroundStyle(Color.white)
                            .bold()
                            .padding(16)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                            }
                    }
                }
            }
        }
        .onAppear {
            userDefault.set(visitTimes + 1, forKey: CardContent.key)
        }
    }
    
    func leaveCard() {
        withAnimation {
            isTapped = false
        }
    }
    
    func processContinue() {
        let canShowOtherContent: Bool = visitTimes >= 10 && visitTimes < 12
        withAnimation {
            isBack = false
            tapTimes += 1
            
            let count = (canShowOtherContent ? card.contentAfterVisit10Times: card.content).count
            isTapped = tapTimes <= count - 1
            if tapTimes <= count - 1 {
                if canShowOtherContent,
                   let isShowButton = card.contentAfterVisit10Times[tapTimes].isShowButton {
                    isShowBackButton = isShowButton
                }else if let isShowButton = card.content[tapTimes].isShowButton {
                    isShowBackButton = isShowButton
                }
            }
        }
    }
    
    func processBack() {
        let canShowOtherContent: Bool = visitTimes >= 10 && visitTimes < 12
        withAnimation {
            isBack = tapTimes == 0 ? false: true
            tapTimes -= tapTimes == 0 ? -1: 1
            isTapped = tapTimes != 0
            if let isShowButton = (canShowOtherContent ?
                                   card.contentAfterVisit10Times[tapTimes].isShowButton:
                                    card.content[tapTimes].isShowButton) {
                isShowBackButton = isShowButton
            }
        }
    }
}

extension Array where Element == CardContentItem {
    func find(text: String = "", image: Image = Image("GraduationTrip"), isShowButton: Bool? = nil) -> Int? {
        for (i, item) in self.enumerated() where item.text == text && item.image == image && item.isShowButton == isShowButton {
            return i
        }
        return nil
    }
}

#Preview {
    CardContent(isTapped: .constant(false))
}

#Preview {
    ContentView()
        .environmentObject(GlobalViewModel())
}
