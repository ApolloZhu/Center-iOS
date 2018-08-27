//
//  Tutor.swift
//  Center-iOS
//
//  Created by Apollo Zhu on 8/26/18.
//  Copyright © 2018 OHS The Center. All rights reserved.
//

import Foundation
import Firebase

struct Tutor {
    let email: String
    let firstName: String
    let lastName: String
    let role: Role
    let subjects: [String]
    let totalScheduled: Int
    let totalAttended: Int
    let scheduled: [DocumentReference]
}

extension Tutor {
    enum Role: String, CaseIterable, CustomStringConvertible {
        case center = "center"
        case travel = "travel"
        case p2p = "p2p"

        var description: String {
            switch self {
            case .center: return "Center Tutor"
            case .travel: return "Travel Tutor"
            case .p2p: return "P2P Only"
            }
        }

        static let map: [AnyHashable: String] = [
            // Instances
            center: center.description,
            travel: travel.description,
            p2p   : p2p.description,
            // Raw values
            center.rawValue: center.description,
            travel.rawValue: travel.description,
            p2p.rawValue   : p2p.description,
            // Human readables
            center.description: center.rawValue,
            travel.description: travel.rawValue,
            p2p.description   : p2p.rawValue
        ]
    }
}

// MARK: Methods

extension Tutor {
    static func ofID(_ id: Int, then process: @escaping (Tutor?, Error?) -> Void) {
        guard id > 0 else { return process(nil, nil) }
        db.collection("students").document("\(id)").getDocument { (snapshot, err) in
            guard let data = snapshot?.data() else { return process(nil, err) }
            guard let firstName = data["firstName"] as? String
                , let lastName = data["lastName"] as? String
                , let email = data["email"] as? String
                , let rawRole = data["role"] as? String
                , let role = Role(rawValue: rawRole)
                , let subjects = data["subjects"] as? [String]
                , let scheduled = data["scheduled"] as? [DocumentReference]
                , let totalScheduled = data["totalScheduled"] as? Int
                , let totalAttended = data["totalAttended"] as? Int
                else { return process(nil, nil) }
            let tutor = Tutor(
                email: email,
                firstName: firstName,
                lastName: lastName,
                role: role,
                subjects: subjects,
                totalScheduled: totalScheduled,
                totalAttended: totalAttended,
                scheduled: scheduled
            )
            process(tutor, nil)
        }
    }
}
