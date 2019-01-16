From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/5] ipc: introduce ksys_ipc()/compat_ksys_ipc() for s390
Date: Wed, 16 Jan 2019 14:15:20 +0100
Message-ID: <20190116131527.2071570-3-arnd@arndb.de>
References: <20190116131527.2071570-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190116131527.2071570-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org, Dominik Brodowski <linux@dominikbrodowski.net>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The sys_ipc() and compat_ksys_ipc() functions are meant to only
be used from the system call table, not called by another function.

Introduce ksys_*() interfaces for this purpose, as we have done
for many other system calls.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/s390/kernel/compat_linux.c |  2 +-
 arch/s390/kernel/sys_s390.c     |  2 +-
 include/linux/syscalls.h        |  4 ++++
 ipc/syscall.c                   | 20 ++++++++++++++++----
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 8ac38d51ed7d..a47f6d3c6d5b 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -296,7 +296,7 @@ COMPAT_SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, compat_ulong_t, second,
 {
 	if (call >> 16)		/* hack for backward compatibility */
 		return -EINVAL;
-	return compat_sys_ipc(call, first, second, third, ptr, third);
+	return compat_ksys_ipc(call, first, second, third, ptr, third);
 }
 #endif
 
diff --git a/arch/s390/kernel/sys_s390.c b/arch/s390/kernel/sys_s390.c
index 560bdaf8a74f..6aa8fe00b39e 100644
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -74,7 +74,7 @@ SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
 	 * Therefore we can call the generic variant by simply passing the
 	 * third parameter also as fifth parameter.
 	 */
-	return sys_ipc(call, first, second, third, ptr, third);
+	return ksys_ipc(call, first, second, third, ptr, third);
 }
 
 SYSCALL_DEFINE1(s390_personality, unsigned int, personality)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 257cccba3062..fb63045a0fb6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1185,6 +1185,10 @@ unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
 			      unsigned long prot, unsigned long flags,
 			      unsigned long fd, unsigned long pgoff);
 ssize_t ksys_readahead(int fd, loff_t offset, size_t count);
+int ksys_ipc(unsigned int call, int first, unsigned long second,
+	unsigned long third, void __user * ptr, long fifth);
+int compat_ksys_ipc(u32 call, int first, int second,
+	u32 third, u32 ptr, u32 fifth);
 
 /*
  * The following kernel syscall equivalents are just wrappers to fs-internal
diff --git a/ipc/syscall.c b/ipc/syscall.c
index 1ac06e3983c0..3cf8ad703a4d 100644
--- a/ipc/syscall.c
+++ b/ipc/syscall.c
@@ -17,8 +17,8 @@
 #include <linux/shm.h>
 #include <linux/uaccess.h>
 
-SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
-		unsigned long, third, void __user *, ptr, long, fifth)
+int ksys_ipc(unsigned int call, int first, unsigned long second,
+	unsigned long third, void __user * ptr, long fifth)
 {
 	int version, ret;
 
@@ -106,6 +106,12 @@ SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
 		return -ENOSYS;
 	}
 }
+
+SYSCALL_DEFINE6(ipc, unsigned int, call, int, first, unsigned long, second,
+		unsigned long, third, void __user *, ptr, long, fifth)
+{
+	return ksys_ipc(call, first, second, third, ptr, fifth);
+}
 #endif
 
 #ifdef CONFIG_COMPAT
@@ -121,8 +127,8 @@ struct compat_ipc_kludge {
 };
 
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
-COMPAT_SYSCALL_DEFINE6(ipc, u32, call, int, first, int, second,
-	u32, third, compat_uptr_t, ptr, u32, fifth)
+int compat_ksys_ipc(u32 call, int first, int second,
+	u32 third, compat_uptr_t ptr, u32 fifth)
 {
 	int version;
 	u32 pad;
@@ -195,5 +201,11 @@ COMPAT_SYSCALL_DEFINE6(ipc, u32, call, int, first, int, second,
 
 	return -ENOSYS;
 }
+
+COMPAT_SYSCALL_DEFINE6(ipc, u32, call, int, first, int, second,
+	u32, third, compat_uptr_t, ptr, u32, fifth)
+{
+	return compat_ksys_ipc(call, first, second, third, ptr, fifth);
+}
 #endif
 #endif
-- 
2.20.0
