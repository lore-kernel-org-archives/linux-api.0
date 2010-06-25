From: Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] Add wait4() back to the set of <asm-generic/unistd.h> syscalls.
Date: Fri, 25 Jun 2010 14:54:16 -0400
Message-ID: <201006251901.o5PJ1dsI023955@farm-0002.internal.tilera.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The initial pass at the generic ABI assumed that wait4() could be
easily expressed using waitid().  Although it's true that wait4()
can be built on waitid(), it's awkward enough that it makes more
sense to continue to include wait4 in the generic syscall ABI.

Since there is already a deprecated wait4 in the ABI, this change
converts that wait4 into old_wait, and puts wait4 in the next
available slot for new supported syscalls, after the platform-specific
syscalls at number 260.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/unistd.h |    9 ++++++---
 scripts/checksyscalls.sh     |    1 -
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 30218b4..c17cebc 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -638,8 +638,11 @@ __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
  */
 #define __NR_arch_specific_syscall 244
 
+#define __NR_wait4 260
+__SYSCALL(__NR_wait4, sys_wait4)
+
 #undef __NR_syscalls
-#define __NR_syscalls 260
+#define __NR_syscalls 261
 
 /*
  * All syscalls below here should go away really,
@@ -776,8 +779,8 @@ __SYSCALL(__NR_epoll_wait, sys_epoll_wait)
 __SYSCALL(__NR_ustat, sys_ustat)
 #define __NR_vfork 1071
 __SYSCALL(__NR_vfork, sys_vfork)
-#define __NR_wait4 1072
-__SYSCALL(__NR_wait4, sys_wait4)
+#define __NR_oldwait4 1072
+__SYSCALL(__NR_oldwait4, sys_wait4)
 #define __NR_recv 1073
 __SYSCALL(__NR_recv, sys_recv)
 #define __NR_send 1074
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 66ad375..6bb42e7 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -183,7 +183,6 @@ cat << EOF
 #define __IGNORE_ustat		/* statfs */
 #define __IGNORE_utime		/* utimes */
 #define __IGNORE_vfork		/* clone */
-#define __IGNORE_wait4		/* waitid */
 
 /* sync_file_range had a stupid ABI. Allow sync_file_range2 instead */
 #ifdef __NR_sync_file_range2
-- 
1.6.5.2
