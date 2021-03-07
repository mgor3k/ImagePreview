//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

protocol ImageZoomPresenter {
    var frame: CGRect { get }
    var center: CGPoint { get }
    func addSubview(_ view: UIView)
}

extension UIView: ImageZoomPresenter {}
