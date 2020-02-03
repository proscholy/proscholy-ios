//
//  AboutVC.swift
//  Zpevnik
//
//  Created by Patrik Dobiáš on 08/08/2019.
//  Copyright © 2019 Patrik Dobiáš. All rights reserved.
//

import UIKit

class AboutVC: ViewController {
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
        
        textView.delegate = self
        
        textView.isEditable = false
        
        textView.textContainer.lineBreakMode = .byWordWrapping
        
        return textView
    }()
    
    var state: AboutState? {
        didSet {
            setDescription()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(descriptionTextView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[descriptionTextView]|", metrics: nil, views: ["descriptionTextView": descriptionTextView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[descriptionTextView]-|", metrics: nil, views: ["descriptionTextView": descriptionTextView]))
    }
    
    private func setDescription() {
        guard let state = state else { return }
        
        switch state {
        case .aboutSongBook:
            navigationItem.title = "O Zpěvníku"
            
            let description = """
                Zpěvník ProScholy.cz, který přichází na pomoc všem scholám, křesťanským kapelám, společenstvím a všem, kdo se chtějí modlit hudbou!

                Projekt vzniká se svolením České biskupské konference.

                Další informace o stavu a rozvoji projektu naleznete na https://zpevnik.proscholy.cz.
                """
            
            let attributedDescription: NSMutableAttributedString
            attributedDescription = NSMutableAttributedString(string: description, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.text])
            
            if let range = description.range(of: "ProScholy.cz") {
                attributedDescription.addAttribute(.link, value: "https://zpevnik.proscholy.cz", range: NSRange(range, in: description))
            }
            
            if let range = description.range(of: "České biskupské konference") {
                attributedDescription.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(range, in: description))
            }
            
            if let range = description.range(of: "https://zpevnik.proscholy.cz") {
                attributedDescription.addAttribute(.link, value: "https://zpevnik.proscholy.cz", range: NSRange(range, in: description))
            }
            
            descriptionTextView.attributedText = attributedDescription
            break
        case .aboutApp:
            navigationItem.title = "O Aplikaci"
            
            var description = ""
            if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                description += String(format: "Zpěvník pro scholy verze %@\n", currentVersion)
            }
            
            description += """
            Offline mobilní verze pro iOS.
            
            Případné chyby, připomínky, nápady či postřehy k této aplikaci, prosím, uveďte zde.
            """
            
            let attributedDescription: NSMutableAttributedString
            attributedDescription = NSMutableAttributedString(string: description, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.text])
            
            attributedDescription.addAttribute(.link, value: "https://docs.google.com/forms/d/e/1FAIpQLSfI0143gkLBtMbWQnSa9nzpOoBNMokZrOIS5mUreSR41E_B7A/viewform?usp=pp_url&entry.1865829262=ano,+verzi+pro+iOS", range: NSRange(location: description.count - 4, length: 3))
            
            descriptionTextView.attributedText = attributedDescription
            break
        }
    }
}

extension AboutVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        
        return false
    }
}
