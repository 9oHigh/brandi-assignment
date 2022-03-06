//
//  ViewController.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController,ViewControllerType {
    
    let searchController : UISearchController = {
        let searchController = Utility.configureSearchController()
        return searchController
    }()
    let ImageCollectionView : UICollectionView = {
        let collectionView = Utility.configureCollectionView()
        return collectionView
    }()
    lazy var informView = InformView()
    
    private var isEnd : Bool = true
    private var indicatorView: ImageCollectionFooterView?
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Network
        monitorNetwork()
    }
    
    func setConfigure(){
        // ViewController Config
        title = "Daum Images"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        
        // ImageCollectionView Config
        ImageCollectionView.delegate = self
        ImageCollectionView.dataSource = self
        ImageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.cellIdentifier)
        ImageCollectionView.register(ImageCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ImageCollectionFooterView.footerIdentifier)
    }
    
    func setUI(){
        
        view.addSubview(ImageCollectionView)
        ImageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding(){
        // Search: after a second
        searchController.searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance) // Searchable when scrolling
            .subscribe{ [weak self] text in 
                self?.viewModel.fetchImages(query: text, onCompletion: { [weak self] images in
                    guard let images = images else { return }
                    
                    if images.documents.count == 0 {
                        self?.alertEmpty()
                    } else {
                        self?.isEnd = false
                        self?.removeInform()
                    }
                })
                
            }
            .disposed(by: disposeBag)
        
        // Cancel Search: Clear Model
        searchController.searchBar.rx.cancelButtonClicked
            .observe(on: MainScheduler.instance)
            .subscribe({ [weak self] _ in
                self?.viewModel.clearItems {
                    self?.ImageCollectionView.reloadData()
                    self?.informView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        // Network ErrorMessage
        viewModel.errorMessage.bind { [weak self] text in
            text.isEmpty ? () : self?.showToast(message: text)
        }
    }
    
    // Images are not empty
    private func removeInform(){
        informView.removeFromSuperview()
        DispatchQueue.main.async {
            self.ImageCollectionView.reloadData()
            self.ImageCollectionView.setContentOffset(CGPoint(x: 0, y: -self.getNavigationBarHeight()!), animated: true)
        }
    }
    
    // Images are empty
    private func alertEmpty(){
        isEnd = true
        self.ImageCollectionView.reloadData()
        informView.setInformText(message: "검색결과가 없습니다.\n다른 키워드를 입력해보세요!")
        view.addSubview(informView)
        informView.snp.makeConstraints { make in
            make.top.equalTo(getNavigationBarHeight()!)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
extension SearchViewController : UICollectionViewDataSource,UICollectionViewDelegate{
    
    // MARK: - Cell
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.cellIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let path = viewModel.items.documents
        let url = URL(string: path[indexPath.row].thumbnailURL)
        cell.imageView.kf.indicator?.startAnimatingView()
        cell.imageView.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailViewController = DetailViewController()
        let path = viewModel.items.documents[indexPath.row]
        let url = URL(string: path.imageURL)
        
        detailViewController.imageView.kf.setImage(with: url)
        detailViewController.postInformView.siteLabel.text = "제공: " + path.displaySitename
        detailViewController.postInformView.dateLabel.text = "업로드: " + Utility.prettierDate(path.datetime)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItem - viewModel.numberOfItem / 10 && !isEnd {
            DispatchQueue.main.async {
                self.viewModel.addImages { [weak self] _ , isContinue in
                    guard let isContinue = isContinue else {
                        return
                    }
                    self?.isEnd = isContinue ? true : false
                    self?.ImageCollectionView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Indicator
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageCollectionFooterView.footerIdentifier, for: indexPath) as? ImageCollectionFooterView {
                indicatorView = footerView
                return footerView
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            // -1 : Default Value has a Model(nil)
            viewModel.numberOfItem - 1 == 0 ? indicatorView?.indicator.stopAnimating(): indicatorView?.indicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            indicatorView?.indicator.stopAnimating()
        }
    }
    
}
extension SearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.preferredCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.interval
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.interval
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isEnd ? CGSize.zero : CGSize(width: collectionView.bounds.size.width, height: 55)
    }
}
