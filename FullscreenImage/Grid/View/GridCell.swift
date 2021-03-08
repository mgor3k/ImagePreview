//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

class GridCell: CollectionViewCell {
    let imageView = UIImageView()
    let overlayView = UIView()
    
    var isZoomed: Bool {
        get { overlayView.isHidden }
        set { overlayView.isHidden = !newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupOverlay()
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

private extension GridCell {
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.snapView(imageView, to: contentView)
    }
    
    func setupOverlay() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .lightGray
        overlayView.isHidden = true
        
        contentView.addSubview(overlayView)
        NSLayoutConstraint.snapView(overlayView, to: imageView)
    }
}
