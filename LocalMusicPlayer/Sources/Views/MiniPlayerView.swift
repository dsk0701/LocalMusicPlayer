//
//  MiniPlayerView.swift
//  LocalMusicPlayer
//
//  Created by Daisuke Shiraishi on 2018/02/27.
//  Copyright © 2018年 Daisuke Shiraishi. All rights reserved.
//

import UIKit

@IBDesignable
class MiniPlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let view = UINib(nibName: "MiniPlayerView", bundle: bundle).instantiate(withOwner: self, options: nil).first! as! UIView

        view.frame = bounds
        addSubview(view)
    }
}
