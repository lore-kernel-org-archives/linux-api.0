From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/17] y2038: aio: Prepare sys_io_getevents for __kernel_timespec
Date: Wed, 25 Apr 2018 18:03:06 +0200
Message-ID: <20180425160311.2718314-13-arnd@arndb.de>
References: <20180425160311.2718314-1-arnd@arndb.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180425160311.2718314-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: y2038@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, tglx@linutronix.de, netdev@vger.kernel.org, deepa.kernel@gmail.com, viro@zeniv.linux.org.uk, albert.aribaud@3adev.fr, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Dominik Brodowski <linux@dominikbrodowski.net>
List-Id: linux-api@vger.kernel.org

This is a preparation patch for converting sys_io_getevents to
work with 64-bit time_t on 32-bit architectures. The 'timeout' argument
is changed to struct __kernel_timespec, which will be redefined using
64-bit time_t in the future. The compat version of the system call in
turn is enabled for compilation with CONFIG_COMPAT_32BIT_TIME so
the individual 32-bit architectures can share the handling of the
traditional argument with 64-bit architectures providing it for their
compat mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/aio.c                 | 4 ++--
 include/linux/syscalls.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 88d7927ffbc6..64fea8c27b16 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1858,7 +1858,7 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 		long, min_nr,
 		long, nr,
 		struct io_event __user *, events,
-		struct timespec __user *, timeout)
+		struct __kernel_timespec __user *, timeout)
 {
 	struct timespec64	ts;
 
@@ -1870,7 +1870,7 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 	return do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
 }
 
-#ifdef CONFIG_COMPAT
+#ifdef CONFIG_COMPAT_32BIT_TIME
 COMPAT_SYSCALL_DEFINE5(io_getevents, compat_aio_context_t, ctx_id,
 		       compat_long_t, min_nr,
 		       compat_long_t, nr,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2619678359ee..ffd8674e9df7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -289,7 +289,7 @@ asmlinkage long sys_io_getevents(aio_context_t ctx_id,
 				long min_nr,
 				long nr,
 				struct io_event __user *events,
-				struct timespec __user *timeout);
+				struct __kernel_timespec __user *timeout);
 
 /* fs/xattr.c */
 asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
-- 
2.9.0
