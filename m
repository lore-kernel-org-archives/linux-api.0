From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/1] modules: add ro_after_init support
Date: Mon, 25 Jul 2016 05:25:58 -0400
Message-ID: <1469438758-24729-2-git-send-email-jeyu@redhat.com>
References: <1469438758-24729-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469438758-24729-1-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add ro_after_init support for modules by adding a new page-aligned section
in the module layout (after rodata) for ro_after_init data and enabling RO
protection for that section after module init runs.

Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/module.h   |  6 +++--
 include/uapi/linux/elf.h |  1 +
 kernel/livepatch/core.c  |  2 +-
 kernel/module.c          | 66 +++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index f777164..5255c2f 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -311,6 +311,8 @@ struct module_layout {
 	unsigned int text_size;
 	/* Size of RO section of the module (text+rodata) */
 	unsigned int ro_size;
+	/* Size of RO after init section */
+	unsigned int ro_after_init_size;
 
 #ifdef CONFIG_MODULES_TREE_LOOKUP
 	struct mod_tree_node mtn;
@@ -788,12 +790,12 @@ extern int module_sysfs_initialized;
 #ifdef CONFIG_DEBUG_SET_MODULE_RONX
 extern void set_all_modules_text_rw(void);
 extern void set_all_modules_text_ro(void);
-extern void module_enable_ro(const struct module *mod);
+extern void module_enable_ro(const struct module *mod, bool after_init);
 extern void module_disable_ro(const struct module *mod);
 #else
 static inline void set_all_modules_text_rw(void) { }
 static inline void set_all_modules_text_ro(void) { }
-static inline void module_enable_ro(const struct module *mod) { }
+static inline void module_enable_ro(const struct module *mod, bool after_init) { }
 static inline void module_disable_ro(const struct module *mod) { }
 #endif
 
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index cb4a72f..70b172ba 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -286,6 +286,7 @@ typedef struct elf64_phdr {
 #define SHF_ALLOC		0x2
 #define SHF_EXECINSTR		0x4
 #define SHF_RELA_LIVEPATCH	0x00100000
+#define SHF_RO_AFTER_INIT	0x00200000
 #define SHF_MASKPROC		0xf0000000
 
 /* special section indexes */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 5c2bc10..8bbe507 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -309,7 +309,7 @@ static int klp_write_object_relocations(struct module *pmod,
 			break;
 	}
 
-	module_enable_ro(pmod);
+	module_enable_ro(pmod, true);
 	return ret;
 }
 
diff --git a/kernel/module.c b/kernel/module.c
index e70a2fa..e697144 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1858,10 +1858,11 @@ static void mod_sysfs_teardown(struct module *mod)
  * from modification and any data from execution.
  *
  * General layout of module is:
- *          [text] [read-only-data] [writable data]
- * text_size -----^                ^               ^
- * ro_size ------------------------|               |
- * size -------------------------------------------|
+ *          [text] [read-only-data] [ro-after-init] [writable data]
+ * text_size -----^                ^               ^               ^
+ * ro_size ------------------------|               |               |
+ * ro_after_init_size -----------------------------|               |
+ * size -----------------------------------------------------------|
  *
  * These values are always page-aligned (as is base)
  */
@@ -1884,14 +1885,24 @@ static void frob_rodata(const struct module_layout *layout,
 		   (layout->ro_size - layout->text_size) >> PAGE_SHIFT);
 }
 
+static void frob_ro_after_init(const struct module_layout *layout,
+				int (*set_memory)(unsigned long start, int num_pages))
+{
+	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
+	set_memory((unsigned long)layout->base + layout->ro_size,
+		   (layout->ro_after_init_size - layout->ro_size) >> PAGE_SHIFT);
+}
+
 static void frob_writable_data(const struct module_layout *layout,
 			       int (*set_memory)(unsigned long start, int num_pages))
 {
 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
-	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
+	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->ro_size,
-		   (layout->size - layout->ro_size) >> PAGE_SHIFT);
+	set_memory((unsigned long)layout->base + layout->ro_after_init_size,
+		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
 }
 
 /* livepatching wants to disable read-only so it can frob module. */
@@ -1899,21 +1910,26 @@ void module_disable_ro(const struct module *mod)
 {
 	frob_text(&mod->core_layout, set_memory_rw);
 	frob_rodata(&mod->core_layout, set_memory_rw);
+	frob_ro_after_init(&mod->core_layout, set_memory_rw);
 	frob_text(&mod->init_layout, set_memory_rw);
 	frob_rodata(&mod->init_layout, set_memory_rw);
 }
 
-void module_enable_ro(const struct module *mod)
+void module_enable_ro(const struct module *mod, bool after_init)
 {
 	frob_text(&mod->core_layout, set_memory_ro);
 	frob_rodata(&mod->core_layout, set_memory_ro);
 	frob_text(&mod->init_layout, set_memory_ro);
 	frob_rodata(&mod->init_layout, set_memory_ro);
+
+	if (after_init)
+		frob_ro_after_init(&mod->core_layout, set_memory_ro);
 }
 
 static void module_enable_nx(const struct module *mod)
 {
 	frob_rodata(&mod->core_layout, set_memory_nx);
+	frob_ro_after_init(&mod->core_layout, set_memory_nx);
 	frob_writable_data(&mod->core_layout, set_memory_nx);
 	frob_rodata(&mod->init_layout, set_memory_nx);
 	frob_writable_data(&mod->init_layout, set_memory_nx);
@@ -1922,6 +1938,7 @@ static void module_enable_nx(const struct module *mod)
 static void module_disable_nx(const struct module *mod)
 {
 	frob_rodata(&mod->core_layout, set_memory_x);
+	frob_ro_after_init(&mod->core_layout, set_memory_x);
 	frob_writable_data(&mod->core_layout, set_memory_x);
 	frob_rodata(&mod->init_layout, set_memory_x);
 	frob_writable_data(&mod->init_layout, set_memory_x);
@@ -1964,6 +1981,8 @@ static void disable_ro_nx(const struct module_layout *layout)
 	frob_text(layout, set_memory_rw);
 	frob_rodata(layout, set_memory_rw);
 	frob_rodata(layout, set_memory_x);
+	frob_ro_after_init(layout, set_memory_rw);
+	frob_ro_after_init(layout, set_memory_x);
 	frob_writable_data(layout, set_memory_x);
 }
 
@@ -2306,6 +2325,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 		 * finder in the two loops below */
 		{ SHF_EXECINSTR | SHF_ALLOC, ARCH_SHF_SMALL },
 		{ SHF_ALLOC, SHF_WRITE | ARCH_SHF_SMALL },
+		{ SHF_RO_AFTER_INIT | SHF_ALLOC, ARCH_SHF_SMALL },
 		{ SHF_WRITE | SHF_ALLOC, ARCH_SHF_SMALL },
 		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 }
 	};
@@ -2337,7 +2357,11 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			mod->core_layout.size = debug_align(mod->core_layout.size);
 			mod->core_layout.ro_size = mod->core_layout.size;
 			break;
-		case 3: /* whole core */
+		case 2: /* RO after init */
+			mod->core_layout.size = debug_align(mod->core_layout.size);
+			mod->core_layout.ro_after_init_size = mod->core_layout.size;
+			break;
+		case 4: /* whole core */
 			mod->core_layout.size = debug_align(mod->core_layout.size);
 			break;
 		}
@@ -2367,7 +2391,14 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			mod->init_layout.size = debug_align(mod->init_layout.size);
 			mod->init_layout.ro_size = mod->init_layout.size;
 			break;
-		case 3: /* whole init */
+		case 2:
+			/*
+			 * RO after init doesn't apply to init_layout (only
+			 * core_layout), so it just takes the value of ro_size.
+			 */
+			mod->init_layout.ro_after_init_size = mod->init_layout.ro_size;
+			break;
+		case 4: /* whole init */
 			mod->init_layout.size = debug_align(mod->init_layout.size);
 			break;
 		}
@@ -3173,6 +3204,7 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
+	unsigned int ndx;
 	int err;
 
 	mod = setup_load_info(info, flags);
@@ -3192,6 +3224,15 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
 	/* We will do a special allocation for per-cpu sections later. */
 	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
 
+	/*
+	 * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
+	 * layout_sections() can put it in the right place.
+	 * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
+	 */
+	ndx = find_sec(info, ".data..ro_after_init");
+	if (ndx)
+		info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
+
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
@@ -3358,12 +3399,14 @@ static noinline int do_init_module(struct module *mod)
 	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
+	module_enable_ro(mod, true);
 	mod_tree_remove_init(mod);
 	disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);
 	mod->init_layout.base = NULL;
 	mod->init_layout.size = 0;
 	mod->init_layout.ro_size = 0;
+	mod->init_layout.ro_after_init_size = 0;
 	mod->init_layout.text_size = 0;
 	/*
 	 * We want to free module_init, but be aware that kallsyms may be
@@ -3455,8 +3498,7 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 
-	/* Set RO and NX regions */
-	module_enable_ro(mod);
+	module_enable_ro(mod, false);
 	module_enable_nx(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
-- 
2.5.5
