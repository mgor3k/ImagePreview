//
//  Created by Maciej Gorecki on 06/03/2021.
//

import Foundation

class GridViewModel {
    private(set) var items: [GridItem]
    
    var title: String {
        "Explore"
    }
    
    init() {
        items = [
            .init(imageUrl: "1"),
            .init(imageUrl: "2"),
            .init(imageUrl: "3")
        ]
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> GridItem {
        items[indexPath.row]
    }
}
