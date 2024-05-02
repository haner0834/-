//
//  WaitingForBirthday.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/4.
//

import SwiftUI
import TipKit

struct WaitingForBirthday: View {
    let isForBirthday: Bool
    
    init(isForBirthday: Bool = true) {
        self.isForBirthday = isForBirthday
    }
    
    let calendar = Calendar.current
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @EnvironmentObject var viewModel: GlobalViewModel
    
    @State private var tapTimes: Int = 0
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    let tip = RemindDonotOpenAppTip()
    
    var nonsense: String {
        let nonsenses = NonsenseContext.newNonsenses
        
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
            let gap = isForBirthday ? viewModel.gap: viewModel.gapToCAP
            
            if tapTimes >= 1 && tapTimes < 5 {
                Text(String(tapTimes))
            }
            
            TipView(tip)
                .padding()
            
            Text("距離\(isForBirthday ? "你生日": "會考")還剩")
                .bold()
                .font(.title)
                .padding(.bottom, 30)
            
            LazyVGrid(columns: columns) {
                ForEach(0..<2) { i in
                    Text("")
                }
                Text(String(format: "%02d", gap.year!))
                    .id("\(gap.year!)year")
                Text(":")
                Text(String(format: "%02d", gap.month!))
                    .id("\(gap.month!)month")
                ForEach(0..<4) { i in
                    Text("")
                }
                Text("YEA")
                    .font(.body)
                    .fontWeight(.regular)
                Text("")
                Text("MON")
                    .font(.body)
                    .fontWeight(.regular)
            }
            .bold()
            .font(.title)
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            
            LazyVGrid(columns: columns, spacing: 16) {
                Text(String(format: "%02d", gap.day!))
                    .id("\(gap.day!)day")
                    .clockTextAnimation()
                
                Text(":")
                
                Text(String(format: "%02d", gap.hour!))
                    .id("\(gap.hour!)hour")
                    .clockTextAnimation()
                
                Text(":")
                
                Text(String(format: "%02d", gap.minute!))
                    .id("\(gap.minute!)min")
                    .clockTextAnimation()
                
                Text(":")
                
                Text(String(format: "%02d", gap.second!))
                    .id("\(gap.second!)sec")
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
            viewModel.processUpdateGap(forGap: viewModel.gap)
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
    WaitingForBirthday(isForBirthday: false)
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
