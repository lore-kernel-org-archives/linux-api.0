From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v6 1/6] x86/arch_prctl/64: Use SYSCALL_DEFINE2 to define sys_arch_prctl
Date: Mon, 26 Sep 2016 14:53:13 -0700
Message-ID: <20160926215318.9587-2-khuey@kylehuey.com>
References: <20160926215318.9587-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160926215318.9587-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, Len Brown <len.brown@intel.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/x86/kernel/process_64.c | 3 ++-
 arch/x86/um/syscalls_64.c    | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 63236d8..4d6363c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -35,6 +35,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
+#include <linux/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -585,7 +586,7 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
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
-- 
2.9.3

base-commit: 08895a8b6b06ed2323cd97a36ee40a116b3db8ed
