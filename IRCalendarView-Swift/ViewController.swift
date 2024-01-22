//
//  ViewController.swift
//  IRCalendarView-Swift
//
//  Created by irons on 2024/1/19.
//

import UIKit

class ViewController: UIViewController, IRCalendarViewDelegate {

    @IBOutlet weak var calendarView: IRCalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.delegate = self
    }

    // MARK: - IRCalendarViewDelegate Methods
    func dayButtonPressed(_ button: IRDayButton) {
        print("day: \(String(describing: button.buttonDate))")
    }

    func prevButtonPressed() {
        print("prevButtonPressed")
    }

    func nextButtonPressed() {
        print("nextButtonPressed")
    }
}
