//
//  TransactionModel.swift
//  QRIS App
//
//  Created by Ariesta APP on 25/01/24.
//

import Foundation

public struct TransactionModel {
    public init(transactionId: String?, merchantName: String?, amount: Double?) {
        self.transactionId = transactionId
        self.merchantName = merchantName
        self.amount = amount
    }
    public let transactionId: String?
    public let merchantName: String?
    public let amount: Double?
}
