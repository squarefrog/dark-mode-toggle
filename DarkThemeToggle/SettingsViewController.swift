//
//  Copyright © 2019 squarefrog. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, Themeable {
    @IBOutlet weak var darkModeCell: UITableViewCell! {
        didSet {
            let darkModeSwitch = UISwitch()
            darkModeSwitch.addTarget(self, action: #selector(toggleDarkMode(_:)), for: .valueChanged)
            darkModeSwitch.onTintColor = Theme.dark.accentColor
            darkModeCell.accessoryView = darkModeSwitch
        }
    }

    var currentTheme: Theme = .light {
        didSet {
            apply(theme: currentTheme)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.apply(theme: currentTheme)
        return cell
    }

    @objc private func toggleDarkMode(_ sender: UISwitch) {
        // Circular
        let center = sender.superview?.convert(sender.center, to: nil) ?? .zero
        CircularReveal.animate(from: center) { _ in
            self.setNeedsStatusBarAppearanceUpdate()
        }

        // Linear
//        LinearReveal.animate { _ in
//            self.setNeedsStatusBarAppearanceUpdate()
//        }

        currentTheme = sender.isOn ? .dark : .light
    }

    func apply(theme: Theme) {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = theme.navigationBarColor
        navigationBar?.titleTextAttributes = [.foregroundColor: theme.navigationTextColor]

        tableView.backgroundColor = theme.backgroundColor
        tableView.separatorColor = theme.cellSeparatorColor

        for cell in tableView.visibleCells {
            cell.apply(theme: currentTheme)
        }

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentTheme.statusBarStyle
    }
}
