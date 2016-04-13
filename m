From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH 2/2] x86: Wire up new getumask system call on x86.
Date: Wed, 13 Apr 2016 12:43:06 +0100
Message-ID: <1460547786-16766-3-git-send-email-rjones@redhat.com>
References: <1460547786-16766-1-git-send-email-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460547786-16766-1-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index b30dd81..af0a032 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -386,3 +386,4 @@
 377	i386	copy_file_range		sys_copy_file_range
 378	i386	preadv2			sys_preadv2
 379	i386	pwritev2		sys_pwritev2
+380	i386	getumask		sys_getumask
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index cac6d17..47c1579 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -335,6 +335,7 @@
 326	common	copy_file_range		sys_copy_file_range
 327	64	preadv2			sys_preadv2
 328	64	pwritev2		sys_pwritev2
+329	common	getumask		sys_getumask
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
-- 
2.7.4
