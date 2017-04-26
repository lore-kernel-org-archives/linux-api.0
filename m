From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] uapi: change the type of struct statx_timestamp.tv_nsec to
 unsigned
Date: Wed, 26 Apr 2017 14:50:00 +0100
Message-ID: <149321460018.18277.7857539856722003605.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>

The comment asserting that the value of struct statx_timestamp.tv_nsec
must be negative when statx_timestamp.tv_sec is negative, is wrong, as
could be seen from the following example:

	#define _FILE_OFFSET_BITS 64
	#include <assert.h>
	#include <fcntl.h>
	#include <stdio.h>
	#include <sys/stat.h>
	#include <unistd.h>
	#include <asm/unistd.h>
	#include <linux/stat.h>

	int main(void)
	{
		static const struct timespec ts[2] = {
			{ .tv_nsec = UTIME_OMIT },
			{ .tv_sec = -2, .tv_nsec = 42 }
		};
		assert(utimensat(AT_FDCWD, ".", ts, 0) == 0);

		struct stat st;
		assert(stat(".", &st) == 0);
		printf("st_mtim.tv_sec = %lld, st_mtim.tv_nsec = %lu\n",
		       (long long) st.st_mtim.tv_sec,
		       (unsigned long) st.st_mtim.tv_nsec);

		struct statx stx;
		assert(syscall(__NR_statx, AT_FDCWD, ".", 0, 0, &stx) == 0);
		printf("stx_mtime.tv_sec = %lld, stx_mtime.tv_nsec = %lu\n",
		       (long long) stx.stx_mtime.tv_sec,
		       (unsigned long) stx.stx_mtime.tv_nsec);

		return 0;
	}

It expectedly prints:
st_mtim.tv_sec = -2, st_mtim.tv_nsec = 42
stx_mtime.tv_sec = -2, stx_mtime.tv_nsec = 42

The more generic comment asserting that the value of struct
statx_timestamp.tv_nsec might be negative is confusing to say the least.

It contradicts both the struct stat.st_[acm]time_nsec tradition and
struct timespec.tv_nsec requirements in utimensat syscall.
If statx syscall ever returns a stx_[acm]time containing a negative
tv_nsec that cannot be passed unmodified to utimensat syscall,
it will cause an immense confusion.

Fix this source of confusion by changing the type of struct
statx_timestamp.tv_nsec from __s32 to __u32.

Fixes: a528d35e8bfc ("statx: Add a system call to make enhanced file info available")
Signed-off-by: Dmitry V. Levin <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
---

 include/uapi/linux/stat.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index d538897b8e08..17b10304c393 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -48,17 +48,13 @@
  * tv_sec holds the number of seconds before (negative) or after (positive)
  * 00:00:00 1st January 1970 UTC.
  *
- * tv_nsec holds a number of nanoseconds before (0..-999,999,999 if tv_sec is
- * negative) or after (0..999,999,999 if tv_sec is positive) the tv_sec time.
- *
- * Note that if both tv_sec and tv_nsec are non-zero, then the two values must
- * either be both positive or both negative.
+ * tv_nsec holds a number of nanoseconds (0..999,999,999) after the tv_sec time.
  *
  * __reserved is held in case we need a yet finer resolution.
  */
 struct statx_timestamp {
 	__s64	tv_sec;
-	__s32	tv_nsec;
+	__u32	tv_nsec;
 	__s32	__reserved;
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
