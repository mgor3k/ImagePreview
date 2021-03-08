//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

extension UIView {
    func popAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = 0.3
        animation.values = [0.97, 1.0, 1.0, 1.0]
        animation.keyTimes = [0, 0.25, 0.50, 0.75]
        self.layer.add(animation, forKey: nil)
    }
}
