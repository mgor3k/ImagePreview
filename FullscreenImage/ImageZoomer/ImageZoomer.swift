//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

class ImageZoomer {
    private let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private let imageView: UIImageView
    private let startingFrame: CGRect
    
    private weak var originView: UIView?
    private var presenterFrame: CGRect?
        
    init(ofImageView originView: UIImageView) {
        self.originView = originView
        
        startingFrame = originView.convert(originView.frame, to: nil)
        
        imageView = UIImageView(frame: startingFrame)
        imageView.image = originView.image
        imageView.contentMode = .scaleAspectFit
        
        setupGestureRecognizers()
    }
    
    func show(on presenter: ImageZoomPresenter) {
        self.presenterFrame = presenter.frame
        
        background.frame = presenter.frame
        background.alpha = 0
        
        [background, imageView].forEach {
            presenter.addSubview($0)
        }
        
        let height = min(startingFrame.height / startingFrame.width * presenter.frame.width, presenter.frame.height - 64)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.background.alpha = 1
            self.imageView.frame = .init(x: 0, y: 0, width: presenter.frame.width, height: height)
            self.imageView.center = presenter.center
        })
    }
}

private extension ImageZoomer {
    func setupGestureRecognizers() {
        imageView.isUserInteractionEnabled = true
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    @objc func dismiss() {
        // Moves the fullscreen image back to its origin position
        // Starts to remove blurred background
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseOut) {
            self.imageView.frame = self.startingFrame
            self.background.alpha = 0
        }
        
        // Starts removing the images after a slight delay
        UIView.animate(
            withDuration: 0.2,
            delay: 0.2,
            options: []) {
            self.imageView.alpha = 0
        } completion: { [weak self] _ in
            self?.imageView.removeFromSuperview()
            self?.background.removeFromSuperview()
        }
        
        // Avoids the sudden transition to origin image
        // Imo looks better this way
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.imageView.isHidden = true
            self?.originView?.popAnimation()
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let height = presenterFrame?.height, height > 0 else { return }
        var translation = gesture.translation(in: nil)
        translation = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        imageView.center = translation
        
        // translation.y is currently between 0 (top) and 1 (bottom), we need to translate it to become 1 in the middle of the screen, to lower the alpha in both directions
        var result = (translation.y / height) / 0.5
        result = result > 1 ? result - 1 : 1 - result
        background.alpha = 1 - result
        
        // divide the result for slower transform
        imageView.transform = .init(scaleX: 1 - (result / 2), y: 1 - (result / 2))
        
        gesture.setTranslation(.zero, in: nil)
        
        if gesture.state == .ended {
            dismiss()
        }
    }
}
