From: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
Subject: [patch 3/3] [ltp] Remove testcase for "Buffer size is not positive" in kernel/syscalls/readlink/readlink03
Date: Thu, 23 Oct 2008 16:50:58 +0200
Message-ID: <20081023150549.569637960@marvin.suse.de>
References: <20081023145054.998439866@marvin.suse.de>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=syscalls-readlink-bufsize-mismatch.diff
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Remove testcase for "Buffer size is not positive" in testcase readlink03, since
buffer size argument is type of size_t (unsigned) and negative value are not
possible. With proposed sys_readlink modification a buffer size of 0 ends in a
return value of 0, not -1 anymore.

(This modification depends on man-pages and linux syscalls modifications,
 provided by this patch queue)

Signed-off-by: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>


---
 testcases/kernel/syscalls/readlink/readlink03.c |    3 ---
 1 file changed, 3 deletions(-)

Index: ltp-full-20081017/testcases/kernel/syscalls/readlink/readlink03.c
===================================================================
--- ltp-full-20081017.orig/testcases/kernel/syscalls/readlink/readlink03.c
+++ ltp-full-20081017/testcases/kernel/syscalls/readlink/readlink03.c
@@ -25,8 +25,6 @@
  *   1) readlink(2) returns -1 and sets errno to EACCES if search/write
  *	permission is denied in the directory where the symbolic link
  *	resides.
- *   2) readlink(2) returns -1 and sets errno to EINVAL if the buffer size
- *	is not positive.
  *   3) readlink(2) returns -1 and sets errno to EINVAL if the specified
  *	file is not a symbolic link file.
  *   4) readlink(2) returns -1 and sets errno to ENAMETOOLONG if the 
@@ -119,7 +117,6 @@ struct test_case_t {		/* test case struc
 	int (*setupfunc)();
 } Test_cases[] = {
 	{ SYM_FILE1, "No Search permissions to process", EACCES, 1, setup1 },
-	{ SYM_FILE2, "Buffer size is not positive", EINVAL, -1, setup2 },
 	{ TEST_FILE2, "File is not symbolic link", EINVAL, 1, no_setup },
 	{ Longpathname, "Symlink path too long", ENAMETOOLONG, 1, lpath_setup },
 	{ "", "Symlink Pathname is empty", ENOENT, 1, no_setup },

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
