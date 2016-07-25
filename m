From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: modules: add ro_after_init support
Date: Mon, 25 Jul 2016 06:01:53 -0400
Message-ID: <20160725100153.GA20706@packer-debian-8-amd64.digitalocean.com>
References: <1469438758-24729-1-git-send-email-jeyu@redhat.com>
 <1469438758-24729-2-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469438758-24729-2-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [25/07/16 05:25 -0400]:
>Add ro_after_init support for modules by adding a new page-aligned section
>in the module layout (after rodata) for ro_after_init data and enabling RO
>protection for that section after module init runs.
>
>Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>---
> include/linux/module.h   |  6 +++--
> include/uapi/linux/elf.h |  1 +
> kernel/livepatch/core.c  |  2 +-
> kernel/module.c          | 66 +++++++++++++++++++++++++++++++++++++++---------
> 4 files changed, 60 insertions(+), 15 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index f777164..5255c2f 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -311,6 +311,8 @@ struct module_layout {
> 	unsigned int text_size;
> 	/* Size of RO section of the module (text+rodata) */
> 	unsigned int ro_size;
>+	/* Size of RO after init section */
>+	unsigned int ro_after_init_size;
>
> #ifdef CONFIG_MODULES_TREE_LOOKUP
> 	struct mod_tree_node mtn;
>@@ -788,12 +790,12 @@ extern int module_sysfs_initialized;
> #ifdef CONFIG_DEBUG_SET_MODULE_RONX
> extern void set_all_modules_text_rw(void);
> extern void set_all_modules_text_ro(void);
>-extern void module_enable_ro(const struct module *mod);
>+extern void module_enable_ro(const struct module *mod, bool after_init);
> extern void module_disable_ro(const struct module *mod);
> #else
> static inline void set_all_modules_text_rw(void) { }
> static inline void set_all_modules_text_ro(void) { }
>-static inline void module_enable_ro(const struct module *mod) { }
>+static inline void module_enable_ro(const struct module *mod, bool after_init) { }
> static inline void module_disable_ro(const struct module *mod) { }
> #endif
>
>diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
>index cb4a72f..70b172ba 100644
>--- a/include/uapi/linux/elf.h
>+++ b/include/uapi/linux/elf.h
>@@ -286,6 +286,7 @@ typedef struct elf64_phdr {
> #define SHF_ALLOC		0x2
> #define SHF_EXECINSTR		0x4
> #define SHF_RELA_LIVEPATCH	0x00100000
>+#define SHF_RO_AFTER_INIT	0x00200000
> #define SHF_MASKPROC		0xf0000000
>
> /* special section indexes */
>diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>index 5c2bc10..8bbe507 100644
>--- a/kernel/livepatch/core.c
>+++ b/kernel/livepatch/core.c
>@@ -309,7 +309,7 @@ static int klp_write_object_relocations(struct module *pmod,
> 			break;
> 	}
>
>-	module_enable_ro(pmod);
>+	module_enable_ro(pmod, true);

There is a slight quirk here in that klp_init_object_loaded() (which
calls klp_write_object_relocations()) can be called either during
patch module init (during patch registration) or after init (e.g.,
when a previously unloaded to-be-patched module is loaded). AFAIK
patch modules themselves don't use .data..ro_after_init sections, so
it's probably fine to set after_init to be true here for now. But I
still need to think some more about the case where we try to patch
data from another module marked __ro_after_init.
