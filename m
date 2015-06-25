From: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH] sysfs.txt: update show method notes about
 sprintf/snprintf/scnprintf usage
Date: Thu, 25 Jun 2015 00:55:26 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3F8EA364@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Changed the documentation to allow sprintf() for small
single values and explicitly say snprintf() must never be used in
a show function to format data to be returned to user space.

Change based on a discussion about the patch
st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO

Suggested-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
---
--- a/Documentation/filesystems/sysfs.txt	2015-06-22 14:18:40.278620871 -0500
+++ b/Documentation/filesystems/sysfs.txt	2015-06-24 13:42:21.344446532 -0500
@@ -212,7 +212,9 @@ Other notes:
 - show() methods should return the number of bytes printed into the
   buffer. This is the return value of scnprintf().
 
-- show() should always use scnprintf().
+- show() must not use snprintf() when formatting a value to be
+  returned to user space. For small single values you can use
+  sprintf() otherwise you must use scnprintf().
 
 - store() should return the number of bytes used from the buffer. If the
   entire buffer has been used, just return the count argument.
