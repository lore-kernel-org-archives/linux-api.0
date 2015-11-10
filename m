From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH 5/5] livepatch: x86: remove unused relocation code
Date: Mon,  9 Nov 2015 23:45:55 -0500
Message-ID: <1447130755-17383-6-git-send-email-jeyu@redhat.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Architecture-specific relocation code no longer needed, since symbol
resolution and relocation work will be offloaded to module loader.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 arch/x86/kernel/Makefile    |  1 -
 arch/x86/kernel/livepatch.c | 91 ---------------------------------------------
 2 files changed, 92 deletions(-)
 delete mode 100644 arch/x86/kernel/livepatch.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b1b78ff..c5e9a5c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,7 +67,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
-obj-$(CONFIG_LIVEPATCH)		+= livepatch.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_X86_TSC)		+= trace_clock.o
diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
deleted file mode 100644
index d1d35cc..0000000
--- a/arch/x86/kernel/livepatch.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * livepatch.c - x86-specific Kernel Live Patching Core
- *
- * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
- * Copyright (C) 2014 SUSE
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/module.h>
-#include <linux/uaccess.h>
-#include <asm/cacheflush.h>
-#include <asm/page_types.h>
-#include <asm/elf.h>
-#include <asm/livepatch.h>
-
-/**
- * klp_write_module_reloc() - write a relocation in a module
- * @mod:	module in which the section to be modified is found
- * @type:	ELF relocation type (see asm/elf.h)
- * @loc:	address that the relocation should be written to
- * @value:	relocation value (sym address + addend)
- *
- * This function writes a relocation to the specified location for
- * a particular module.
- */
-int klp_write_module_reloc(struct module *mod, unsigned long type,
-			   unsigned long loc, unsigned long value)
-{
-	int ret, numpages, size = 4;
-	bool readonly;
-	unsigned long val;
-	unsigned long core = (unsigned long)mod->module_core;
-	unsigned long core_size = mod->core_size;
-
-	switch (type) {
-	case R_X86_64_NONE:
-		return 0;
-	case R_X86_64_64:
-		val = value;
-		size = 8;
-		break;
-	case R_X86_64_32:
-		val = (u32)value;
-		break;
-	case R_X86_64_32S:
-		val = (s32)value;
-		break;
-	case R_X86_64_PC32:
-		val = (u32)(value - loc);
-		break;
-	default:
-		/* unsupported relocation type */
-		return -EINVAL;
-	}
-
-	if (loc < core || loc >= core + core_size)
-		/* loc does not point to any symbol inside the module */
-		return -EINVAL;
-
-	readonly = false;
-
-#ifdef CONFIG_DEBUG_SET_MODULE_RONX
-	if (loc < core + mod->core_ro_size)
-		readonly = true;
-#endif
-
-	/* determine if the relocation spans a page boundary */
-	numpages = ((loc & PAGE_MASK) == ((loc + size) & PAGE_MASK)) ? 1 : 2;
-
-	if (readonly)
-		set_memory_rw(loc & PAGE_MASK, numpages);
-
-	ret = probe_kernel_write((void *)loc, &val, size);
-
-	if (readonly)
-		set_memory_ro(loc & PAGE_MASK, numpages);
-
-	return ret;
-}
-- 
2.4.3
