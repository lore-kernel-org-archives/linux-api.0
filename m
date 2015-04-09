From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 4/4] Documentation: ABI: Fix documentation for mass_storage
 function
Date: Thu, 09 Apr 2015 18:18:10 +0200
Message-ID: <1428596290-23637-5-git-send-email-k.opasiak@samsung.com>
References: <1428596290-23637-1-git-send-email-k.opasiak@samsung.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1428596290-23637-1-git-send-email-k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: balbi-l0cyMroinI0@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org
Cc: andrzej.p-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Luns in mass storage function are identified using their id.
While creating lun's directory user cannot choose any arbitrary
name other than decimal value from 1 to FSG_MAX_LUNS.

Moreover, LUNs ids should be contiguous. This means that user
may remove only lun with max id and can create new lun
only if its id equals to max id + 1.

Signed-off-by: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 .../ABI/testing/configfs-usb-gadget-mass-storage   |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
index 9931fb0..2bf085d 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
+++ b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
@@ -11,10 +11,15 @@ Description:
 				are 2..4. Available only if
 				CONFIG_USB_GADGET_DEBUG_FILES is set.
 
-What:		/config/usb-gadget/gadget/functions/mass_storage.name/lun.name
+What:		/config/usb-gadget/gadget/functions/mass_storage.name/lun.id
 Date:		Oct 2013
 KernelVersion:	3.13
 Description:
+		id - decimal value from 1 to FSG_MAX_LUNS
+		(which is 8 by default) - 1. LUNs should be numbered contiguously.
+		lun.0 is reserved for default lun which appears while creating
+		mass_storage.name directory and cannot be removed by the user.
+
 		The attributes:
 
 		file		- The path to the backing file for the LUN.
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
