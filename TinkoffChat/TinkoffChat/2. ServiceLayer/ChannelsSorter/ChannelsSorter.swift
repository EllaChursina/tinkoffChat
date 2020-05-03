//
//  ChannelsSorter.swift
//  TinkoffChat
//
//  Created by Элла Чурсина on 02.05.2020.
//  Copyright © 2020 Элла Чурсина. All rights reserved.
//

import Foundation

protocol IChannelsSorter {
    func sort(_ channels: [Channel], isActive: Bool) -> [Channel]
}

final class ChannelsSorter: IChannelsSorter {
    func sort(_ channels: [Channel], isActive: Bool) -> [Channel] {
        var sortedChannels = channels.filter({ return $0.isActive == isActive})
        sortedChannels = sortedChannels.sorted(by: {$0.lastActivity > $1.lastActivity})
        return sortedChannels
    }
}


