From: Jessica Yu <jeyu@redhat.com>
Subject: [PATCH v5 1/6] Elf: add livepatch-specific Elf constants
Date: Wed, 16 Mar 2016 15:47:03 -0400
Message-ID: <1458157628-8264-2-git-send-email-jeyu@redhat.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

Livepatch manages its own relocation sections and symbols in order to be
able to reuse module loader code to write relocations. This removes
livepatch's dependence on separate "dynrela" sections to write relocations
and also allows livepatch to patch modules that are not yet loaded.

The livepatch Elf relocation section flag (SHF_RELA_LIVEPATCH),
and symbol section index (SHN_LIVEPATCH) allow both livepatch and the
module loader to identity livepatch relocation sections and livepatch
symbols.

Livepatch relocation sections are marked with SHF_RELA_LIVEPATCH to
indicate to the module loader that it should not apply that relocation
section and that livepatch will handle them.

The SHN_LIVEPATCH shndx marks symbols that will be resolved by livepatch.
The module loader ignores these symbols and does not attempt to resolve
them.

The values of these Elf constants were selected from OS-specific
ranges according to the definitions from glibc.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 include/uapi/linux/elf.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 71e1d0e..cb4a72f 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -282,16 +282,18 @@ typedef struct elf64_phdr {
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
