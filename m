From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
Date: Tue, 24 Jun 2014 11:33:24 +0200
Message-ID: <1403602404.1960.7.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

There's no power/persist file for hubs. And CONFIG_USB_PERSIST was
removed in v2.6.26. Update the description of power/persist accordingly.

Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
---
I don't know anything about USB-Persist. Could Greg and Alan please
check whether the new description does actually match reality?

 Documentation/ABI/stable/sysfs-bus-usb | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-bus-usb b/Documentation/ABI/stable/sysfs-bus-usb
index a6b685724740..a61d04b8fc78 100644
--- a/Documentation/ABI/stable/sysfs-bus-usb
+++ b/Documentation/ABI/stable/sysfs-bus-usb
@@ -3,13 +3,13 @@ Date:		May 2007
 KernelVersion:	2.6.23
 Contact:	Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
 Description:
-		If CONFIG_USB_PERSIST is set, then each USB device directory
-		will contain a file named power/persist.  The file holds a
-		boolean value (0 or 1) indicating whether or not the
-		"USB-Persist" facility is enabled for the device.  Since the
-		facility is inherently dangerous, it is disabled by default
-		for all devices except hubs.  For more information, see
-		Documentation/usb/persist.txt.
+		USB device directories for all devices except hubs will contain
+		a file named power/persist.  The file holds a boolean value (0
+		or 1) indicating whether or not the "USB-Persist" facility is
+		enabled for the device.  Since the facility is inherently
+		dangerous, it is disabled by default.  For hubs this facility is
+		always enabled making the file pointless.  For more information,
+		see Documentation/usb/persist.txt.
 
 What:		/sys/bus/usb/devices/.../power/autosuspend
 Date:		March 2007
-- 
1.9.3
