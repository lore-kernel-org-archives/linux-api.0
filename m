From: Dmitry Safonov <dima@arista.com>
Subject: [PATCHv5 28/37] x86/vdso: Enable static branches for the timens vdso
Date: Mon, 29 Jul 2019 22:57:10 +0100
Message-ID: <20190729215758.28405-29-dima@arista.com>
References: <20190729215758.28405-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729215758.28405-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api
List-Id: linux-api@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

As it has been discussed on timens RFC, adding a new conditional branch
`if (inside_time_ns)` on VDSO for all processes is undesirable.

Addressing those problems, there are two versions of VDSO's .so:
for host tasks (without any penalty) and for processes inside of time
namespace with clk_to_ns() that subtracts offsets from host's time.

The timens code in vdso looks like this:

if (timens_static_branch_unlikely()) {
       clk_to_ns(clk, ts);
}

This static branch is disabled by default. And the code generated consist
of a single atomic 'no-op' instruction, in the straight-line code path.

Enable static branches in the timens vdso: the 'no-op' instruction
gets replaced with a 'jump' instruction to the out-of-line true branch.

Signed-off-by: Andrei Vagin <avagin@gmail.com>
Co-developed-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/vma.c    | 30 ++++++++++++++++++++++++------
 arch/x86/kernel/jump_label.c | 14 ++++++++++++++
 include/linux/jump_label.h   |  8 ++++++++
 init/Kconfig                 |  1 +
 4 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 91cf5a5c8c9e..1a3eb4656eb6 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -15,6 +15,7 @@
 #include <linux/cpu.h>
 #include <linux/ptrace.h>
 #include <linux/time_namespace.h>
+#include <linux/jump_label.h>
 #include <asm/pvclock.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
@@ -31,20 +32,37 @@
 unsigned int __read_mostly vdso64_enabled = 1;
 #endif
 
-void __init init_vdso_image(struct vdso_image *image)
+#ifdef CONFIG_TIME_NS
+static __init void init_timens(struct vdso_image *image)
 {
-	BUG_ON(image->size % PAGE_SIZE != 0);
+	struct vdso_jump_entry *entries;
+	unsigned long entries_nr;
+
+	if (WARN_ON(image->jump_table == -1UL))
+		return;
 
-	apply_alternatives((struct alt_instr *)(image->text + image->alt),
-			   (struct alt_instr *)(image->text + image->alt +
-						image->alt_len));
-#ifdef CONFIG_TIME_NS
 	image->text_timens = vmalloc_32(image->size);
 	if (WARN_ON(image->text_timens == NULL))
 		return;
 
 	memcpy(image->text_timens, image->text, image->size);
+
+	entries = image->text_timens + image->jump_table;
+	entries_nr = image->jump_table_len / sizeof(struct vdso_jump_entry);
+	apply_vdso_jump_labels(entries, entries_nr);
+}
+#else
+static inline void init_timens(struct vdso_image *image) {}
 #endif
+
+void __init init_vdso_image(struct vdso_image *image)
+{
+	BUG_ON(image->size % PAGE_SIZE != 0);
+
+	apply_alternatives((struct alt_instr *)(image->text + image->alt),
+			   (struct alt_instr *)(image->text + image->alt +
+						image->alt_len));
+	init_timens(image);
 }
 
 struct linux_binprm;
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 044053235302..7820ac61b688 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,6 +24,20 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
+__init void apply_vdso_jump_labels(struct vdso_jump_entry *ent, unsigned long nr)
+{
+	while (nr--) {
+		void *code_addr	= (void *)ent + ent->code;
+		union jump_code_union jmp;
+
+		jmp.jump	= 0xe9; /* JMP rel32 */
+		jmp.offset	= ent->target - ent->code - JUMP_LABEL_NOP_SIZE;
+		memcpy(code_addr, &jmp, JUMP_LABEL_NOP_SIZE);
+
+		ent++;
+	}
+}
+
 static void bug_at(unsigned char *ip, int line)
 {
 	/*
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 3526c0aee954..bb9d828ee49a 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -125,6 +125,11 @@ struct jump_entry {
 	long key;	// key may be far away from the core kernel under KASLR
 };
 
+struct vdso_jump_entry {
+	u16 code;
+	u16 target;
+};
+
 static inline unsigned long jump_entry_code(const struct jump_entry *entry)
 {
 	return (unsigned long)&entry->code + entry->code;
@@ -229,6 +234,9 @@ extern void static_key_enable(struct static_key *key);
 extern void static_key_disable(struct static_key *key);
 extern void static_key_enable_cpuslocked(struct static_key *key);
 extern void static_key_disable_cpuslocked(struct static_key *key);
+extern void apply_vdso_jump_labels(struct vdso_jump_entry *ent,
+				   unsigned long nr);
+
 
 /*
  * We should be using ATOMIC_INIT() for initializing .enabled, but
diff --git a/init/Kconfig b/init/Kconfig
index 9e40c07da4e1..be8bd41774f6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1072,6 +1072,7 @@ config UTS_NS
 config TIME_NS
 	bool "TIME namespace"
 	depends on ARCH_HAS_VDSO_TIME_NS
+	depends on JUMP_LABEL
 	default y
 	help
 	  In this namespace boottime and monotonic clocks can be set.
-- 
2.22.0
