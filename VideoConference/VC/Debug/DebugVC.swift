//
//  DebugVC.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/5.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import AgoraRoom
import SVProgressHUD

class DebugVC: UITableViewController {
    
    let datdaList = [["创建/加入房间", "离开房间"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Debug"
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return datdaList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datdaList[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = datdaList[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "业务服务API"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0, row == 0 {
            testJionAPI()
            return
        }
        
        if section == 0, row == 1 {
            testLeaveAPI()
            return
        }
    }

}

extension DebugVC {
    func testJionAPI() {
        let reqParam = HMReqParamsAddRoom()
        reqParam.roomName = "testios1"
        reqParam.roomId = reqParam.roomName
        reqParam.userName = "zyp"
        reqParam.userId = reqParam.userName
        reqParam.password = ""
        reqParam.cameraAccess = true
        reqParam.micAccess = true
        SVProgressHUD.show()
        HttpManager.request(reqParam) { (respParam) in
            SVProgressHUD.showSuccess(withStatus: "成功")
        } failure: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func testLeaveAPI() {
        SVProgressHUD.show()
        
        HttpManager.requestLeaveRoom(withRoomId: "testios1", userId: "zyp") {
            SVProgressHUD.showSuccess(withStatus: "成功")
        } faulure: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }

    }
}
