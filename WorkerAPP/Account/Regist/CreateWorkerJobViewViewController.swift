//
//  CreateWorkerJobViewViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 15/10/2023.
//

import UIKit
import Presentation
import UIComponents
import Utils
import Domain

public extension JobValue {
    var url: String {
        switch self {
        case .water:
            return "https://www.ibst.vn/DATA/nhyen/Cap%20nuoc.pdf"
        case .electricity:
            return "https://123docz.net/document/5204350-tieu-chuan-cap-bac-tho-truyen-tai-dien.htm"
        case .refrigeration:
            return "https://luatvietnam.vn/giao-duc/thong-tu-48-2018-tt-bldtbxh-yeu-cau-ve-nang-luc-khi-tot-nghiep-cao-dang-nganh-ky-thuat-dien-176260-d1.html"
        case .orther:
            return ""
        case .turner, .machine, .miller, .planer, .noun, .farrier, .welder, .electricwelder, .carpenter:
            return "https://thuvienphapluat.vn/van-ban/Lao-dong-Tien-luong/Nghi-dinh-23-LD-ND-ban-tieu-chuan-ky-thuat-nghe-nghiep-cua-cong-nhan-co-khi-21337.aspx?fbclid=IwAR16wn3nqztkFghR1RohkkGjfSnPL2NjbMqkC8cxs5eQ0ITZoQLdPgCDJZU"
        case .thone, .betong, .cotthep, .sonvoi:
            return "https://thuvienphapluat.vn/van-ban/Xay-dung-Do-thi/Quyet-dih-163-BXD-KHCN-nam-1997-tieu-chuan-cap-bac-cong-nhan-ky-thuat-xay-dung-147689.aspx"
        }
    }
    
    var selectImage: UIImage? {
        switch self {
        case .water:
            return ImageConstant.jobWater
        case .electricity:
            return ImageConstant.jobElectric
        case .refrigeration:
            return ImageConstant.jobElectricHome
        case .orther:
            return ImageConstant.jobGear
        case .turner:
            return ImageConstant.jobGear
        case .machine:
            return ImageConstant.jobGear
        case .miller:
            return ImageConstant.jobGear
        case .planer:
            return ImageConstant.jobGear
        case .noun:
            return ImageConstant.jobGear
        case .farrier:
            return ImageConstant.jobGear
        case .welder:
            return ImageConstant.jobGear
        case .electricwelder:
            return ImageConstant.jobGear
        case .carpenter:
            return ImageConstant.jobGear
        case .thone:
            return ImageConstant.jobGear
        case .betong:
            return ImageConstant.jobGear
        case .cotthep:
            return ImageConstant.jobGear
        case .sonvoi:
            return ImageConstant.jobGear
        }
    }
    
    var deSelectImage: UIImage? {
        switch self {
        case .turner:
            return ImageConstant.jobGear
        case .machine:
            return ImageConstant.jobGear
        case .miller:
            return ImageConstant.jobGear
        case .planer:
            return ImageConstant.jobGear
        case .noun:
            return ImageConstant.jobGear
        case .farrier:
            return ImageConstant.jobGear
        case .welder:
            return ImageConstant.jobGear
        case .electricwelder:
            return ImageConstant.jobGear
        case .carpenter:
            return ImageConstant.jobGear
        case .water:
            return ImageConstant.jobWaterDes
        case .electricity:
            return ImageConstant.jobElectrictDes
        case .refrigeration:
            return ImageConstant.jobRefrigerationDes
        case .orther:
            return ImageConstant.jobGear
        case .thone:
            return ImageConstant.jobGear
        case .betong:
            return ImageConstant.jobGear
        case .cotthep:
            return ImageConstant.jobGear
        case .sonvoi:
            return ImageConstant.jobGear
        }
    }
}

class CreateWorkerJobViewViewController: BaseViewController, MVVMViewController {
    typealias VM =  CreateWorkerJobViewModel
    
    var viewModel: CreateWorkerJobViewModel
    
    private var completeButton = Button().makePrimary()
    private var collectionView = BaseCollectionView()
    
    init(viewModel: CreateWorkerJobViewModel) {
        self.viewModel = viewModel
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
        
        title = "Tạo tài khoản"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JobCell.nib(in: .main), forCellWithReuseIdentifier: JobCell.reuseId)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?
            .do({
                $0.minimumInteritemSpacing = 4
                $0.minimumLineSpacing = 8
                $0.sectionInset = .zero
            })
        
        let spacingView = UIView()
        contentView.addSubview(spacingView)
        enableHeaderView(pintoView: spacingView)
        spacingView.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.leading.trailing.equalToSuperview()
        }
        let headerTitleView = CreateWorkerHeaderView()
        headerTitleView.setValue(title: "Chọn ngành nghề của bạn", subTitle: "Khách hàng sẽ dựa vào ngành nghề này để tìm kiếm đến bạn")
        
        contentView.addSubview(headerTitleView)
        headerTitleView.snp.makeConstraints {
            $0.top.equalTo(spacingView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerTitleView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        
        completeButton.title = "Hoàn thành"
        completeButton.squircle(radius: 24)
        contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(collectionView.snp.bottom)
        }
        
        completeButton.action = { [weak self] in
            self?.viewModel.send(.completion)
        }
        
    }
    
    func bind(viewModel: CreateWorkerJobViewModel) {
        viewModel.config(.init(reloadView: { [weak self] in
            self?.collectionView.reloadData()
        }, loading: { [weak self] in
            guard let self = self else { return }
            Loading.shared.showLoading(view: self.view, text: "Vui lòng đợi !!!!!")
        }, error: { [weak self] error in
            guard let self = self else { return }
            AlertUtils.show(title: "Cảnh bảo", message: error, present: self)
        }, enableButton: { [weak self] isEnable in
            self?.completeButton.isEnabled = isEnable
        }, didConfirm:{ [weak self] worker in
            CreateWorkerJobDetailViewController(viewModel: .init(worker: worker)).push(from: self)
        }))
        viewModel.send(.viewDidLoad)
    }
    
}

extension CreateWorkerJobViewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.jobsValue.0.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JobCell.reuseId, for: indexPath) as! JobCell
        cell.updateView(data: self.viewModel.jobsValue.0[indexPath.row], currentJob: self.viewModel.jobsValue.1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width / 3 - 4,
                      height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.send(.didSelectJob(indexPath.row))
    }
}

private class CustomFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath,
                                                             withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        attributes.transform = .init(scaleX: 1.2, y: 1.2).rotated(by: .pi / 64)
        return attributes
    }
}
