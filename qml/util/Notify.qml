pragma Singleton

import Nemo.Notifications 1.0
import QtQuick 2.6

Item {
   property var notify: function(title, body, critical) {
      notification.summary = title
      notification.body = body || ""
      notification.urgency = critical ? Notification.Critical : Notification.Normal
      notification.publish()
   }

   Notification {
      id: notification
      urgency: Notification.Critical
   }
}

