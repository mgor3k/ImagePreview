//
//  Created by Maciej Gorecki on 07/03/2021.
//

import UIKit

class ZoomedImageAnimationPresenter: NSObject {}

extension ZoomedImageAnimationPresenter: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let gridViewController = (transitionContext.viewController(
            forKey: .from
        ) as! UINavigationController).children.first as! GridViewController
        
        let zoomedImageViewController = transitionContext.viewController(
            forKey: .to
        ) as! ZoomedImageViewController
        
        let imageView = gridViewController.presentingImageView!
        
        zoomedImageViewController.view.layoutIfNeeded()
        
        let targetFrame = zoomedImageViewController.imageView.frame
                
        let copyBackground = makeBackgroundFor(containerView)
        let copyImageView = makeImageViewCopy(imageView)
        
        containerView.addSubview(copyBackground)
        NSLayoutConstraint.snapView(copyBackground, to: containerView)
        containerView.addSubview(copyImageView)
                
        copyBackground.alpha = 0
        
        zoomedImageViewController.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
            copyImageView.frame = targetFrame
            copyBackground.alpha = 1
        } completion: { _ in
            
            copyImageView.removeFromSuperview()
            copyBackground.removeFromSuperview()
            
            containerView.addSubview(zoomedImageViewController.view)
            
            zoomedImageViewController.endAppearanceTransition()
            transitionContext.completeTransition(true)
        }
    }
}

private extension ZoomedImageAnimationPresenter {
    func makeBackgroundFor(_ view: UIView) -> UIView {
        let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }
    
    func makeImageViewCopy(_ imageView: UIImageView) -> UIView {
        let copyImageView = UIImageView()
        copyImageView.image = imageView.image
        copyImageView.contentMode = .scaleAspectFit
        copyImageView.frame = imageView.convert(imageView.frame, to: nil)
        return copyImageView
    }
}
