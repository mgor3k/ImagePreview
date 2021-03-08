//
//  Created by Maciej Gorecki on 07/03/2021.
//

import UIKit

protocol ImagePreviewAnimationOrigin: UIViewController {
    var presentingOriginImageView: UIImageView? { get }
    var presentingOriginFrame: CGRect? { get }
}

class ImagePreviewTransition: NSObject {
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

extension ImagePreviewTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let origin = getOriginViewController(from: transitionContext) else {
            return assertionFailure("Origin controller doesn't conform to ImagePreviewAnimationOrigin")
        }
        
        guard let target = getTargetController(from: transitionContext) else {
            return assertionFailure("Origin controller doesn't conform to ImagePreviewAnimationTarget")
        }
        
        let imageView = isPresenting ?
            origin.presentingOriginImageView : target.imageView
        
        let targetFrame: CGRect
        if isPresenting {
            target.view.layoutIfNeeded()
            targetFrame = target.imageView.frame
        } else {
            targetFrame = origin.view.convert(origin.presentingOriginFrame!, to: nil)
        }
                
        let copyBackground = makeBackgroundFor(containerView)
        let copyImageView = makeImageViewCopy(imageView!)
        
        containerView.addSubview(copyBackground)
        NSLayoutConstraint.snapView(copyBackground, to: containerView)
        containerView.addSubview(copyImageView)
    
        copyBackground.alpha = isPresenting ? 0 : target.background.alpha
        
        // Hide the entire view - animation will take the rest
        if !isPresenting {
            target.view.alpha = 0
        }
        
        let animatingVC: UIViewController = isPresenting ? target : origin
        
        animatingVC.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
            copyImageView.frame = targetFrame
            copyImageView.layer.cornerRadius = self.isPresenting ? 0 : 16
            copyBackground.alpha = self.isPresenting ? 1 : 0
            
        } completion: { [unowned self] _ in
            
            copyImageView.removeFromSuperview()
            copyBackground.removeFromSuperview()
            
            if self.isPresenting {
                containerView.addSubview(target.view)
            }
            
            animatingVC.endAppearanceTransition()
            transitionContext.completeTransition(true)
        }
    }
}

private extension ImagePreviewTransition {
    func makeBackgroundFor(_ view: UIView) -> UIView {
        let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
    }
    
    func makeImageViewCopy(_ imageView: UIImageView) -> UIView {
        let copyImageView = UIImageView()
        copyImageView.image = imageView.image
        copyImageView.contentMode = .scaleAspectFit
        copyImageView.layer.cornerRadius = isPresenting ? 16 : 0
        copyImageView.clipsToBounds = true
        copyImageView.frame = isPresenting ? imageView.convert(imageView.frame, to: nil) : imageView.frame
        return copyImageView
    }
    
    func getOriginViewController(
        from transitionContext: UIViewControllerContextTransitioning) -> ImagePreviewAnimationOrigin? {
        let vc = transitionContext.viewController(forKey: isPresenting ? .from : .to)
        
        if let vc = vc as? ImagePreviewAnimationOrigin {
            return vc
        }else if let vc = (vc as? UINavigationController)?.children.last as? ImagePreviewAnimationOrigin {
            return vc
        }
        
        return nil
    }
    
    func getTargetController(
        from transitionContext: UIViewControllerContextTransitioning) -> ImagePreviewViewController? {
        let vc = transitionContext.viewController(forKey: isPresenting ? .to : .from)
        return vc as? ImagePreviewViewController
    }
}
