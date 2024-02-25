//
//  WaitingForBirthdayModel.swift
//  楊昀恩生日欸
//
//  Created by Andy Lin on 2024/2/21.
//

import Foundation
import SwiftUI

struct NonsenseValue {
    let content: String
    let range: Range<Int>
}

final class NonsenseContext {
    static private let 彼女への言葉 = ["""
                    好啦你應該是看不到這個
                    ：）
                    我好累
                    ㄍㄢ 做這個又沒什麼用==
                    あー、これ、俺の気持ちだけど、
                    好きなんだよ
                    あー、なんだかなぁ
                    もし、これ見たら、
                    マジで好きで、付き合いたいって
                    """,
                    """
                    「好きな人の好きな人なりたい」っで思うんだ
                    まあ、やっぱ無理だよね：）
                    """]
    
    static let nonsenses: [NonsenseValue] = [
        NonsenseValue(content: "不要再點了啦都要被你點壞了:D", range: 7..<10),
        NonsenseValue(content: "你是以為一直點就會跑出什麼嗎？猜錯ㄌ：）", range: 11..<15),
        NonsenseValue(content: "他會痛啦 不要那麼無情._.", range: 16..<20),
        NonsenseValue(content: "跟你講個小秘密好了\n打開這個app幾次我當天12.就發送幾條訊息給你\n管他什麼關網路", range: 25..<30),
        NonsenseValue(content: "喔對要記得如果要收到通知的話不能再12.的時候開app", range: 30..<33),
        NonsenseValue(content: "你怎麼還沒放棄ㄚ\n好啦在你那麼努力點他的份上，你還是什麼都沒得到:D", range: 34..<43),
        NonsenseValue(content: "好啦這次是真ㄉ\n你再點後面是真的沒有東西了啦\n不要不聽勸:D到時候直接讓你閃退ㄛ", range: 50..<55),
        NonsenseValue(content: 彼女への言葉[0], range: 100..<101),
        NonsenseValue(content: 彼女への言葉[1], range: 101..<102)
    ]
    
    static let timeNonsenses: [NonsenseValue] = [
        NonsenseValue(content: "你這麼喜歡這個東西嗎:D\n還留在這裡那麼久", range: 30..<60),
        NonsenseValue(content: "你都待在這裡那麼久了，很閒是8️⃣", range: 60..<90),
        NonsenseValue(content: "你要在這裡多久：）\n這麼愛這個就講唄待這麼久要幹嘛ㄇ", range: 90..<120)
    ]
}
