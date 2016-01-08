From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH v3 0/6] (mostly) Arch-independent livepatch
Date: Fri,  8 Jan 2016 14:28:18 -0500
Message-ID: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
output a livepatch module that contains special .klp.rel. sections that
are managed by livepatch and are applied at the appropriate time (i.e. when
target module loads). They are marked with a special SHF_RELA_LIVEPATCH
section flag to indicate to the module loader that livepatch will handle
them. The SHN_LIVEPATCH shndx marks symbols that need to be resolved
once their respective target module loads. So, the module loader ignores
these symbols and does not attempt to resolve them. These ELF constants
were selected from OS-specific ranges according to the definitions from
glibc.

Based on the following branch:
- git://git.kernel.org/pub/scm/linux/kernel/git/jikos/livepatching.git
  for-4.5/core

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

Jessica Yu (6):
  Elf: add livepatch-specific Elf constants
  module: preserve Elf information for livepatch modules
  module: s390: keep mod_arch_specific for livepatch modules
  livepatch: reuse module loader code to write relocations
  samples: livepatch: mark as livepatch module
  Documentation: livepatch: outline the Elf format of a livepatch module

 Documentation/livepatch/patch-module-format.txt |  98 ++++++++++++++++
 arch/s390/kernel/module.c                       |  16 ++-
 arch/x86/include/asm/livepatch.h                |   2 -
 arch/x86/kernel/Makefile                        |   1 -
 arch/x86/kernel/livepatch.c                     |  70 -----------
 include/linux/livepatch.h                       |  33 +++---
 include/linux/module.h                          |  31 +++++
 include/uapi/linux/elf.h                        |  10 +-
 kernel/livepatch/core.c                         | 104 ++++++++---------
 kernel/module.c                                 | 149 +++++++++++++++++++++---
 samples/livepatch/livepatch-sample.c            |   1 +
 11 files changed, 347 insertions(+), 168 deletions(-)
 create mode 100644 Documentation/livepatch/patch-module-format.txt
 delete mode 100644 arch/x86/kernel/livepatch.c

-- 
2.4.3
