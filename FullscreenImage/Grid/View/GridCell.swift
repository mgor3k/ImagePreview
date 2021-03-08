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
        setupShadow()
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
        overlayView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        overlayView.layer.cornerRadius = 16
        overlayView.clipsToBounds = true
        overlayView.isHidden = true
        
        contentView.addSubview(overlayView)
        NSLayoutConstraint.snapView(overlayView, to: imageView)
    }
    
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 15
        layer.shadowOffset = .init(width: 10, height: 10)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
    }
}
