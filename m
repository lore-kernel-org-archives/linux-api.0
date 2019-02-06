From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 13/32] x86/vdso: Build timens .so(s)
Date: Wed,  6 Feb 2019 00:10:47 +0000
Message-ID: <20190206001107.16488-14-dima@arista.com>
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

Addressing those problems, build two VDSO images instead.

At this moment timens is unsupported for x32 binaries (only x86_64 and
ia32). This may be added on top afterwards.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/Makefile                  | 28 +++++++++++++++++--
 arch/x86/entry/vdso/vclock_gettime-timens.c   |  6 ++++
 .../entry/vdso/vdso32/vclock_gettime-timens.c |  6 ++++
 3 files changed, 37 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/entry/vdso/vclock_gettime-timens.c
 create mode 100644 arch/x86/entry/vdso/vdso32/vclock_gettime-timens.c

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index bc0bdbf49397..2433ed9342fd 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -17,8 +17,12 @@ VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_IA32_EMULATION)	:= y
 
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
+vobjs-y := vdso-note.o vgetcpu.o
+vobjs-timens-y := $(vobjs-y) vclock_gettime-timens.o
+vobjs-y += vclock_gettime.o
+
 vobjs32-y := vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o
+vobjs32-timens-y := $(vobjs32-y) vdso32/vclock_gettime-timens.o
 vobjs32-y += vdso32/vclock_gettime.o
 
 # files to link into kernel
@@ -30,15 +34,21 @@ vdso_img-$(VDSO64-y)		+= 64
 vdso_img-$(VDSOX32-y)		+= x32
 vdso_img-$(VDSO32-y)		+= 32
 
+vdso_timens_img-$(VDSO64-y)	+= 64-timens
+vdso_timens_img-$(VDSO32-y)	+= 32-timens
+vdso_img-$(CONFIG_TIME_NS)	+= $(vdso_timens_img-y)
+
 obj-$(VDSO32-y)			+= vdso32-setup.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 vobjs32 := $(foreach F,$(vobjs32-y),$(obj)/$F)
+vobjs-timens := $(foreach F,$(vobjs-timens-y),$(obj)/$F)
+vobjs32-timens := $(foreach F,$(vobjs32-timens-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.lds $(vobjs-y)
-targets += vdso32/vdso32.lds $(vobjs32-y)
+targets += vdso.lds $(vobjs-y) $(vobjs-timens-y)
+targets += vdso32/vdso32.lds $(vobjs32-y) $(vobjs32-timens-y)
 
 # Build the vDSO image C files and link them in.
 vdso_img_objs := $(vdso_img-y:%=vdso-image-%.o)
@@ -53,6 +63,9 @@ CPPFLAGS_vdso.lds += -P -C
 VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 --no-undefined \
 			-z max-page-size=4096
 
+$(obj)/vdso64-timens.so.dbg: $(obj)/vdso.lds $(vobjs-timens) FORCE
+	$(call if_changed,vdso)
+
 $(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
 
@@ -81,12 +94,14 @@ endif
 endif
 
 $(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
+$(vobjs-timens): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
 #
 CFLAGS_REMOVE_vdso-note.o = -pg
 CFLAGS_REMOVE_vclock_gettime.o = -pg
+CFLAGS_REMOVE_vclock_gettime-timens.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
 CFLAGS_REMOVE_vvar.o = -pg
 
@@ -132,6 +147,8 @@ VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -soname linux-gate.so.1
 KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS)) -DBUILD_VDSO
 $(obj)/vdso32.so.dbg: KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
 $(obj)/vdso32.so.dbg: asflags-$(CONFIG_X86_64) += -m32
+$(obj)/vdso32-timens.so.dbg: KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
+$(obj)/vdso32-timens.so.dbg: asflags-$(CONFIG_X86_64) += -m32
 
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
@@ -152,6 +169,10 @@ endif
 endif
 
 $(obj)/vdso32.so.dbg: KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+$(obj)/vdso32-timens.so.dbg: KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
+
+$(obj)/vdso32-timens.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32-timens) FORCE
+	$(call if_changed,vdso)
 
 $(obj)/vdso32.so.dbg: $(obj)/vdso32/vdso32.lds $(vobjs32) FORCE
 	$(call if_changed,vdso)
@@ -198,3 +219,4 @@ PHONY += vdso_install $(vdso_img_insttargets)
 vdso_install: $(vdso_img_insttargets)
 
 clean-files := vdso32.so vdso32.so.dbg vdso64* vdso-image-*.c vdsox32.so*
+clean-files += vdso32-timens.so vdso32-timens.so.dbg
diff --git a/arch/x86/entry/vdso/vclock_gettime-timens.c b/arch/x86/entry/vdso/vclock_gettime-timens.c
new file mode 100644
index 000000000000..9e92315f83db
--- /dev/null
+++ b/arch/x86/entry/vdso/vclock_gettime-timens.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define BUILD_VDSO_TIME_NS
+
+#include "vclock_gettime.c"
+
diff --git a/arch/x86/entry/vdso/vdso32/vclock_gettime-timens.c b/arch/x86/entry/vdso/vdso32/vclock_gettime-timens.c
new file mode 100644
index 000000000000..9e92315f83db
--- /dev/null
+++ b/arch/x86/entry/vdso/vdso32/vclock_gettime-timens.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define BUILD_VDSO_TIME_NS
+
+#include "vclock_gettime.c"
+
-- 
2.20.1
