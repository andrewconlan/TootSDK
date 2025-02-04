// Created by konstantin on 05/11/2022.
// Copyright (c) 2022. All rights reserved.

import Foundation

public struct Pagination {
    public var maxId: String?
    public var minId: String?
    public var sinceId: String?
}

public extension Pagination {
    static let paginationTypes: [String] = ["prev", "next"]

    init(links: String) {
        let links = links.components(separatedBy: ",")

        let paginationQueryItems: [URLQueryItem] = links.compactMap({ link in
            let segments = link
                .condensed()
                .components(separatedBy: ";")
            let url = segments.first.map(trim(left: "<", right: ">"))
            let rel = segments.last?
                .replacingOccurrences(of: "\"", with: "")
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: "=")

            guard
                let validURL = url,
                let referenceKey = rel?.first, referenceKey == "rel",
                let referenceValue = rel?.last,
                Self.paginationTypes.contains(referenceValue),
                let queryItems = URLComponents(string: validURL)?.queryItems
            else {
                print("TootSDK: invalid pagination Link '\(link)'")
                return []
            }

            return queryItems
        }).reduce([], +)

        minId = paginationQueryItems.first { $0.name == "min_id" }?.value
        maxId = paginationQueryItems.first { $0.name == "max_id" }?.value
        sinceId = paginationQueryItems.first { $0.name == "since_id" }?.value
    }
}

func trim(left: Character, right: Character) -> (String) -> String {
    return { string in
        guard string.hasPrefix("\(left)"), string.hasSuffix("\(right)") else { return string }
        return String(string[string.index(after: string.startIndex)..<string.index(before: string.endIndex)])
    }
}
