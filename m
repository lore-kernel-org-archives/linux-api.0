From: Jessica Yu <jeyu@redhat.com>
Subject: [PATCH v6 0/5] (mostly) Arch-independent livepatch
Date: Tue, 22 Mar 2016 20:03:14 -0400
Message-ID: <1458691399-20078-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

This patchset removes livepatch's need for architecture-specific relocation
code by leveraging existing code in the module loader to perform
arch-dependent work. Specifically, instead of duplicating code and
re-implementing what the apply_relocate_add() function in the module loader
already does in livepatch's klp_write_module_reloc(), we reuse
apply_relocate_add() to write relocations. The hope is that this will make
livepatch more easily portable to other architectures and greatly reduce
the amount of arch-specific code required to port livepatch to a particular
architecture.

Background: Why does livepatch need to write its own relocations?
==
A typical livepatch module contains patched versions of functions that can
reference non-exported global symbols and non-included local symbols.
Relocations referencing these types of symbols cannot be left in as-is
since the kernel module loader cannot resolve them and will therefore
reject the livepatch module. Furthermore, we cannot apply relocations that
affect modules not loaded yet at run time (e.g. a patch to a driver). The
current kpatch build system therefore solves this problem by embedding
special "dynrela" (dynamic reloc) sections in the resulting patch module
Elf output. Using these dynrela sections, livepatch can correctly resolve
symbols while taking into account its scope and what module the symbol
belongs to, and then manually apply the dynamic relocations.

Motivation: Why is having arch-dependent relocation code a problem?
==
The original motivation for this patchset stems from the increasing
roadblocks encountered while attempting to port livepatch to s390.
Specifically, there were problems dealing with s390 PLT and GOT relocation
types (R_390_{PLT,GOT}), which are handled differently from x86's
relocation types (which are much simpler to deal with, and a single
livepatch function (klp_write_module_reloc()) has been sufficient enough).
These s390 reloc types cannot be handled by simply performing a calculation
(as in the x86 case). For s390 modules with PLT/GOT relocations, the kernel
module loader allocates and fills in PLT+GOT table entries for every symbol
referenced by a PLT/GOT reloc in module core memory. So the problem of
porting livepatch to s390 became much more complicated than simply writing
an s390-specific klp_write_module_reloc() function. How can livepatch
handle these relocation types if the s390 module loader needs to allocate
and fill PLT/GOT entries ahead of time? The potential solutions were: 1)
have livepatch possibly allocate and maintain its own PLT/GOT tables for
every patch module (requiring even more arch-specific code), 2) modify the
s390 module loader heavily to accommodate livepatch modules (i.e. allocate
all the needed PLT/GOT entries for livepatch in advance but refrain from
applying relocations for to-be-patched modules), or 3) eliminate this
potential mess by leveraging module loader code to do all the relocation
work, letting livepatch off the hook completely. Solution #3 is what this
patchset implements.

How does this patchset remedy these problems?
==
Reusing the module loader code to perform livepatch relocations means that
livepatch no longer needs arch-specific reloc code and the aforementioned
problems with s390 PLT/GOT reloc types disappear (because we let the module
loader do all the relocation work for us). It will enable livepatch to be
more easily ported to other architectures.

Summary of proposed changes
==
This patch series enables livepatch to use the module loader's
apply_relocate_add() function to apply livepatch relocations (i.e. what
used to be dynrelas). apply_relocate_add() requires access to a patch
module's section headers, symbol table, reloc section indices, etc., and all
of these are accessible through the load_info struct used in the module
loader. Therefore we persist module Elf information (copied from load_info)
for livepatch modules.

The ELF-related changes enable livepatch to patch modules that are not yet
loaded (as well as patch vmlinux when kaslr is enabled). In order to use
apply_relocate_add(), we need real SHT_RELA sections to pass in. A
complication here is that relocations for not-yet-loaded modules should not
be applied when the patch module loads; they should only be applied once
the target module is loaded. Thus kpatch build scripts were modified to
output a livepatch module that contains special .klp.rela. sections that
are managed by livepatch and are applied at the appropriate time (i.e. when
target module loads). They are marked with a special SHF_RELA_LIVEPATCH
section flag to indicate to the module loader that livepatch will handle
them. The SHN_LIVEPATCH shndx marks symbols that need to be resolved
once their respective target module loads. So, the module loader ignores
these symbols and does not attempt to resolve them. These ELF constants
were selected from OS-specific ranges according to the definitions from
glibc.

Patches based on linux-next.

Previous patchset (v5) found here:
http://lkml.kernel.org/g/1458157628-8264-1-git-send-email-jeyu@redhat.com

v6:
 - Since we hard-code the field widths for the objname and symbol name
   for the sscanf() calls, which are supposed to correspond to the values
   of MODULE_NAME_LEN and KSYM_NAME_LEN, use BUILD_BUG_ON() to detect when
   the values of these constants deviate from the expected values.
 - Squash the sample livepatch module patch into patch 4
   ("livepatch: reuse module loader code to write relocations") so 
   git bisects don't break
 - Don't need the klp_buf struct, just use plain char arrays to hold the
   output of sscanf(). Also, no need to clear the bufs after every
   invocation, as sscanf() takes care to put a null byte at the end of
   the bufs.
 - Fix compiler kbuild errors for the !CONFIG_LIVEPATCH case
 - Fixed some small module.c nits

v5:
 - The '%[' format specifier for sscanf() is now available on linux-next,
   so use sscanf() to parse symbol and section names instead of a using
   multiple clumsy klp_get_* helper functions and strspn/strcspn calls.
 - Removed some unnecessary comments
 - For symtab access, just use the core symtab mod->core_kallsyms.symtab
   (what used to be mod->core_symtab). If we use mod->kallsyms.symtab
   (what used to be mod->symtab), during the patch module init process we
   would be using the init symbol table (the one in module init memory)
   instead of the core symbol table, because mod->kallsyms only gets reassigned
   to mod->core_kallsyms *after* do_one_initcall(). Though in the case of
   livepatch modules both the symbol tables in init vs core memory are
   identical, I think it is better to be consistent.

v4:
 - Way more error checking for all the string manipulation on
   livepatch symbol names and sections.
 - Handle error conditions such as loading a klp module on a
   !CONFIG_LIVEPATCH kernel
 - Don't encode sympos in a symbol's st_other field. Instead, append it
   to the symbol name in the form .klp.sym.objname.symname,sympos
 - Instead of a half initialized copy of the load_info struct in
   mod->info, define a livepatch specific struct (klp_modinfo) instead
   that contains just the needed Elf info.
 - Much more detailed documentation about patch module requirements
   and the module elf format.

v3:
 - Remove usage of the klp_reloc_sec struct, since we can simply loop
   through the patch module's section headers.
 - Remove necessity of the "external" flag by prefixing symbol names
   with the object name and extracting this name during symbol
   resolution.
 - Create CONFIG_LIVEPATCH and !CONFIG_LIVEPATCH versions of
   {copy,free}_module_elf(), is_livepatch_module(), and
   check_livepatch_modinfo().
 - Encoded symbol position of a livepatch sym in its st_other field.
 - Various bug fixes from v2

v2:
 - Copy only the minimum required Elf information for livepatch modules to
   make the call to apply_relocate_add(), not the entire load_info struct
   and the redundant copy of the module in memory
 - Add module->klp flag for simple identification of livepatch modules
 - s390: remove redundant vfree() and preserve mod_arch_specific if
   livepatch module
 - Use array format instead of a linked list for klp_reloc_secs
 - Add new documentation describing the format of a livepatch module in
   Documentation/livepatch

Jessica Yu (5):
  Elf: add livepatch-specific Elf constants
  module: preserve Elf information for livepatch modules
  module: s390: keep mod_arch_specific for livepatch modules
  livepatch: reuse module loader code to write relocations
  Documentation: livepatch: outline Elf format and requirements for
    patch modules

 Documentation/livepatch/module-elf-format.txt | 311 ++++++++++++++++++++++++++
 arch/s390/include/asm/livepatch.h             |   7 -
 arch/s390/kernel/module.c                     |   6 +-
 arch/x86/include/asm/livepatch.h              |   2 -
 arch/x86/kernel/Makefile                      |   1 -
 arch/x86/kernel/livepatch.c                   |  70 ------
 include/linux/livepatch.h                     |  20 --
 include/linux/module.h                        |  25 +++
 include/uapi/linux/elf.h                      |  10 +-
 kernel/livepatch/core.c                       | 148 +++++++-----
 kernel/module.c                               | 125 ++++++++++-
 samples/livepatch/livepatch-sample.c          |   1 +
 12 files changed, 563 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/livepatch/module-elf-format.txt
 delete mode 100644 arch/x86/kernel/livepatch.c

-- 
2.4.3

