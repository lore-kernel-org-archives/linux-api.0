From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 16/32] x86/vdso: Generate vdso{,32}-timens.lds
Date: Wed,  6 Feb 2019 00:10:50 +0000
Message-ID: <20190206001107.16488-17-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

As it has been discussed on timens RFC, adding a new conditional branch
`if (inside_time_ns)` on VDSO for all processes is undesirable.
It will add a penalty for everybody as branch predictor may mispredict
the jump. Also there are instruction cache lines wasted on cmp/jmp.

Those effects of introducing time namespace are very much unwanted
having in mind how much work have been spent on micro-optimisation
vdso code.

Addressing those problems, there are two versions of VDSO's .so:
for host tasks (without any penalty) and for processes inside of time
namespace with clk_to_ns() that subtracts offsets from host's time.

Unfortunately, to allow changing VDSO VMA on a running process,
the entry points to VDSO should have the same offsets (addresses).
That's needed as i.e. application that calls setns() may have already
resolved VDSO symbols in GOT/PLT.

Provide two linker scripts:
- *-timens.lds for building VDSO for processes inside time namespace
  (it has bigger functions and needs to build firstly)
- *.lds for host processes VDSO
  (it has smaller functions and entry addresses should be adjusted
  with the linker script magic to fit with entries from timens)

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/.gitignore                 |  1 +
 arch/x86/entry/vdso/Makefile                   | 18 ++++++++++++++----
 arch/x86/entry/vdso/vdso-timens.lds.S          |  7 +++++++
 arch/x86/entry/vdso/vdso32/.gitignore          |  1 +
 arch/x86/entry/vdso/vdso32/vdso32-timens.lds.S |  8 ++++++++
 5 files changed, 31 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/entry/vdso/vdso-timens.lds.S
 create mode 100644 arch/x86/entry/vdso/vdso32/vdso32-timens.lds.S

diff --git a/arch/x86/entry/vdso/.gitignore b/arch/x86/entry/vdso/.gitignore
index 9ab4fa4c7e7b..aaddf8f2171c 100644
--- a/arch/x86/entry/vdso/.gitignore
+++ b/arch/x86/entry/vdso/.gitignore
@@ -1,4 +1,5 @@
 vdso.lds
+vdso-timens.lds
 vdsox32.lds
 vdso32-syscall-syms.lds
 vdso32-sysenter-syms.lds
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index ccb572831ea1..4e1659619e7e 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -44,11 +44,14 @@ vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 vobjs32 := $(foreach F,$(vobjs32-y),$(obj)/$F)
 vobjs-timens := $(foreach F,$(vobjs-timens-y),$(obj)/$F)
 vobjs32-timens := $(foreach F,$(vobjs32-timens-y),$(obj)/$F)
+dep-vdso.lds-$(CONFIG_TIME_NS) += $(obj)/vdso-image-64-timens.c
+dep-vdso32.lds-$(CONFIG_TIME_NS) += $(obj)/vdso-image-32-timens.c
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
 targets += vdso.lds $(vobjs-y) $(vobjs-timens-y) vdso64.entries
 targets += vdso32/vdso32.lds $(vobjs32-y) $(vobjs32-timens-y) vdso32.entries
+targets += vdso-timens.lds vdso32/vdso32-timens.lds
 
 # Build the vDSO image C files and link them in.
 vdso_img_objs := $(vdso_img-y:%=vdso-image-%.o)
@@ -59,11 +62,13 @@ targets += $(vdso_img_cfiles)
 targets += $(vdso_img_sodbg) $(vdso_img-y:%=vdso%.so)
 
 CPPFLAGS_vdso.lds += -P -C
+CPPFLAGS_vdso-timens.lds := $(CPPFLAGS_vdso.lds)
 
 VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 --no-undefined \
 			-z max-page-size=4096
+VDSO_LDFLAGS_vdso-timens.lds := $(VDSO_LDFLAGS_vdso.lds)
 
-$(obj)/vdso64-timens.so.dbg: $(obj)/vdso.lds $(vobjs-timens) FORCE
+$(obj)/vdso64-timens.so.dbg: $(obj)/vdso-timens.lds $(vobjs-timens) FORCE
 	$(call if_changed,vdso)
 
 $(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
@@ -79,6 +84,9 @@ quiet_cmd_vdso2c = VDSO2C  $@
 $(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 	$(call if_changed,vdso2c)
 
+$(obj)/vdso.lds: $(dep-vdso.lds-y) $(obj)/vdso2c FORCE
+$(obj)/vdso32/vdso32.lds: $(dep-vdso32.lds-y) $(obj)/vdso2c FORCE
+
 #
 # Don't omit frame pointers for ease of userspace debugging, but do
 # optimize sibling calls.
@@ -142,8 +150,10 @@ $(obj)/%.so: $(obj)/%.so.dbg
 $(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
 	$(call if_changed,vdso)
 
-CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
-VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -soname linux-gate.so.1
+CPPFLAGS_vdso32.lds := $(CPPFLAGS_vdso.lds)
+CPPFLAGS_vdso32-timens.lds := $(CPPFLAGS_vdso32.lds)
+VDSO_LDFLAGS_vdso32.lds := -m elf_i386 -soname linux-gate.so.1
+VDSO_LDFLAGS_vdso32-timens.lds := $(VDSO_LDFLAGS_vdso32.lds)
 
 KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS)) -DBUILD_VDSO
 $(obj)/vdso32.so.dbg: KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
@@ -172,7 +182,7 @@ endif
 $(obj)/vdso32.so.dbg: KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 $(obj)/vdso32-timens.so.dbg: KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 
-$(obj)/vdso32-timens.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32-timens) FORCE
+$(obj)/vdso32-timens.so.dbg: $(obj)/vdso32/vdso32-timens.lds $(vobjs32-timens) FORCE
 	$(call if_changed,vdso)
 
 $(obj)/vdso32.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32) FORCE
diff --git a/arch/x86/entry/vdso/vdso-timens.lds.S b/arch/x86/entry/vdso/vdso-timens.lds.S
new file mode 100644
index 000000000000..687aba3bc5f0
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso-timens.lds.S
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Linker script for 64-bit timens vDSO.
+ */
+
+#define UNALIGNED_ENTRIES
+#include "vdso.lds.S"
diff --git a/arch/x86/entry/vdso/vdso32/.gitignore b/arch/x86/entry/vdso/vdso32/.gitignore
index e45fba9d0ced..ce4afb6ffb62 100644
--- a/arch/x86/entry/vdso/vdso32/.gitignore
+++ b/arch/x86/entry/vdso/vdso32/.gitignore
@@ -1 +1,2 @@
 vdso32.lds
+vdso32-timens.lds
diff --git a/arch/x86/entry/vdso/vdso32/vdso32-timens.lds.S b/arch/x86/entry/vdso/vdso32/vdso32-timens.lds.S
new file mode 100644
index 000000000000..1a3b3b1f0517
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso32/vdso32-timens.lds.S
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Linker script for 32-bit timens vDSO.
+ */
+
+#define UNALIGNED_ENTRIES
+
+#include "vdso32.lds.S"
-- 
2.20.1
