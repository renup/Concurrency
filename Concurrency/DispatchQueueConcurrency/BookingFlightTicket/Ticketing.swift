//
//  Ticketing.swift
//  Concurrency
//
//  Created by Renu Punjabi on 1/26/19.
//  Copyright © 2019 Renu Punjabi. All rights reserved.
//

import Foundation

class Ticketing {
    
    var totalTickets = 0
    let ticketProducingLimit = 10
    
    let dispatchQueue = DispatchQueue(label: "com.cocoateam.isolationQueue", attributes: .concurrent)
    
    func randomSleep() {
        sleep(arc4random_uniform(3))
    }
    
    ///start adding, buying and reading remaining ticket threads to run concurrently
    func start() {
        addTicketsThreads()
        buyTicketsThreads()
        readTicketsThreads()
    }
    
    ///Add three concurrent threads creating/producing tickets
    func addTicketsThreads() {
        for i in 0..<3 {
            let createTicketQueue = DispatchQueue(label: "com.cocoateam.createTickets+\(i)", attributes: .concurrent)
            
            createTicketQueue.async {[weak self] in
                guard let `self` = self else { return }
                while true { // each thread runs in a forver loop
                    self.randomSleep()
                    self.addTicket()
                }
            }
        }
    }
    
    ///Run 3 reading threads running concurrently reading the number of tickets available.
    func readTicketsThreads() {
        for i in 0..<3 {
            let readTicketQueue = DispatchQueue(label: "com.cocoateam.readTickets+\(i)", attributes: .concurrent)
            
            readTicketQueue.async {[weak self] in
                guard let `self` = self else { return }
                while true { // each thread runs in a forver loop
                    self.randomSleep()
                    print("remaining \(String(describing: self.getTicketCount()))")
                    
                }
            }
        }
    }
    
    ///Run 3 threads buying/consuming flight tickets running concurrenlty
    func buyTicketsThreads() {
        for i in 0..<3 {
            let removeTicketQueue = DispatchQueue(label: "com.cocoateam.removeTickets+\(i)", attributes: .concurrent)
            
            removeTicketQueue.async {[weak self] in
                guard let `self` = self else { return }
                while true { // each thread runs in a forver loop
                    self.randomSleep()
                    self.removeTicket()
                }
            }
        }
    }
    
    ///Gives current ticket count
    func getTicketCount() -> Int {
        return dispatchQueue.sync {[weak self] in
            guard let `self` = self else { return 0 }
            return self.totalTickets
        }
    }
    
    
    //Producer:
    func addTicket() {
        dispatchQueue.async(flags: .barrier) {[weak self] in
            //Making sure that we produce only until a set of 10 tickets extra
            guard let `self` = self, self.totalTickets < self.ticketProducingLimit else { return }
            self.totalTickets += 1
           
            print("Added 1 ticket, so remaining \(String(describing: self.totalTickets)) tickets")
        }
    }
    
    //Consumer:
    func removeTicket() {
        dispatchQueue.async(flags: .barrier) { [weak self] in
            guard let `self` = self, self.totalTickets > 1 else { return }
            
            self.totalTickets -= 1
            print("Bought 1 ticket, so remaining \(String(describing: self.totalTickets)) tickets")
        }
    }
    
}
