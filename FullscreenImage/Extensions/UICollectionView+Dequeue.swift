//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(ofType type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: String(describing: type.self), for: indexPath) as? T ?? T()
    }
    
    func registerCell<T: UICollectionViewCell>(ofType type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: type.self))
    }
}
