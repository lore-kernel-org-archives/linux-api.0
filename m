From: Kyle Huey <me@kylehuey.com>
Subject: [PATCH v7 3/6] x86/arch_prctl: Add do_arch_prctl_common
Date: Tue, 18 Oct 2016 19:03:30 -0700
Message-ID: <20161019020333.3766-4-khuey@kylehuey.com>
References: <20161019020333.3766-1-khuey@kylehuey.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161019020333.3766-1-khuey@kylehuey.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert O'Callahan <robert@ocallahan.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Dmitry Safonov <dsafonov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>
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
index 0888a87..d0126b2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -584,3 +584,8 @@ unsigned long get_wchan(struct task_struct *p)
 	put_task_stack(p);
 	return ret;
 }
+
+long do_arch_prctl_common(struct task_struct *task, int code, unsigned long arg2)
+{
+	return -EINVAL;
+}
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 611df20..bf75d26 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -617,7 +617,13 @@ long do_arch_prctl_64(struct task_struct *task, int code, unsigned long arg2)
 
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
2.10.1
