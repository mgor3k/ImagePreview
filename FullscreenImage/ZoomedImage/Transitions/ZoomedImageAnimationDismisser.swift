//
//  Created by Maciej Gorecki on 07/03/2021.
//

import UIKit

protocol ZoomImageAnimationOrigin {
    var presentingOriginImageView: UIImageView { get }
    var presentingOriginFrame: CGRect { get }
}

protocol ZoomImageAnimationTarget {
    
}

class ZoomedImageAnimationDismisser: NSObject {
    enum TransitionType {
        case presenting, dismissing
    }
    
    let type: TransitionType
    
    var isPresenting: Bool {
        type == .presenting
    }
    
    init(type: TransitionType) {
        self.type = type
    }
}

extension ZoomedImageAnimationDismisser: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let gridViewController = (transitionContext.viewController(
            forKey: .to
        ) as! UINavigationController).children.first as! GridViewController
        
        let zoomedImageViewController = transitionContext.viewController(
            forKey: .from
        ) as! ZoomedImageViewController
        
        let imageView = zoomedImageViewController.imageView
        
        zoomedImageViewController.view.layoutIfNeeded()
        
        let targetFrame = gridViewController.view.convert(gridViewController.presentingFrame!, to: nil)
                
        let copyBackground = makeBackgroundFor(containerView)
        let copyImageView = makeImageViewCopy(imageView)
        
        containerView.addSubview(copyBackground)
        NSLayoutConstraint.snapView(copyBackground, to: containerView)
        containerView.addSubview(copyImageView)
                
        copyBackground.alpha = zoomedImageViewController.background.alpha
        zoomedImageViewController.view.alpha = 0

        gridViewController.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
            copyImageView.frame = targetFrame
            copyBackground.alpha = 0
            
        } completion: { _ in
            
            copyImageView.removeFromSuperview()
            copyBackground.removeFromSuperview()
            
            gridViewController.endAppearanceTransition()
            transitionContext.completeTransition(true)
        }
    }
}

private extension ZoomedImageAnimationDismisser {
    func makeBackgroundFor(_ view: UIView) -> UIView {
        let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }
    
    func makeImageViewCopy(_ imageView: UIImageView) -> UIView {
        let copyImageView = UIImageView()
        copyImageView.image = imageView.image
        copyImageView.contentMode = .scaleAspectFit
        copyImageView.frame = imageView.frame
        return copyImageView
    }
}
