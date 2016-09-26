From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v6 3/6] x86/arch_prctl: Add do_arch_prctl_common
Date: Mon, 26 Sep 2016 14:53:15 -0700
Message-ID: <20160926215318.9587-4-khuey@kylehuey.com>
References: <20160926215318.9587-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160926215318.9587-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, Len Brown <len.brown@intel.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, user-mode-linux-user@lists.sourceforge.net, linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add do_arch_prctl_common to handle arch_prctls that are not specific to 64
bits. Call it from the syscall entry point, but not any of the other
callsites in the kernel, which all want one of the existing 64 bit only
arch_prctls.

Signed-off-by: Kyle Huey <khuey@kylehuey.com>
---
 arch/x86/include/asm/proto.h | 1 +
 arch/x86/kernel/process.c    | 5 +++++
 arch/x86/kernel/process_64.c | 8 +++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 95c3e51..f72b551 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -30,6 +30,7 @@ void x86_report_nx(void);
 
 extern int reboot_force;
 
+long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2);
 #ifdef CONFIG_X86_64
 long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2);
 #endif
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 62c0b0e..5106cc9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -567,3 +567,8 @@ unsigned long get_wchan(struct task_struct *p)
 	} while (count++ < 16 && p->state != TASK_RUNNING);
 	return 0;
 }
+
+long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2)
+{
+	return -EINVAL;
+}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 292ce48..0e44608 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -590,7 +590,13 @@ long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2)
 
 SYSCALL_DEFINE2(arch_prctl, int, code, unsigned long, arg2)
 {
-	return do_arch_prctl_64(current, code, arg2);
+	long ret;
+
+	ret = do_arch_prctl_64(current, code, arg2);
+	if (ret == -EINVAL)
+		ret = do_arch_prctl_common(current, code, arg2);
+
+	return ret;
 }
 
 unsigned long KSTK_ESP(struct task_struct *task)
-- 
2.9.3
