//
//  Notifications.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

func newNotification(message: String) {
    var localNotification = UILocalNotification()

    localNotification.alertAction = message
    localNotification.alertBody = message
    localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
    localNotification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

}