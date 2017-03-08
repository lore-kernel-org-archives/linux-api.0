From: Greg KH <gregkh@linuxfoundation.org>
Subject: [resend PATCH 1/2] eventpoll.h: fix epoll event masks
Date: Wed, 8 Mar 2017 19:03:03 +0100
Message-ID: <20170308180303.GB10747@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: enh@google.com
List-Id: linux-api@vger.kernel.org

[resend due to me forgetting to cc: linux-api the first time around I
posted these back on Feb 23]

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When userspace tries to use these defines, it complains that it needs to
be an unsigned 1 that is shifted, so libc implementations have to create
their own version.  Fix this by defining it properly so that libcs can
just use the kernel uapi header.

Reported-by: Elliott Hughes <enh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/eventpoll.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -27,7 +27,7 @@
 #define EPOLL_CTL_MOD 3
 
 /* Set exclusive wakeup mode for the target file descriptor */
-#define EPOLLEXCLUSIVE (1 << 28)
+#define EPOLLEXCLUSIVE (1U << 28)
 
 /*
  * Request the handling of system wakeup events so as to prevent system suspends
@@ -39,13 +39,13 @@
  *
  * Requires CAP_BLOCK_SUSPEND
  */
-#define EPOLLWAKEUP (1 << 29)
+#define EPOLLWAKEUP (1U << 29)
 
 /* Set the One Shot behaviour for the target file descriptor */
-#define EPOLLONESHOT (1 << 30)
+#define EPOLLONESHOT (1U << 30)
 
 /* Set the Edge Triggered behaviour for the target file descriptor */
-#define EPOLLET (1 << 31)
+#define EPOLLET (1U << 31)
 
 /* 
  * On x86-64 make the 64bit structure have the same alignment as the
