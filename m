From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/1] Add ro_after_init support for modules
Date: Mon, 25 Jul 2016 05:25:57 -0400
Message-ID: <1469438758-24729-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

This patch adds ro_after_init support for modules by adding an additional
page-aligned section in the module layout. This new ro_after_init section
sits between rodata and writable data.

So, the new module layout looks like:
   [text] [rodata] [ro_after_init] [writable data]

RO after init data remains RW during init and RO protection is enabled
separately after module init runs.

Did some light testing with lkdtm compiled as a module, verified that
ro_after_init data is writable during init, and that it oopsed after attempted
writes after init. Also tested livepatch (which uses module_{enable,disable}_ro
for its own purposes) to make sure nothing broke. More testing is appreciated :-)

Some remarks on the implementation:
 * A new SHF_RO_AFTER_INIT flag is introduced in elf.h to make
   identification of .data..ro_after_init sections and the work of
   layout_sections() easier. Its chosen value is within the SHF_MASKOS
   range.
 * If a module doesn't have a ro_after_init section, then
   core_layout.ro_after_init_size just takes the value of
   core_layout.ro_size, and frob_ro_after_init() should do nothing.

Based on linux-next.

v1 here:
http://lkml.kernel.org/g/1465863198-15947-1-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

v2:
 - Add a bool after_init parameter to module_enable_ro(), it's much clearer
   than checking module->state.
 - Since the function signature for module_enable_ro() has changed, livepatch
   needs to slightly adjust its call to module_enable_ro()

Jessica Yu (1):
  modules: add ro_after_init support

 include/linux/module.h   |  6 +++--
 include/uapi/linux/elf.h |  1 +
 kernel/livepatch/core.c  |  2 +-
 kernel/module.c          | 66 +++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 60 insertions(+), 15 deletions(-)

-- 
2.5.5
