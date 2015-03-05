From: Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH 13/21] userfaultfd: UFFDIO_COPY|UFFDIO_ZEROPAGE uAPI
Date: Thu,  5 Mar 2015 18:17:56 +0100
Message-ID: <1425575884-2574-14-git-send-email-aarcange@redhat.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1425575884-2574-1-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Android Kernel Team <kernel-team@android.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
List-Id: linux-api@vger.kernel.org

This implements the uABI of UFFDIO_COPY and UFFDIO_ZEROPAGE.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/uapi/linux/userfaultfd.h | 46 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 9a8cd56..61251e6 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -17,7 +17,9 @@
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
 	 (__u64)1 << _UFFDIO_API)
 #define UFFD_API_RANGE_IOCTLS			\
-	((__u64)1 << _UFFDIO_WAKE)
+	((__u64)1 << _UFFDIO_WAKE |		\
+	 (__u64)1 << _UFFDIO_COPY |		\
+	 (__u64)1 << _UFFDIO_ZEROPAGE)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
@@ -30,6 +32,8 @@
 #define _UFFDIO_REGISTER		(0x00)
 #define _UFFDIO_UNREGISTER		(0x01)
 #define _UFFDIO_WAKE			(0x02)
+#define _UFFDIO_COPY			(0x03)
+#define _UFFDIO_ZEROPAGE		(0x04)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -42,6 +46,10 @@
 				     struct uffdio_range)
 #define UFFDIO_WAKE		_IOR(UFFDIO, _UFFDIO_WAKE,	\
 				     struct uffdio_range)
+#define UFFDIO_COPY		_IOWR(UFFDIO, _UFFDIO_COPY,	\
+				      struct uffdio_copy)
+#define UFFDIO_ZEROPAGE		_IOWR(UFFDIO, _UFFDIO_ZEROPAGE,	\
+				      struct uffdio_zeropage)
 
 /*
  * Valid bits below PAGE_SHIFT in the userfault address read through
@@ -78,4 +86,40 @@ struct uffdio_register {
 	__u64 ioctls;
 };
 
+struct uffdio_copy {
+	__u64 dst;
+	__u64 src;
+	__u64 len;
+	/*
+	 * There will be a wrprotection flag later that allows to map
+	 * pages wrprotected on the fly. And such a flag will be
+	 * available if the wrprotection ioctl are implemented for the
+	 * range according to the uffdio_register.ioctls.
+	 */
+#define UFFDIO_COPY_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * "copy" and "wake" are written by the ioctl and must be at
+	 * the end: the copy_from_user will not read the last 16
+	 * bytes.
+	 */
+	__s64 copy;
+	__s64 wake;
+};
+
+struct uffdio_zeropage {
+	struct uffdio_range range;
+#define UFFDIO_ZEROPAGE_MODE_DONTWAKE		((__u64)1<<0)
+	__u64 mode;
+
+	/*
+	 * "zeropage" and "wake" are written by the ioctl and must be
+	 * at the end: the copy_from_user will not read the last 16
+	 * bytes.
+	 */
+	__s64 zeropage;
+	__s64 wake;
+};
+
 #endif /* _LINUX_USERFAULTFD_H */

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
