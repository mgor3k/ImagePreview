//
//  Created by Maciej Gorecki on 07/03/2021.
//

import UIKit

class ZoomedImageViewController: ViewController, ZoomImageAnimationTarget {
    let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let imageView = UIImageView()
    
    var completion: (() -> Void)?
    
    init(image: UIImage) {
        super.init()
        modalPresentationStyle = .overFullScreen
        imageView.image = image
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        completion?()
    }
}

private extension ZoomedImageViewController {
    func setup() {
        addSubviews()
        setupBackground()
        setupImageView()
        setupGestureRecognizers()
        transitioningDelegate = self
    }
    
    func addSubviews() {
        view.addSubview(background)
        view.addSubview(imageView)
    }
    
    func setupBackground() {
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.snapView(background, to: view)
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupGestureRecognizers() {
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    @objc
    func close() {
        dismiss(animated: true)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard view.frame.height > 0 else { return }
        var translation = gesture.translation(in: nil)
        translation = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        imageView.center = translation
        
        // translation.y is currently between 0 (top) and 1 (bottom), we need to translate it to become 1 in the middle of the screen, to lower the alpha in both directions
        var result = (translation.y / view.frame.height) / 0.5
        result = result > 1 ? result - 1 : 1 - result
        background.alpha = 1 - result
        
        // divide the result for slower transform
        imageView.transform = .init(scaleX: 1 - (result / 2), y: 1 - (result / 2))
        
        gesture.setTranslation(.zero, in: nil)
        
        if gesture.state == .ended {
            dismiss(animated: true)
        }
    }
}

extension ZoomedImageViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ZoomedImageTransition(type: .presenting)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ZoomedImageTransition(type: .dismissing)
    }
}
