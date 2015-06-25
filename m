From: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2] sysfs.txt: update show method notes about
 sprintf/snprintf/scnprintf usage
Date: Thu, 25 Jun 2015 02:33:08 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB3F8EA406@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Changed the documentation to allow sprintf() when the buffer
provided by sysfs cannot be overflowed. Explicitly say
snprintf() must never be used in a show function to format
data to be returned to user space.

Change based on a discussion about the patch
st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO

Suggested-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
---
Changes from v1:
- Changed the text after feedback from Sergey Senozhatsky
need to be more explicit that sprintf() can only be used when
you know that you will never overflow the buffer provided
by sysfs.
--- a/Documentation/filesystems/sysfs.txt	2015-06-22 14:18:40.278620871 -0500
+++ b/Documentation/filesystems/sysfs.txt	2015-06-24 15:42:32.617955400 -0500
@@ -212,7 +212,10 @@ Other notes:
 - show() methods should return the number of bytes printed into the
   buffer. This is the return value of scnprintf().
 
-- show() should always use scnprintf().
+- show() must not use snprintf() when formatting the value to be
+  returned to user space. If you can guarantee that an overflow
+  will never happen you can use sprintf() otherwise you must use
+  scnprintf().
 
 - store() should return the number of bytes used from the buffer. If the
   entire buffer has been used, just return the count argument.
