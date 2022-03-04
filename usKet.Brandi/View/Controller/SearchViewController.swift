//
//  ViewController.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/04.
//

import UIKit
import Kingfisher

final class SearchViewController: UIViewController {
    
    lazy var searchController : UISearchController = {
        let searchController = Utility.configureSearchController()
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    lazy var informView = InformView()
    
    lazy var ImageCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    private func setConfigure(){
        
        title = "Brandi"
        view.backgroundColor = .white
        navigationItem.searchController = searchController
    }
    
    private func setUI(){
        
        view.addSubview(ImageCollectionView)
        
        ImageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func binding(){
        viewModel.items.bind { [weak self] images in
            if images.documents.count == 0 {
                self?.informEmpty()
            } else {
                self?.removeInform()
                DispatchQueue.main.async {
                    self?.ImageCollectionView.reloadData()
                }
            }
        }
        
        viewModel.query.bind { <#String#> in
            <#code#>
        }
        
        viewModel.page.bind { <#Int#> in
            <#code#>
        }
        
        viewModel.errorMessage.bind { <#String#> in
            <#code#>
        }
    }
    
    private func informEmpty(){
        informView.setInformText(message: "검색결과가 없습니다.\n다른 키워드를 입력해보세요!")

        view.addSubview(informView)
        informView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func removeInform(){
        informView.removeFromSuperview()
    }
}
extension SearchViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let path = viewModel.items.value.documents
        let url = URL(string: path[indexPath.item].thumbnailURL)
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
}
extension SearchViewController : UISearchBarDelegate {
    
}
