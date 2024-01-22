//
//  IRCalendarView.swift
//  IRCalendarView-Swift
//
//  Created by irons on 2024/1/20.
//

import UIKit

// Constants
let calendarGap: CGFloat = 20
let calendarPaddingTop: CGFloat = 8
let gregorianCalendarIdentifier = NSCalendar.Identifier.gregorian

// Delegate Protocol
protocol IRCalendarViewDelegate: AnyObject {
    func dayButtonPressed(_ button: IRDayButton)
    func prevButtonPressed()
    func nextButtonPressed()
}

// Main Class
class IRCalendarView: UIView {

    // Properties
    weak var delegate: IRCalendarViewDelegate?
    private var monthStrings: [String]
    private var calendarFontName: String?
    private var monthLabel: UILabel
    private var dayButtons: [IRDayButton]
    private var calendar: Calendar
    private var calendarWidth: CGFloat = 0
    private var calendarHeight: CGFloat = 0
    private var cellWidth: CGFloat = 0
    private var cellHeight: CGFloat = 0
    private var currentMonth: Int = 0
    private var currentYear: Int = 0

    private var currentSelectedDate: Date?
    private var currentSelectedImageView: UIImageView?
    private var currentPlaybackInfo: [String: Any]?
    private var dayStrings: [String]

    // Initializers
    init(frame: CGRect, fontName: String?, playbackInfo: [String: Any]?, delegate: IRCalendarViewDelegate?) {
        self.monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        self.dayStrings = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        self.calendar = Calendar(identifier: .gregorian)
        self.dayButtons = []
        self.monthLabel = UILabel()
        self.calendarWidth = frame.size.width
        self.calendarHeight = frame.size.height
        self.cellWidth = frame.size.width / 7.0
        self.cellHeight = frame.size.height / 8.0
        self.currentMonth = Calendar.current.component(.month, from: Date())
        self.currentYear = Calendar.current.component(.year, from: Date())
        self.calendarFontName = fontName
        self.currentPlaybackInfo = playbackInfo
        super.init(frame: frame)
        self.delegate = delegate
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        self.monthStrings = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        self.dayStrings = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        self.calendar = Calendar(identifier: .gregorian)
        self.dayButtons = []
        self.monthLabel = UILabel()
        super.init(coder: aDecoder)
        self.calendarWidth = frame.size.width
        self.calendarHeight = frame.size.height
        self.cellWidth = frame.size.width / 7.0
        self.cellHeight = frame.size.height / 8.0
        self.currentMonth = Calendar.current.component(.month, from: Date())
        self.currentYear = Calendar.current.component(.year, from: Date())
        self.calendarFontName = ""
        self.currentPlaybackInfo = nil
        setupView()
    }
}

extension IRCalendarView {

    // Inside IRCalendarView class

    private func setupView() {
        backgroundColor = UIColor.clear

        calendarWidth = frame.size.width
        calendarHeight = frame.size.height
        cellWidth = calendarWidth / 7.0
        cellHeight = calendarHeight / 8.0

        setupCalendarHeader()
        setupDayLabels()
        drawDayButtons()
        setCurrentMonthAndYear()
        updateCalendar(forMonth: currentMonth, forYear: currentYear)
    }

    private func setupCalendarHeader() {
        let prevButton = UIButton(type: .custom)
        prevButton.setImage(UIImage(named: "img_month_back.png"), for: .normal)
        prevButton.frame = CGRect(x: 0, y: calendarPaddingTop, width: cellWidth, height: cellHeight)
        prevButton.addTarget(self, action: #selector(prevBtnPressed(_:)), for: .touchUpInside)

        let nextButton = UIButton(type: .custom)
        nextButton.setImage(UIImage(named: "img_month_forward.png"), for: .normal)
        nextButton.frame = CGRect(x: calendarWidth - cellWidth, y: calendarPaddingTop, width: cellWidth, height: cellHeight)
        nextButton.addTarget(self, action: #selector(nextBtnPressed(_:)), for: .touchUpInside)

        let monthLabelFrame = CGRect(x: cellWidth, y: calendarPaddingTop, width: calendarWidth - 2 * cellWidth, height: cellHeight)
        monthLabel = UILabel(frame: monthLabelFrame)
        monthLabel.font = UIFont(name: calendarFontName ?? "", size: 18)
        monthLabel.textAlignment = .center
        monthLabel.backgroundColor = .clear
        monthLabel.textColor = .black

        addSubview(prevButton)
        addSubview(nextButton)
        addSubview(monthLabel)
    }

    private func setupDayLabels() {
        for i in 0..<7 {
            let dayLabelFrame = CGRect(x: CGFloat(i) * cellWidth, y: cellHeight + calendarGap, width: cellWidth, height: cellHeight)
            let dayLabel = UILabel(frame: dayLabelFrame)
            dayLabel.text = dayStrings[i]
            dayLabel.textAlignment = .center
            dayLabel.backgroundColor = .clear
            dayLabel.font = UIFont(name: calendarFontName ?? "", size: 16)
            dayLabel.textColor = .darkGray
            addSubview(dayLabel)
        }
    }

    private func setCurrentMonthAndYear() {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        currentMonth = dateComponents.month ?? currentMonth
        currentYear = dateComponents.year ?? currentYear
    }

    // Inside IRCalendarView class

    private func drawDayButtons() {
        dayButtons = []
        for i in 0..<6 {
            for j in 0..<7 {
                let buttonFrame = CGRect(x: CGFloat(j) * cellWidth, y: (CGFloat(i) + 2) * cellHeight + calendarGap, width: cellWidth, height: cellHeight)
                let dayButton = IRDayButton.buttonWithFrame(buttonFrame)
                dayButton.titleLabel?.font = UIFont(name: calendarFontName ?? "", size: 14)
                dayButton.addTarget(self, action: #selector(dayButtonPressed(_:)), for: .touchUpInside)

                dayButtons.append(dayButton)
                addSubview(dayButton)
            }
        }
    }

    @objc private func prevBtnPressed(_ sender: UIButton) {
        clearSelected(clearSelect: false)
        currentMonth = currentMonth == 1 ? 12 : currentMonth - 1
        currentYear = currentMonth == 1 ? currentYear - 1 : currentYear
        updateCalendar(forMonth: currentMonth, forYear: currentYear)
        delegate?.prevButtonPressed()
    }

    @objc private func nextBtnPressed(_ sender: UIButton) {
        clearSelected(clearSelect: false)
        currentMonth = currentMonth == 12 ? 1 : currentMonth + 1
        currentYear = currentMonth == 12 ? currentYear + 1 : currentYear
        updateCalendar(forMonth: currentMonth, forYear: currentYear)
        delegate?.nextButtonPressed()
    }

    @objc private func dayButtonPressed(_ sender: IRDayButton) {
        let monthAdd = sender.monthAdd
        clearSelected(clearSelect: true)
        currentSelectedDate = sender.buttonDate
        setSelectedHighlight(button: sender)

        if monthAdd != 0 {
            currentMonth = (currentMonth + monthAdd - 1) % 12 + 1
            currentYear = currentMonth == 1 && monthAdd == -1 ? currentYear - 1 : (currentMonth == 12 && monthAdd == 1 ? currentYear + 1 : currentYear)
        }
        updateCalendar(forMonth: currentMonth, forYear: currentYear)
    }

    private func clearSelected(clearSelect: Bool) {
        currentSelectedImageView?.isHidden = true
        if clearSelect {
            currentSelectedDate = nil
        }
    }

    private func setSelectedHighlight(button: UIButton) {
        currentSelectedImageView?.isHidden = false
        currentSelectedImageView?.center = button.center
        bringSubviewToFront(button)
        delegate?.dayButtonPressed(button as! IRDayButton)
    }

    private func updateCalendar(forMonth month: Int, forYear year: Int) {
        monthLabel.text = "\(monthStrings[month - 1]) \(year)"

        // Calculate the first day of the month
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1

        guard let firstOfMonth = calendar.date(from: components),
              let rangeOfDays = calendar.range(of: .day, in: .month, for: firstOfMonth) else { return }

        let weekdayOfFirst = calendar.component(.weekday, from: firstOfMonth)
        var day = 1
        for i in 0..<6 {
            for j in 0..<7 {
                let buttonIndex = i * 7 + j
                let button = dayButtons[buttonIndex]

                // Reset button
                button.setTitle(nil, for: .normal)
                button.buttonDate = nil

                // Calculate date for button
                if buttonIndex >= weekdayOfFirst - 1 && day <= rangeOfDays.count {
                    button.setTitle("\(day)", for: .normal)

                    var dayComponents = DateComponents()
                    dayComponents.year = year
                    dayComponents.month = month
                    dayComponents.day = day
                    let buttonDate = calendar.date(from: dayComponents)
                    button.buttonDate = buttonDate

                    // Check if the button date is the selected date
                    if let currentSelect = currentSelectedDate, calendar.isDate(currentSelect, inSameDayAs: buttonDate!) {
                        setSelectedHighlight(button: button)
                    }

                    // Set appearance based on current month
                    if month != currentMonth {
                        button.setTitleColor(.gray, for: .normal)
                    } else {
                        button.setTitleColor(.black, for: .normal)
                    }

                    button.isEnabled = true
                    day += 1
                }
            }
        }
    }
}
