//
//  CreateMaretialViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 13/11/2023.
//

import UIKit
import UIComponents
import Presentation
import Utils

class CreateMaterialViewController: BaseViewController, MVVMViewController {
    typealias VM = CreateMaretialViewModel
    
    var viewModel: CreateMaretialViewModel
    
    private var confirmButton = Button().makePrimary()
    private var addButton = Button()
    
    private var tableView = BaseTableView(frame: .zero, style: .plain)
    
    private var didCreateMaterial: () -> Void
    
    let imagePicker = UIImagePickerController()
    
    init(viewModel: CreateMaretialViewModel, didCreateMaterial: @escaping () -> Void) {
        self.viewModel = viewModel
        self.didCreateMaterial = didCreateMaterial
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
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CreateMaterialCell.nib(in: .main), forCellReuseIdentifier: CreateMaterialCell.reuseId)
        
        isHiddenNavigationBar = false
        navigationItem.title = "Thêm vật liệu"
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [addButton, confirmButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 12
        buttonStackView.distribution = .fillEqually
        
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(48)
        }
        
        addButton.config.style = .outline
        addButton.config.primaryColor = .primary
        addButton.title = "Thêm vật liệu"
        addButton.squircle(radius: 24)
        
        confirmButton.title = "Xác nhận"
        confirmButton.squircle(radius: 24)
        
        confirmButton.action = { [weak self] in
            self?.viewModel.send(.confirm)
        }
        
        addButton.action = { [weak self] in
            self?.viewModel.send(.addMaterial)
        }
    }
    
    func bind(viewModel: CreateMaretialViewModel) {
        viewModel.config(.init(items: { [weak self] material in
            self?.tableView.reloadData()
        }, loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view)
        }, didCrateMaterial: { [weak self] in
            self?.didCreateMaterial()
            self?.navigationController?.popViewController(animated: true)
        }, pickerImage: { [weak self] in
            self?.chooseImage()
        }))
        viewModel.send(.viewDidLoad)
    }
    
    private func chooseImage() {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }

}

extension CreateMaterialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.materialValue.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: CreateMaterialCell.self, for: indexPath)
        cell.action = .init(chooseImage: { [weak self] in
            self?.viewModel.send(.chooseImage(indexPath.row))
        }, updateName: { [weak self] text in
            self?.viewModel.send(.updateName(indexPath.row, text))
        }, updateUnit: { [weak self] text in
            self?.viewModel.send(.updateUnit(indexPath.row, text))
        }, updatePrice: { [weak self] text in
            self?.viewModel.send(.updatePrice(indexPath.row, text))
        })
        cell.updateView(material: viewModel.materialValue[indexPath.row])
        return cell
    }
}

extension CreateMaterialViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
