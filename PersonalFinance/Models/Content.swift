struct Content {
    let backgroundImage: String
    let title: String
    let description: String
}

extension Content {
    static func getContents() -> [Content] {
        var pageViewDescriptions = [Content]()
        
        for index in 0..<ContentManager.shared.titles.count {
            let pageViewDescription = Content(
                backgroundImage: ContentManager.shared.backgRoundImages[index],
                title: ContentManager.shared.titles[index],
                description: ContentManager.shared.descriptions[index]
            )
            pageViewDescriptions.append(pageViewDescription)
        }
        return pageViewDescriptions
    }
}



