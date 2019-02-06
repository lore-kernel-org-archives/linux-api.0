From: Dmitry Safonov <dima@arista.com>
Subject: [PATCH 15/32] x86/vdso2c: Optionally produce linker script for vdso entries
Date: Wed,  6 Feb 2019 00:10:49 +0000
Message-ID: <20190206001107.16488-16-dima@arista.com>
References: <20190206001107.16488-1-dima@arista.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <dima@arista.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Two VDSO images (with/without code for adding offsets inside timens)
should be compatible by VDSO function offsets - this way kernel
can remap VDSO VMA for a task without fixupping GOT/PLT.

Add an optional parameter for vdso2c to generate .entries file from
vdso.so. As timens VDSO by nature is bigger in .text than VDSO for
tasks outside namespace, this parameter will be used to generate
.entries file from timens VDSO and include those aligns into linker
script for !timens VDSO building.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 arch/x86/entry/vdso/.gitignore |  1 +
 arch/x86/entry/vdso/Makefile   |  7 ++++---
 arch/x86/entry/vdso/vdso2c.c   | 26 +++++++++++++++++++-------
 arch/x86/entry/vdso/vdso2c.h   | 16 +++++++++++++++-
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/vdso/.gitignore b/arch/x86/entry/vdso/.gitignore
index aae8ffdd5880..9ab4fa4c7e7b 100644
--- a/arch/x86/entry/vdso/.gitignore
+++ b/arch/x86/entry/vdso/.gitignore
@@ -5,3 +5,4 @@ vdso32-sysenter-syms.lds
 vdso32-int80-syms.lds
 vdso-image-*.c
 vdso2c
+vdso*.entries
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 55ba81d4415c..ccb572831ea1 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -47,8 +47,8 @@ vobjs32-timens := $(foreach F,$(vobjs32-timens-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
-targets += vdso.lds $(vobjs-y) $(vobjs-timens-y)
-targets += vdso32/vdso32.lds $(vobjs32-y) $(vobjs32-timens-y)
+targets += vdso.lds $(vobjs-y) $(vobjs-timens-y) vdso64.entries
+targets += vdso32/vdso32.lds $(vobjs32-y) $(vobjs32-timens-y) vdso32.entries
 
 # Build the vDSO image C files and link them in.
 vdso_img_objs := $(vdso_img-y:%=vdso-image-%.o)
@@ -73,7 +73,8 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include/uapi -I$(src
 hostprogs-y			+= vdso2c
 
 quiet_cmd_vdso2c = VDSO2C  $@
-      cmd_vdso2c = $(obj)/vdso2c $< $(<:%.dbg=%) $@
+      cmd_vdso2c = $(obj)/vdso2c $< $(<:%.dbg=%) $@ \
+		   $(filter %.entries,$(<:%-timens.so.dbg=%.entries))
 
 $(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 	$(call if_changed,vdso2c)
diff --git a/arch/x86/entry/vdso/vdso2c.c b/arch/x86/entry/vdso/vdso2c.c
index ed66b023d4b9..72731c4cfdce 100644
--- a/arch/x86/entry/vdso/vdso2c.c
+++ b/arch/x86/entry/vdso/vdso2c.c
@@ -152,6 +152,7 @@ extern void bad_put_le(void);
 #define BITSFUNC3(name, bits, suffix) name##bits##suffix
 #define BITSFUNC2(name, bits, suffix) BITSFUNC3(name, bits, suffix)
 #define BITSFUNC(name) BITSFUNC2(name, ELF_BITS, )
+#define ELF_FUNC(f, x) (BITSFUNC2(ELF, ELF_BITS, _##f)(x))
 
 #define INT_BITS BITSFUNC2(int, ELF_BITS, _t)
 
@@ -169,16 +170,17 @@ extern void bad_put_le(void);
 
 static void go(void *raw_addr, size_t raw_len,
 	       void *stripped_addr, size_t stripped_len,
-	       FILE *outfile, const char *name)
+	       FILE *outfile, const char *name,
+	       FILE *out_entries_lds)
 {
 	Elf64_Ehdr *hdr = (Elf64_Ehdr *)raw_addr;
 
 	if (hdr->e_ident[EI_CLASS] == ELFCLASS64) {
 		go64(raw_addr, raw_len, stripped_addr, stripped_len,
-		     outfile, name);
+		     outfile, name, out_entries_lds);
 	} else if (hdr->e_ident[EI_CLASS] == ELFCLASS32) {
 		go32(raw_addr, raw_len, stripped_addr, stripped_len,
-		     outfile, name);
+		     outfile, name, out_entries_lds);
 	} else {
 		fail("unknown ELF class\n");
 	}
@@ -208,12 +210,12 @@ int main(int argc, char **argv)
 {
 	size_t raw_len, stripped_len;
 	void *raw_addr, *stripped_addr;
-	FILE *outfile;
+	FILE *outfile, *entries_lds = NULL;
 	char *name, *tmp;
 	int namelen;
 
-	if (argc != 4) {
-		printf("Usage: vdso2c RAW_INPUT STRIPPED_INPUT OUTPUT\n");
+	if (argc < 4) {
+		printf("Usage: vdso2c RAW_INPUT STRIPPED_INPUT OUTPUT [OUTPUT_ENTRIES.LDS]\n");
 		return 1;
 	}
 
@@ -245,11 +247,21 @@ int main(int argc, char **argv)
 	if (!outfile)
 		err(1, "fopen(%s)", outfilename);
 
-	go(raw_addr, raw_len, stripped_addr, stripped_len, outfile, name);
+	if (argc == 5) {
+		entries_lds = fopen(argv[4], "w");
+		if (!entries_lds) {
+			fclose(outfile);
+			err(1, "fopen(%s)", argv[4]);
+		}
+	}
+
+	go(raw_addr, raw_len, stripped_addr, stripped_len, outfile, name, entries_lds);
 
 	munmap(raw_addr, raw_len);
 	munmap(stripped_addr, stripped_len);
 	fclose(outfile);
+	if (entries_lds)
+		fclose(entries_lds);
 
 	return 0;
 }
diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index 61c8bb2e5af8..065dac6c29c8 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -7,7 +7,8 @@
 
 static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 			 void *stripped_addr, size_t stripped_len,
-			 FILE *outfile, const char *name)
+			 FILE *outfile, const char *name,
+			 FILE *out_entries_lds)
 {
 	int found_load = 0;
 	unsigned long load_size = -1;  /* Work around bogus warning */
@@ -111,6 +112,19 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
+
+		if (!out_entries_lds)
+			continue;
+
+		if (ELF_FUNC(ST_BIND, sym->st_info) != STB_GLOBAL)
+			continue;
+
+		if (ELF_FUNC(ST_TYPE, sym->st_info) != STT_FUNC)
+			continue;
+
+		fprintf(out_entries_lds, "\t\t. = ABSOLUTE(%#lx);\n",
+				(unsigned long)GET_LE(&sym->st_value));
+		fprintf(out_entries_lds, "\t\t*(.text.%s*)\n", name);
 	}
 
 	/* Validate mapping addresses. */
-- 
2.20.1
