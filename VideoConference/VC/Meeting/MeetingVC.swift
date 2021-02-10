//
//  MeetingVC.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/4.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit

class MeetingVC: BaseViewController {

    private let meetingView = MeetingView()
    private let vm = MeetingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        commonInit()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setup() {
        meetingView.setMode(.videoFlow)
        view = meetingView
        
        meetingView.collectionView.delegate = self
        meetingView.collectionView.dataSource = self
        meetingView.delegate = self
        meetingView.videoScrollView.collectionView.delegate = self
        meetingView.videoScrollView.collectionView.dataSource = self
        meetingView.topView.delegate = self
        meetingView.bottomView.delegate = self
        vm.delegate = self
        
        let videoNib = UINib(nibName: "VideoCell", bundle: nil)
        meetingView.collectionView.register(videoNib, forCellWithReuseIdentifier: "VideoCell")
        meetingView.videoScrollView.collectionView.register(videoNib, forCellWithReuseIdentifier: "VideoCell")
        let audioNib = UINib(nibName: "AudioCell", bundle: nil)
        meetingView.collectionView.register(audioNib, forCellWithReuseIdentifier: "AudioCell")
        meetingView.videoScrollView.collectionView.register(audioNib, forCellWithReuseIdentifier: "AudioCell")
    }
    
    func commonInit() {
        vm.start()
    }
    
    func showMoreAlert() {
        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "邀请", style: .default, handler: nil)
        let action2 = UIAlertAction(title: "全员静音", style: .default, handler: nil)
        let action3 = UIAlertAction(title: "全员摄像头关闭", style: .default, handler: nil)
        let action4 = UIAlertAction(title: "开始屏幕共享", style: .default, handler: nil)
        let action5 = UIAlertAction(title: "结束共享屏幕", style: .default, handler: nil)
        let action6 = UIAlertAction(title: "发起白板", style: .default, handler: nil)
        let action7 = UIAlertAction(title: "设置", style: .default, handler: nil)
        let action8 = UIAlertAction(title: "取消", style: .default, handler: nil)
        
        vc.addAction(action1)
        vc.addAction(action2)
        vc.addAction(action3)
        vc.addAction(action4)
        vc.addAction(action5)
        vc.addAction(action6)
        vc.addAction(action7)
        vc.addAction(action8)
        present(vc, animated: true, completion: nil)
    }
    
}

extension MeetingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        meetingView.setItemCount(1)
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.collectionViewLayout == meetingView.layoutAudio {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioCell", for: indexPath) as! AudioCell
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            vm.publishLocalMediaTrack()
            vm.videoTrack?.setView(cell.getRenderView())
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        meetingView.setMode(.speaker)
        meetingView.setItemCount(1)
        
        let model = MeetingMessageModel()
        model.name = "XXX" + "\(indexPath.row)"
        model.info = "YYY" + "\(indexPath.row)"
        model.remianCount = 0
        model.showButton = true
        meetingView.messageView.add(model)
    }
}

extension MeetingVC: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidEndScroll()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollViewDidEndScroll()
        }
    }
    
    func scrollViewDidEndScroll() {
        let collectionView = meetingView.getMode() == .speaker ? meetingView.videoScrollView.collectionView : meetingView.collectionView
        let indexPaths = collectionView.indexPathsForVisibleItems
        if let indexPath = indexPaths.first {
            let index = indexPath.row + 1
            meetingView.setCurrentPageWithItemIndex(index)
        }
    }
}

extension MeetingVC: MeetingViewDelegate {
    
    func meetingViewDidTapExitSpeakeButton(_ view: MeetingView) {
        view.setMode(.videoFlow)
    }
    
}

extension MeetingVC: MeetingTopViewDelegate, MeetingBottomViewDelegate {
    
    func meetingBottomViewDidTapButton(with type: MeetingBottomViewButtonType) {
        switch type {
        case .member:
            let vc = MemberVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .more:
            showMoreAlert()
            break
        default:
            break
        }
    }
    
    func meetingTopViewDidTapLeaveButton() {
        vm.leave()
    }
    
}

extension MeetingVC: MeetingVMProtocol {
    
    func meetingVMDidLeaveRoom() {
        dismiss(animated: true, completion: nil)
    }
    
    func meetingVMLeaveRoomErrorWithTips(tips: String) {
        showToast(tips)
    }
    
}

extension MeetingVC: VideoCellDelegate {
    
    func videoCell(_ cell: VideoCell, didTapType type: VideoCellTapType) {
        
    }
}

