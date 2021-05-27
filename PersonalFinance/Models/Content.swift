//
//  ExploreTheApp.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 26.05.21.
//

struct Content {
    let backgroundImage: String
    let title: String
    let description: String
}

extension Content {
    static func getContents() -> [Content] {
        var pageViewDescriptions = [Content]()
        
        for index in 0..<ContentDataManager.shared.titles.count {
            let pageViewDescription = Content(
                backgroundImage: ContentDataManager.shared.backgRoundImages[index],
                title: ContentDataManager.shared.titles[index],
                description: ContentDataManager.shared.descriptions[index]
            )
            pageViewDescriptions.append(pageViewDescription)
        }
        return pageViewDescriptions
    }
}



