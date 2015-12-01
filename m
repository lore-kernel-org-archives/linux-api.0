From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH v2 1/6] Elf: add livepatch-specific Elf constants
Date: Mon, 30 Nov 2015 23:21:14 -0500
Message-ID: <1448943679-3412-2-git-send-email-jeyu@redhat.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add livepatch Elf relocation section flag (SHF_RELA_LIVEPATCH), livepatch
symbol bind (STB_LIVEPATCH_EXT) and section index (SHN_LIVEPATCH).
The values of these Elf constants were selected from OS-specific ranges
according to the definitions from glibc.

Livepatch relocation sections are marked with SHF_RELA_LIVEPATCH to
indicate to the module loader that it should not apply that relocation
section and that livepatch will handle them.

The SHN_LIVEPATCH shndx marks symbols that will be resolved by livepatch.
The module loader ignores these symbols and does not attempt to resolve
them.

The STB_LIVEPATCH_EXT symbol bind marks the scope of certain livepatch
symbols, so that livepatch can appropriately resolve them.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 include/uapi/linux/elf.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 71e1d0e..95ff318 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -115,9 +115,10 @@ typedef __s64	Elf64_Sxword;
 #define DT_HIPROC	0x7fffffff
 
 /* This info is needed when parsing the symbol table */
-#define STB_LOCAL  0
-#define STB_GLOBAL 1
-#define STB_WEAK   2
+#define STB_LOCAL		0
+#define STB_GLOBAL		1
+#define STB_WEAK		2
+#define STB_LIVEPATCH_EXT	11
 
 #define STT_NOTYPE  0
 #define STT_OBJECT  1
@@ -282,16 +283,18 @@ typedef struct elf64_phdr {
 #define SHT_HIUSER	0xffffffff
 
 /* sh_flags */
-#define SHF_WRITE	0x1
-#define SHF_ALLOC	0x2
-#define SHF_EXECINSTR	0x4
-#define SHF_MASKPROC	0xf0000000
+#define SHF_WRITE		0x1
+#define SHF_ALLOC		0x2
+#define SHF_EXECINSTR		0x4
+#define SHF_RELA_LIVEPATCH	0x00100000
+#define SHF_MASKPROC		0xf0000000
 
 /* special section indexes */
 #define SHN_UNDEF	0
 #define SHN_LORESERVE	0xff00
 #define SHN_LOPROC	0xff00
 #define SHN_HIPROC	0xff1f
+#define SHN_LIVEPATCH	0xff20
 #define SHN_ABS		0xfff1
 #define SHN_COMMON	0xfff2
 #define SHN_HIRESERVE	0xffff
-- 
2.4.3
