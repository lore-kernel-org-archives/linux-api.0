From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v7 1/6] x86/arch_prctl/64: Use SYSCALL_DEFINE2 to define sys_arch_prctl
Date: Tue, 18 Oct 2016 19:03:28 -0700
Message-ID: <20161019020333.3766-2-khuey@kylehuey.com>
References: <20161019020333.3766-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161019020333.3766-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/x86/kernel/process_64.c | 3 ++-
 arch/x86/um/syscalls_64.c    | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index b3760b3..2718cf9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -35,6 +35,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -612,7 +613,7 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 	return ret;
 }
 
-long sys_arch_prctl(int code, unsigned long addr)
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, addr)
 {
 	return do_arch_prctl(current, code, addr);
 }
diff --git a/arch/x86/um/syscalls_64.c b/arch/x86/um/syscalls_64.c
index e655227..ab3f7f4 100644
--- a/arch/x86/um/syscalls_64.c
+++ b/arch/x86/um/syscalls_64.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <asm/prctl.h> /* XXX This should get the constants from libc */
 #include <os.h>
@@ -72,7 +73,7 @@ long arch_prctl(struct task_struct *task, int code, unsigned long __user *addr)
 	return ret;
 }
 
-long sys_arch_prctl(int code, unsigned long addr)
+SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, addr)
 {
 	return arch_prctl(current, code, (unsigned long __user *) addr);
 }

base-commit: 1001354ca34179f3db924eb66672442a173147dc
-- 
2.10.1
