//
//  StandardDonationViewModel.swift
//  YToke
//
//  Created by Lyt on 2020/8/10.
//  Copyright © 2020 TestOrganization. All rights reserved.
//

import Cocoa
import Foundation

final class StandardDonationViewModel: DonationViewModel {
    
    let image: NSImage = NSImage(named: NSImage.Name("DonationImage")) ?? NSImage()
    let buttonImage: NSImage = NSImage(named: NSImage.Name("PaypalDonate")) ?? NSImage()
    let title: String = NSLocalizedString("support_us", comment: "Support US")

    let subTitle: String =
        NSLocalizedString("donation_disclaimer", comment: "Donation disclaimer")

    let hiddenTitle: String = NSLocalizedString("thank_you_with_exclaimation_mark", comment: "Thank you!")
    
    let buttonTitle: String = NSLocalizedString("donate", comment: "Donate")
    
    private let workspace: NSWorkspace
    
    private let donationLink = "https://www.paypal.com/biz/fund?id=L3P7NAM2MZLDS"
    
    init(workspace: NSWorkspace = NSWorkspace.shared) {
        self.workspace = workspace
    }
    
    func onTapButton() {
        guard let url = URL(string: donationLink) else {
            return
        }
        
        workspace.open(url)
    }
}
