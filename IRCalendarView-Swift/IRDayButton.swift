//
//  IRDayButton.swift
//  IRCalendarView-Swift
//
//  Created by irons on 2024/1/20.
//

import Foundation
import UIKit

// Protocol Definition
protocol IRDayButtonDelegate: AnyObject {
    func dayButtonPressed(_ sender: IRDayButton)
}

// PlaybackInfo Structure
struct PlaybackInfo {
    var schedSnapshot: Int
    var alarmSnapshot: Int
    var schedVideo: Int
    var alarmVideo: Int
}

// IRDayButton Class
class IRDayButton: UIButton {

    weak var delegate: IRDayButtonDelegate?
    var buttonDate: Date?
    var monthAdd: Int = 0
    var buttonPlaybackInfo: PlaybackInfo

    init(frame: CGRect, buttonPlaybackInfo: PlaybackInfo) {
        self.buttonPlaybackInfo = buttonPlaybackInfo
        super.init(frame: frame)

        self.addTarget(self, action: #selector(dayButtonPressed), for: .touchUpInside)
        titleLabel?.textAlignment = .right
        backgroundColor = .clear
        setTitleColor(.gray, for: .normal)
        setBackgroundImage(UIImage(named: "Sample_fix.png"), for: .selected)
        contentMode = .scaleAspectFit
        for view in subviews {
            view.contentMode = .scaleAspectFit
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Factory method for creating the button
    static func buttonWithFrame(_ buttonFrame: CGRect) -> IRDayButton {
        return IRDayButton(frame: buttonFrame, buttonPlaybackInfo: PlaybackInfo(schedSnapshot: 0, alarmSnapshot: 0, schedVideo: 0, alarmVideo: 0))
    }

    @objc private func dayButtonPressed() {
        delegate?.dayButtonPressed(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let titleLabel = titleLabel else { return }
        let framePadding: CGFloat = 4
        titleLabel.frame = CGRect(x: bounds.size.width - titleLabel.frame.size.width - framePadding,
                                  y: framePadding,
                                  width: titleLabel.frame.size.width,
                                  height: titleLabel.frame.size.height)
    }
}

