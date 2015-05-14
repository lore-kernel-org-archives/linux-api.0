From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/23] userfaultfd: uAPI
Date: Thu, 14 May 2015 19:31:00 +0200
Message-ID: <1431624680-20153-4-git-send-email-aarcange@redhat.com>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431624680-20153-1-git-send-email-aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sanidhya Kashyap <sanidhya.gatech-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, zhang.zhanghailiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Huangpeng (Peter)" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Defines the uAPI of the userfaultfd, notably the ioctl numbers and protocol.

Signed-off-by: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ioctl/ioctl-number.txt |  1 +
 include/uapi/linux/Kbuild            |  1 +
 include/uapi/linux/userfaultfd.h     | 81 ++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)
 create mode 100644 include/uapi/linux/userfaultfd.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index ec7c81b..ed950ad 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -302,6 +302,7 @@ Code  Seq#(hex)	Include File		Comments
 0xA3	80-8F	Port ACL		in development:
 					<mailto:tlewis-mn4gwa5WIIQysxA8WJXlww@public.gmane.org>
 0xA3	90-9F	linux/dtlk.h
+0xAA	00-3F	linux/uapi/linux/userfaultfd.h
 0xAB	00-1F	linux/nbd.h
 0xAC	00-1F	linux/raw.h
 0xAD	00	Netfilter device	in development:
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 4842a98..47547ea 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -452,3 +452,4 @@ header-y += xfrm.h
 header-y += xilinx-v4l2-controls.h
 header-y += zorro.h
 header-y += zorro_ids.h
+header-y += userfaultfd.h
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
new file mode 100644
index 0000000..9a8cd56
--- /dev/null
+++ b/include/uapi/linux/userfaultfd.h
@@ -0,0 +1,81 @@
+/*
+ *  include/linux/userfaultfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
+ *  Copyright (C) 2015  Red Hat, Inc.
+ *
+ */
+
+#ifndef _LINUX_USERFAULTFD_H
+#define _LINUX_USERFAULTFD_H
+
+#define UFFD_API ((__u64)0xAA)
+/* FIXME: add "|UFFD_BIT_WP" to UFFD_API_BITS after implementing it */
+#define UFFD_API_BITS (UFFD_BIT_WRITE)
+#define UFFD_API_IOCTLS				\
+	((__u64)1 << _UFFDIO_REGISTER |		\
+	 (__u64)1 << _UFFDIO_UNREGISTER |	\
+	 (__u64)1 << _UFFDIO_API)
+#define UFFD_API_RANGE_IOCTLS			\
+	((__u64)1 << _UFFDIO_WAKE)
+
+/*
+ * Valid ioctl command number range with this API is from 0x00 to
+ * 0x3F.  UFFDIO_API is the fixed number, everything else can be
+ * changed by implementing a different UFFD_API. If sticking to the
+ * same UFFD_API more ioctl can be added and userland will be aware of
+ * which ioctl the running kernel implements through the ioctl command
+ * bitmask written by the UFFDIO_API.
+ */
+#define _UFFDIO_REGISTER		(0x00)
+#define _UFFDIO_UNREGISTER		(0x01)
+#define _UFFDIO_WAKE			(0x02)
+#define _UFFDIO_API			(0x3F)
+
+/* userfaultfd ioctl ids */
+#define UFFDIO 0xAA
+#define UFFDIO_API		_IOWR(UFFDIO, _UFFDIO_API,	\
+				      struct uffdio_api)
+#define UFFDIO_REGISTER		_IOWR(UFFDIO, _UFFDIO_REGISTER, \
+				      struct uffdio_register)
+#define UFFDIO_UNREGISTER	_IOR(UFFDIO, _UFFDIO_UNREGISTER,	\
+				     struct uffdio_range)
+#define UFFDIO_WAKE		_IOR(UFFDIO, _UFFDIO_WAKE,	\
+				     struct uffdio_range)
+
+/*
+ * Valid bits below PAGE_SHIFT in the userfault address read through
+ * the read() syscall.
+ */
+#define UFFD_BIT_WRITE	(1<<0)	/* this was a write fault, MISSING or WP */
+#define UFFD_BIT_WP	(1<<1)	/* handle_userfault() reason VM_UFFD_WP */
+#define UFFD_BITS	2	/* two above bits used for UFFD_BIT_* mask */
+
+struct uffdio_api {
+	/* userland asks for an API number */
+	__u64 api;
+
+	/* kernel answers below with the available features for the API */
+	__u64 bits;
+	__u64 ioctls;
+};
+
+struct uffdio_range {
+	__u64 start;
+	__u64 len;
+};
+
+struct uffdio_register {
+	struct uffdio_range range;
+#define UFFDIO_REGISTER_MODE_MISSING	((__u64)1<<0)
+#define UFFDIO_REGISTER_MODE_WP		((__u64)1<<1)
+	__u64 mode;
+
+	/*
+	 * kernel answers which ioctl commands are available for the
+	 * range, keep at the end as the last 8 bytes aren't read.
+	 */
+	__u64 ioctls;
+};
+
+#endif /* _LINUX_USERFAULTFD_H */
