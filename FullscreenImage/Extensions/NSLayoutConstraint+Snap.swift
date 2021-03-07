//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

extension NSLayoutConstraint {
    static func snapView(_ view: UIView, to toView: UIView) {
        activate([
            view.topAnchor.constraint(equalTo: toView.topAnchor),
            view.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: toView.bottomAnchor)
        ])
    }
}
