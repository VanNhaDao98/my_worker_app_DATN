//
//  CreateWorkerAvatarViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 14/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

class CreateWorkerAvatarViewController: BaseViewController, MVVMViewController {
    
    typealias VM = CreateWorkerAvatarViewModel
    
    var viewModel: CreateWorkerAvatarViewModel
    
    private var scrollView = UIScrollView()
    private var mainStackView = UIStackView()
    private var continueButton = Button()

    private var chooseImageView = ChooseImageView()
    
    private var didConfirmImage: (Worker) -> Void
    
    let imagePicker = UIImagePickerController()
    
    init(viewModel: CreateWorkerAvatarViewModel,
         didConfirmImage: @escaping (Worker) -> Void) {
        self.viewModel = viewModel
        self.didConfirmImage = didConfirmImage
        super.init()
        useContentView = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func setupView() {
        imagePicker.delegate = self
        
        mainStackView.axis = .vertical
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        mainStackView.spacing = 8
        
        contentView.addSubview(scrollView)
        enableHeaderView(pintoView: scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        scrollView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        let headerView = CreateWorkerHeaderView()
        headerView.setValue(title: "Ảnh đại diện",
                            subTitle: "Tải lên ảnh chân dung của bạn, ảnh rõ nét sẽ tạo uy tín và khiến khách hàng tin tưởng hơn.")
        
        mainStackView.addArrangedSubview(headerView)
        mainStackView.addArrangedSubview(chooseImageView)
        chooseImageView.chooseImageAction = { [weak self] in
            self?.viewModel.send(.tapChooseImage)
        }
        
        continueButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }
           
        continueButton.squircle(radius: 24)
        continueButton.title = "Hoàn thành"
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
            $0.height.equalTo(48)
        }
        
        title = "Tạo tài khoản"
        
    }
    
    func bind(viewModel: CreateWorkerAvatarViewModel) {
        viewModel.config(.init(didConfirmImage: { [weak self] account in
            self?.didConfirmImage(account)
            self?.navigationController?.popViewController(animated: true)
        }, image: { [weak self] image in
            self?.chooseImageView.updateView(image: image)
            self?.continueButton.isEnabled = image != nil
        }, chooseImage: { [weak self] in
            self?.chooseImage()
        }))
        viewModel.send(.viewDidLoad)
    }
    
    private func chooseImage() {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }
}

extension CreateWorkerAvatarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.viewModel.send(.updateImage(image))
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
