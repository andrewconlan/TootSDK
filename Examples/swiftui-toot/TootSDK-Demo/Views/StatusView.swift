//
//  StatusView.swift
//  SwiftUI-Toot
//
//  Created by dave on 17/12/22.
//

import SwiftUI
import TootSDK

struct StatusView: View {
    var status: Status
    var attributed: Bool
    
    var displayStatus: Status {
        return status.reblog ?? self.status
    }
    
    var reblog: Bool {
        return status.reblog != nil
    }
    
    var body: some View {
        VStack {
            if reblog {
                HStack {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.3.trianglepath")
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 80, height: 80)
                    
                    Text((status.account.displayName ?? "") + " boosted")
                }
            }
            
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: displayStatus.account.avatar)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 80)
                
                VStack {
                    HStack {
                        Text(displayStatus.account.displayName ?? "?")
                            .font(.caption.bold())
                        Text(displayStatus.account.username)
                            .font(.caption)
                    }
                    
                    if attributed, let attributedText = displayStatus.content?.attributedString {
                        Text(AttributedString(attributedText))
                    } else {
                        Text(displayStatus.content?.plainContent ?? "")
                    }
                }
            }
        }
    }
}
