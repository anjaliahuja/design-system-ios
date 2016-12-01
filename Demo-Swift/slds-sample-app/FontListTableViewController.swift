/*
 Copyright (c) 2016, salesforce.com, inc. All rights reserved.
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

class FontListTableViewController: UITableViewController {
    
    var fontTypes = [String]()
    var fontSizes = [String]()
    var customButtons = [UIButton]()
    var customFonts = ["ProximaNovaSoft-Regular.otf", "ProximaNovaSoft-Medium.otf", "ProximaNovaSoft-Semibold.otf", "ProximaNovaSoft-Bold.otf"]
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fonts"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "fontCell")
        
        // NOTE: Collecting all the Font Names
        repeat {
            if let fontType = SLDSFontType.init(rawValue: fontTypes.count),
                let fontName = SLDSFont.sldsFontTypeName(fontType) {
                fontTypes.append(fontName.replacingOccurrences(of: "SLDSFontType", with: ""))
            }
        } while SLDSFontType.init(rawValue: fontTypes.count)?.hashValue != 0
        
        // NOTE: Collecting all the Font Sizes
        repeat {
            if let fontSize = SLDSFontSizeType.init(rawValue: fontSizes.count),
                let sizeName = SLDSFont.sldsFontSizeName(fontSize) {
                fontSizes.append(sizeName.replacingOccurrences(of: "SLDSFontSize", with: ""))
            }
        } while SLDSFontSizeType.init(rawValue: fontSizes.count)?.hashValue != 0
    }

    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fontTypes.count
    }

    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontSizes.count
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 2
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderView()
        if section > 0 && section < self.customFonts.count {
            var customButton : UIButton
            if(customButtons.count >= section) {
                // NOTE - Reusing buttons in order to save toggle state.
                customButton = self.customButtons[section-1]
            }
            else {
                customButton = UIButton(frame: CGRect(x: self.view.frame.width - 70, y: 6.0, width: 60.0, height: 25.0))
                customButton.tag = section
                customButton.setTitle("Default", for: .normal)
                customButton.setTitle("Custom", for: .selected)
                customButton.titleLabel?.font = UIFont.sldsFont(.regular, with: .small)
                customButton.setTitleColor(UIColor.sldsColorText(.link), for: .normal)
                customButton.addTarget(self, action: #selector(FontListTableViewController.handleCutomButton(_:)), for: .touchUpInside)
                self.customButtons.append(customButton)
            }
            header.addSubview(customButton)
        }
        return header
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fontTypes[section]
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fontCell", for: indexPath)
        cell.textLabel?.text = fontSizes[indexPath.row]
        cell.textLabel?.font = UIFont.sldsFont(SLDSFontType.init(rawValue: indexPath.section)!, with:SLDSFontSizeType.init(rawValue:indexPath.row)!)
        return cell
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller  = FontViewController()
        controller.indexPath = indexPath
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
    
    func handleCutomButton(_ button:UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            let fontName = customFonts[button.tag];
            UIFont.sldsUse(fontName, fromBundle: "CustomFont", for: SLDSFontType(rawValue: button.tag)!)
        }
        else {
            UIFont.sldsUseDefaultFont(for: SLDSFontType(rawValue: button.tag)!)
        }
        
        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(integer: button.tag), with: .fade)
        self.tableView.endUpdates()
    }
}
