From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: [RFC 2/2] [NOT READY] x86/vdso: Add __vdso_findsym
Date: Sat, 14 Jun 2014 11:16:44 -0700
Message-ID: <965725522edc00c60b7e72c66970eb2844d0911b.1402769596.git.luto@amacapital.net>
References: <cover.1402769596.git.luto@amacapital.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1402769596.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
In-Reply-To: <cover.1402769596.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
References: <cover.1402769596.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russ Cox <rsc-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ian Taylor <iant-iFWiy5xATs8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dalias-8zAoT0mYgF4@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The intent is to add a painless way for userspace libraries to find
vdso symbols.  This will work by adding a vdso function
__vdso_findsym and a new auxvec entry AT_VDSO_FINDSYM that points at
it.

This isn't done yet.  __vdso_findsym works, but it's only available
for the 64-bit vdso, and AT_VDSO_FINDSYM isn't implemented.

Getting this to work for x32 will require hackery or an actual x32
toolchain to build it.

Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
---
 arch/x86/vdso/Makefile          |   3 +
 arch/x86/vdso/vdso-findsym.c    | 136 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso-layout.lds.S |  11 ++--
 arch/x86/vdso/vdso.lds.S        |   1 +
 arch/x86/vdso/vdso2c.h          |   2 +-
 5 files changed, 147 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-findsym.c

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index ba6fc27..62e6938 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -16,7 +16,9 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
+vobjs-y += vdso-findsym.o
 vobjs-nox32 := vdso-fakesections.o
+vobjs-nox32 += vdso-findsym.o
 
 # files to link into kernel
 obj-y				+= vma.o
@@ -83,6 +85,7 @@ CFLAGS_REMOVE_vdso-note.o = -pg
 CFLAGS_REMOVE_vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
 CFLAGS_REMOVE_vvar.o = -pg
+CFLAGS_REMOVE_vdso-findsym.o = -pg
 
 #
 # X32 processes use x32 vDSO to access 64bit kernel data.
diff --git a/arch/x86/vdso/vdso-findsym.c b/arch/x86/vdso/vdso-findsym.c
new file mode 100644
index 0000000..83b0c0a
--- /dev/null
+++ b/arch/x86/vdso/vdso-findsym.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright 2014 Andy Lutomirski
+ * Subject to the GNU Public License, v.2
+ *
+ * AT_VDSO_FINDSYM implementation
+ *
+ * AT_VDSO_FINDSYM is a mechanism that can be used by userspace runtimes
+ * that don't want to implement a full ELF parser.  The ELF parser in
+ * here cheats heavily.  It relies on the linker to do part of the work,
+ * and it makes questionable assumptions about the layout of some of the
+ * dynamic data structures.  Those questionable assumptions are verified
+ * by vdso2c.
+ */
+
+/* Disable profiling for userspace code: */
+#define DISABLE_BRANCH_PROFILING
+
+#pragma GCC optimize ("Os")
+
+#include <linux/elf.h>
+#include <linux/compiler.h>
+
+struct elf_hash {
+	Elf64_Word nbuckets;
+	Elf64_Word nchains;
+	Elf64_Word data[];
+};
+
+/*
+ * These must be explicitly hidden: we need to access them via direct
+ * PC-relative relocations, not through the GOT, since we have no GOT.
+ */
+extern const char VDSO_START[] __attribute__((visibility("hidden")));
+extern const char DYN_STRTAB[] __attribute__((visibility("hidden")));
+extern Elf64_Sym DYN_SYMTAB[] __attribute__((visibility("hidden")));
+extern struct elf_hash DYN_HASH __attribute__((visibility("hidden")));
+extern Elf64_Half DYN_VERSYM[] __attribute__((visibility("hidden")));
+extern Elf64_Verdef DYN_VERDEF[] __attribute__((visibility("hidden")));
+
+/* Straight from the ELF specification. */
+static unsigned long elf_hash(const unsigned char *name)
+{
+	unsigned long h = 0, g;
+	while (*name)
+	{
+		h = (h << 4) + *name++;
+		if ((g = h & 0xf0000000) != 0)
+			h ^= g >> 24;
+		h &= ~g;
+	}
+	return h;
+}
+
+static bool strings_equal(const char *a, const char *b)
+{
+	while (true) {
+		if (*a != *b)
+			return false;
+		if (!*a)
+			return true;
+		a++;
+		b++;
+	}
+}
+
+static bool vdso_match_version(Elf64_Half ver,
+			       const char *name, Elf64_Word hash)
+{
+	/*
+	 * This is a helper function to check if the version indexed by
+	 * ver matches name (which hashes to hash).
+	 *
+	 * The version definition table is a mess, and I don't know how
+	 * to do this in better than linear time without allocating memory
+	 * to build an index.  I also don't know why the table has
+	 * variable size entries in the first place.
+	 *
+	 * For added fun, I can't find a comprehensible specification of how
+	 * to parse all the weird flags in the table.
+	 *
+	 * So I just parse the whole table every time.
+	 */
+
+	Elf64_Verdef *def = DYN_VERDEF;
+	Elf64_Verdaux *aux;
+
+	/* First step: find the version definition */
+	ver &= 0x7fff;  /* Apparently bit 15 means "hidden" */
+	while(true) {
+		if ((def->vd_flags & VER_FLG_BASE) == 0
+		    && (def->vd_ndx & 0x7fff) == ver)
+			break;
+
+		if (def->vd_next == 0)
+			return false;  /* No definition. */
+
+		def = (Elf64_Verdef *)((char *)def + def->vd_next);
+	}
+
+	/* Now figure out whether it matches. */
+	aux = (Elf64_Verdaux*)((char *)def + def->vd_aux);
+	return def->vd_hash == hash
+		&& strings_equal(name, DYN_STRTAB + aux->vda_name);
+}
+
+void *__vdso_findsym(const char *name, const char *version)
+{
+	Elf64_Word chain = DYN_HASH.data[elf_hash(name) % DYN_HASH.nbuckets];
+	const Elf64_Word *chain_next = &DYN_HASH.data[DYN_HASH.nbuckets + 2];
+	unsigned long ver_hash = elf_hash(version);
+
+	for (; chain != STN_UNDEF; chain = chain_next[chain]) {
+		Elf64_Sym *sym = &DYN_SYMTAB[chain];
+
+		/* Check for a defined global or weak function w/ right name. */
+		if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
+			continue;
+		if (ELF64_ST_BIND(sym->st_info) != STB_GLOBAL &&
+		    ELF64_ST_BIND(sym->st_info) != STB_WEAK)
+			continue;
+		if (sym->st_shndx == SHN_UNDEF)
+			continue;
+		if (!strings_equal(name, DYN_STRTAB + sym->st_name))
+			continue;
+
+		/* Check symbol version. */
+		if (!vdso_match_version(DYN_VERSYM[chain],
+					version, ver_hash))
+			continue;
+
+		return (void *)((unsigned long)VDSO_START + sym->st_value);
+	}
+
+	return 0;
+}
+
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 2ec72f6..2e8b692 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -8,14 +8,15 @@
 
 SECTIONS
 {
+	VDSO_START = .;
 	. = SIZEOF_HEADERS;
 
-	.hash		: { *(.hash) }			:text
+	.hash		: { DYN_HASH = .; *(.hash) }		:text
 	.gnu.hash	: { *(.gnu.hash) }
-	.dynsym		: { *(.dynsym) }
-	.dynstr		: { *(.dynstr) }
-	.gnu.version	: { *(.gnu.version) }
-	.gnu.version_d	: { *(.gnu.version_d) }
+	.dynsym		: { DYN_SYMTAB = .; *(.dynsym) }
+	.dynstr		: { DYN_STRTAB = .; *(.dynstr) }
+	.gnu.version	: { DYN_VERSYM = .; *(.gnu.version) }
+	.gnu.version_d	: { DYN_VERDEF = .; *(.gnu.version_d) }
 	.gnu.version_r	: { *(.gnu.version_r) }
 
 	.note		: { *(.note.*) }		:text	:note
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 75e3404..9b23d4e 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -22,6 +22,7 @@ VERSION {
 		__vdso_getcpu;
 		time;
 		__vdso_time;
+		__vdso_findsym;
 	local: *;
 	};
 }
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index c6eefaf..931abac 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -51,7 +51,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	for (i = 0; dyn + i < dyn_end &&
 		     GET_LE(&dyn[i].d_tag) != DT_NULL; i++) {
 		typeof(dyn[i].d_tag) tag = GET_LE(&dyn[i].d_tag);
-		if (tag == DT_REL || tag == DT_RELSZ ||
+		if (tag == DT_REL || tag == DT_RELA || tag == DT_RELSZ ||
 		    tag == DT_RELENT || tag == DT_TEXTREL)
 			fail("vdso image contains dynamic relocations\n");
 	}
-- 
1.9.3
