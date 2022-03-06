//
//  DetailViewController.swift
//  usKet.Brandi
//
//  Created by 이경후 on 2022/03/06.
//

import UIKit

final class DetailViewController: UIViewController,ViewControllerType {
    
    private let scrollView: UIScrollView = Utility.configureScrollView()
    let imageView: UIImageView = Utility.configureImageView()
    let postInformView = PostInformView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        monitorNetwork()
    }
    
    func setConfigure() {
        title = "상세 정보"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setUI() {
        
        view.addSubview(scrollView)
        view.addSubview(postInformView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.getNavigationBarHeight()!)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(view.frame.height / 1.5)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        postInformView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
