//
//  TransactionInteractor.swift
//  QRIS App
//
//  Created by Ariesta APP on 25/01/24.
//

import Foundation
import CoreData
public class TransactionInteractor {
    public static let shared = TransactionInteractor(taskContext: TransactionProvider.shared.newTaskContext())
    private let entityName = "TransactionEntity"
    private let taskContext: NSManagedObjectContext?
    public init(taskContext: NSManagedObjectContext?) {
        self.taskContext = taskContext
    }
}

extension TransactionInteractor {
    public func getTransaction(completion: @escaping ([TransactionModel?]) -> Void) {
        taskContext?.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
            do {
                if let result = try self.taskContext?.fetch(fetchRequest) {
                    var transactionItem: [TransactionModel] = []
                    for item in result {
                        let transactionId = item.value(forKeyPath: "transactionId") as? String
                        let merchant = item.value(forKeyPath: "merchant") as? String
                        let amount = item.value(forKeyPath: "amount") as? Double
                        let transaction = TransactionModel(
                            transactionId: transactionId,
                            merchantName: merchant,
                            amount: amount
                        )
                        transactionItem.append(transaction)
                    }
                    completion(transactionItem)
                }
            } catch let err {
                completion([])
                print("Error - BalanceProvider: \(err)")
            }
        }
    }
    
    public func addTransaction(data: TransactionModel, completion: @escaping ([TransactionModel?]) -> Void) {
        guard let taskContext = taskContext else {return}
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: taskContext) {
                let transaction = NSManagedObject(entity: entity, insertInto: taskContext)
                DispatchQueue.main.async {
                    self.getTransaction { datas in
                        transaction.setValue(datas.count+1, forKeyPath: "id")
                    }
                    transaction.setValue(data.transactionId, forKeyPath: "transactionId")
                    transaction.setValue(data.merchantName, forKeyPath: "merchant")
                    transaction.setValue(data.amount, forKeyPath: "amount")
                    do {
                        try taskContext.save()
                        self.getTransaction { transactions in
                            completion(transactions)
                        }
                    } catch {
                        completion([])
                    }
                }
            }
        }
    }
}
