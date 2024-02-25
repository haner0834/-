//
//  WaitingForBirthday.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI
import TipKit

struct WaitingForBirthday: View {
    let calendar = Calendar.current
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @EnvironmentObject var viewModel: GlobalViewModel
    
    @State private var tapTimes: Int = 0
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    let tip = RemindDonotOpenAppTip()
    
    var nonsense: String {
        let nonsenses = NonsenseContext.nonsenses
        
        for nonsense in nonsenses where nonsense.range ~= tapTimes { return nonsense.content }
        
        return ""
    }
    
    var stayNonesence: String {
        let stayTime = viewModel.stayTime
        let timeNonsenses = NonsenseContext.timeNonsenses
        
        for nonsense in timeNonsenses {
            if nonsense.range ~= stayTime {
                return nonsense.content
            }else if stayTime > 120 {
                return timeNonsenses[timeNonsenses.count - 1].content
            }
        }
        
        return ""
    }
    
    var body: some View {
        VStack {
            let gapToBD = viewModel.gap
            
            if tapTimes >= 1 && tapTimes < 5 {
                Text(String(tapTimes))
            }
            
            TipView(tip)
                .padding()
            
            Text("距離你生日還剩")
                .bold()
                .font(.title)
                .padding(.bottom, 30)
            
            LazyVGrid(columns: columns, spacing: 16) {
                Text(String(format: "%02d", gapToBD.day!))
                    .id("\(gapToBD.day!)day")
                    .clockTextAnimation()
                
                Text(":")
                
                Text(String(format: "%02d", gapToBD.hour!))
                    .id("\(gapToBD.hour!)hour")
                    .clockTextAnimation()
                
                Text(":")
                
                Text(String(format: "%02d", gapToBD.minute!))
                    .id("\(gapToBD.minute!)min")
                    .clockTextAnimation()
                
                Text(":")
                
                Text(String(format: "%02d", gapToBD.second!))
                    .id("\(gapToBD.second!)sec")
                    .clockTextAnimation()
            }
            .bold()
            .font(.title)
            .padding(.horizontal, 30)
            
            //to align the ":" and let it more beautifullllll :D
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                Text("DAY        ")
                Text("HOUR  ")
                Text("    MIN")
                Text("        SEC")
            }
            .padding(.horizontal, 30)
            
            Text(nonsense)
                .padding(20)
            
            Text(stayNonesence)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background))
        .foregroundStyle(Color.black)
        .onReceive(timer) { _ in
            viewModel.processUpdateGap()
        }
        .onTapGesture {
            if tapTimes < 55 {
                withAnimation {
                    tapTimes += 1
                }
            }else {
                let arr = [0]
                let _ = arr[1]
            }
        }
        .onAppear {
            Task { await RemindDonotOpenAppTip.event.donate() }
        }
    }
}

#Preview {
    WaitingForBirthday()
        .environmentObject(GlobalViewModel())
        .task {
            try? Tips.resetDatastore()
            
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}


extension View {
    @ViewBuilder
    func clockTextAnimation() -> some View {
        self
            .transition(
                .asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity))
            )
    }
}
