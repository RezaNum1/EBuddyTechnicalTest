//
//  FirestoreManager.swift
//  EBuddy-Technical-Test
//
//  Created by Reza Harris on 28/11/24.
//

import SwiftUI
import FirebaseFirestore

class FirestoreManager {
    init(collectionName: String) {
        self.collectionName = collectionName
    }

    let collectionName: String
    let db = Firestore.firestore()

    func fetchDocuments(run: @escaping ([QueryDocumentSnapshot], (any Error)?) -> Void){
        db.collection(collectionName).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                run(snapshot!.documents, error)
            }
        }
    }

    func insertDocument(data: [String: Any], completion: @escaping ((any Error)?) -> Void)  {
        db.collection(collectionName).document().setData(data) { error in
            completion(error)
        }
    }

    func updateDocument(idRef: String, data: [String: Any], completion: @escaping ((any Error)?) -> Void) {
        db.collection(collectionName).document(idRef).updateData(data) { error in
            completion(error)
        }
    }
}
