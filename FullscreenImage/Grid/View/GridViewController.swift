//
//  Created by Maciej Gorecki on 06/03/2021.
//

import UIKit

class GridViewController: ViewController, ZoomImageAnimationOrigin {
    private let collectionView = FlowLayoutCollectionView()
    private let viewModel: GridViewModel
        
    weak var presentingOriginImageView: UIImageView?
    var presentingOriginFrame: CGRect?
    
    init(viewModel: GridViewModel = .init()) {
        self.viewModel = viewModel
        super.init()
        
        self.title = viewModel.title
    }
    
    override func loadView() {
        super.loadView()
        
        setupCollectionView()
    }
}

private extension GridViewController {
    func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 36, left: 16, bottom: 36, right: 16)
        
        collectionView.registerCell(ofType: GridCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        NSLayoutConstraint.snapView(collectionView, to: view)
    }
    
    func zoomImage(fromCell cell: GridCell) {
        let imageView = cell.imageView
        guard let image = imageView.image else {
            return
        }
        
        cell.isZoomed = true
        
        presentingOriginImageView = imageView
        presentingOriginFrame = imageView.convert(imageView.frame, to: nil)
        
        let vc = ZoomedImageViewController(image: image)
        vc.completion = { [weak cell] in cell?.isZoomed = false }
        present(vc, animated: true)
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: GridCell.self, for: indexPath)
        let item = viewModel.itemForIndexPath(indexPath)
        if let image = UIImage(named: item.imageUrl) {
            cell.setImage(image)
        }
        return cell
    }
}

extension GridViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GridCell {
            zoomImage(fromCell: cell)
        }
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = collectionView.contentInset.left + collectionView.contentInset.right
        let width = (collectionView.frame.width - insets) / 2
        return .init(width: width - 8, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}
