From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 2/2] arch: wire-up clone6() syscall on x86
Date: Sun, 26 May 2019 12:26:12 +0200
Message-ID: <20190526102612.6970-2-christian@brauner.io>
References: <20190526102612.6970-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190526102612.6970-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, jannh@google.com
Cc: fweimer@redhat.com, oleg@redhat.com, arnd@arndb.de, dhowells@redhat.com, Christian Brauner <christian@brauner.io>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Wire up the clone6() call on x86.

This patch only wires up clone6() on x86. Some of the arches look like they
need special assembly massaging and it is probably smarter if the
appropriate arch maintainers would do the actual wiring.

Signed-off-by: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Adrian Reber <adrian@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 include/uapi/asm-generic/unistd.h      | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index ad968b7bac72..dffcd57990b3 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -438,3 +438,4 @@
 431	i386	fsconfig		sys_fsconfig			__ia32_sys_fsconfig
 432	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
 433	i386	fspick			sys_fspick			__ia32_sys_fspick
+436	i386	clone6			sys_clone6			__ia32_sys_clone6
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index b4e6f9e6204a..73bf4cc099a2 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -355,6 +355,7 @@
 431	common	fsconfig		__x64_sys_fsconfig
 432	common	fsmount			__x64_sys_fsmount
 433	common	fspick			__x64_sys_fspick
+436	common	clone6			__x64_sys_clone6/ptregs
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index a87904daf103..500bdb4c5e36 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -844,9 +844,11 @@ __SYSCALL(__NR_fsconfig, sys_fsconfig)
 __SYSCALL(__NR_fsmount, sys_fsmount)
 #define __NR_fspick 433
 __SYSCALL(__NR_fspick, sys_fspick)
+#define __NR_clone6 436
+__SYSCALL(__NR_clone6, sys_clone6)
 
 #undef __NR_syscalls
-#define __NR_syscalls 434
+#define __NR_syscalls 437
 
 /*
  * 32 bit systems traditionally used different
-- 
2.21.0
