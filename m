From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v3 6/6] Documentation: livepatch: outline the Elf format of a livepatch module
Date: Fri,  8 Jan 2016 14:28:24 -0500
Message-ID: <1452281304-28618-7-git-send-email-jeyu@redhat.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452281304-28618-1-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Document the special Elf sections and constants livepatch modules use.

Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/livepatch/patch-module-format.txt | 106 ++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 Documentation/livepatch/patch-module-format.txt

diff --git a/Documentation/livepatch/patch-module-format.txt b/Documentation/livepatch/patch-module-format.txt
new file mode 100644
index 0000000..d825629
--- /dev/null
+++ b/Documentation/livepatch/patch-module-format.txt
@@ -0,0 +1,106 @@
+---------------------------
+Livepatch module Elf format
+---------------------------
+
+This document outlines the special Elf constants and sections livepatch
+uses to patch both modules and the kernel (vmlinux).
+
+--------------------------
+1. Livepatch modinfo field
+--------------------------
+
+Livepatch modules can be identified by users by using the 'modinfo' command
+and looking for the presence of the "livepatch" field. This field is also
+used by the kernel module loader to identify livepatch modules.
+
+Example modinfo output:
+
+% modinfo kpatch-meminfo.ko
+filename:		kpatch-meminfo.ko
+livepatch:		Y
+license:		GPL
+depends:
+vermagic:		4.3.0+ SMP mod_unload
+
+--------------------
+2. Livepatch symbols
+--------------------
+
+These are symbols marked with SHN_LIVEPATCH and their names are prefixed
+with the string ".klp.sym.${objname}.", where ${objname} is the name of the
+"object" where symbol stems from (the name of a module, for example).
+A symbol's position (used to differentiate duplicate symbols within the
+same object) in its object is encoded in the Elf_Sym st_other field
+and accessed with the KLP_SYMPOS macro (see include/linux/livepatch.h)
+
+Livepatch symbols are manually resolved by livepatch, and are used in cases
+where we cannot immediately know the address of a symbol because the
+to-be-patched module is not loaded yet. Livepatch modules keep these
+symbols in their symbol tables, and the symbol table is made accessible
+through module->core_symtab. For livepatch modules, core_symtab will
+contain an exact copy of the original symbol table as opposed to a stripped
+down version containing just the "core" symbols.
+
+-----------------------------------
+3. ".klp.rel." relocation sections
+-----------------------------------
+
+A livepatch module uses special Elf relocation sections to apply
+relocations both for regular vmlinux patches as well as those that should
+be applied as soon as the to-be-patched module is loaded. For example, if a
+patch module patches a driver that is not currently loaded, livepatch will
+apply its corresponding klp relocation section(s) to the driver once it
+loads.
+
+The names of these livepatch relocation sections are formatted
+".klp.rel.${objname}.", where ${objname} is the name of the "object" being
+patched (e.g. vmlinux or name of module). Each object within a patch module
+may have multiple klp sections (e.g. patches to multiple functions within
+the same object). There is a 1-1 correspondence between a klp relocation
+section and the target section (usually the text section for a function) to
+which the relocation(s) apply.
+
+Here's a sample readelf output for a livepatch module that patches vmlinux and
+modules 9p, btrfs, ext4:
+  ...
+  [29] .klp.rel.9p.text.caches.show RELA                    0000000000000000 002d58 0000c0 18 AIo 64   9  8
+  [30] .klp.rel.btrfs.text.btrfs.feature.attr.show RELA     0000000000000000 002e18 000060 18 AIo 64  11  8
+  ...
+  [34] .klp.rel.ext4.text.ext4.attr.store RELA              0000000000000000 002fd8 0000d8 18 AIo 64  13  8
+  [35] .klp.rel.ext4.text.ext4.attr.show RELA               0000000000000000 0030b0 000150 18 AIo 64  15  8
+  [36] .klp.rel.vmlinux.text.cmdline.proc.show RELA         0000000000000000 003200 000018 18 AIo 64  17  8
+  [37] .klp.rel.vmlinux.text.meminfo.proc.show RELA         0000000000000000 003218 0000f0 18 AIo 64  19  8
+  ...
+
+klp relocation sections are SHT_RELA sections but with a few special
+characteristics. Notice that they are marked SHF_ALLOC ("A") so that they
+will not be discarded when the module is loaded into memory, as well as
+with the SHF_RELA_LIVEPATCH flag ("o" - for OS-specific) so the module
+loader can identify them and avoid treating them as regular SHT_RELA
+sections, since they are manually managed by livepatch.
+
+Since Elf information is preserved for livepatch modules (see Section 4), a
+klp relocation section can be applied simply by passing in the appropriate
+section index to apply_relocate_add() (in the module loader code), which
+then uses it to access the relocation section and apply the relocations.
+
+--------------------------------------------------------
+4. How a livepatch module accesses its symbol table and
+its klp relocation sections
+--------------------------------------------------------
+
+The kernel module loader checks whether the module being loaded is a
+livepatch module. If so, it then makes a copy of the module's Elf header,
+section headers, section name string table, and some noteworthy section
+indices (for example, the symtab's section index). It adjusts the symtab's
+sh_addr to point to mod->core_symtab, since the original mod->symtab lies
+in init memory and gets freed once the module finishes initializing. For
+livepatch modules, the core_symtab will be an exact copy of its original
+symbol table (where normally, only "core" symbols are included in this
+symbol table. See is_core_symbol() in kernel/module.c). Livepatch requires
+that the symbols retain their original indices in the symbol table so that
+the klp relocation sections can be applied correctly.
+
+As for the klp relocation sections, since we save Elf information for
+livepatch modules, we can simply iterate through module->info->sechdrs
+and check if the SHF_RELA_LIVEPATCH flag is set for a particular section.
-- 
2.4.3
