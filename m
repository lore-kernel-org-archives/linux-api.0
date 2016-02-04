From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH v4 2/6] module: preserve Elf information for livepatch modules
Date: Wed,  3 Feb 2016 20:11:07 -0500
Message-ID: <1454548271-24923-3-git-send-email-jeyu@redhat.com>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org, Jessica Yu <jeyu@redhat.com>
List-Id: linux-api@vger.kernel.org

For livepatch modules, copy Elf section, symbol, and string information
from the load_info struct in the module loader. Persist copies of the
original symbol table and string table.

Livepatch manages its own relocation sections in order to reuse module
loader code to write relocations. Livepatch modules must preserve Elf
information such as section indices in order to apply livepatch relocation
sections using the module loader's apply_relocate_add() function.

In order to apply livepatch relocation sections, livepatch modules must
keep a complete copy of their original symbol table in memory. Normally, a
stripped down copy of a module's symbol table (containing only "core"
symbols) is made available through module->core_symtab. But for livepatch
modules, the symbol table copied into memory on module load must be exactly
the same as the symbol table produced when the patch module was compiled.
This is because the relocations in each livepatch relocation section refer
to their respective symbols with their symbol indices, and the original
symbol indices (and thus the symtab ordering) must be preserved in order
for apply_relocate_add() to find the right symbol.

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 include/linux/module.h |  25 ++++++++++
 kernel/module.c        | 133 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 151 insertions(+), 7 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 4560d8f..58e6200 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -324,6 +324,15 @@ struct module_layout {
 #define __module_layout_align
 #endif
 
+#ifdef CONFIG_LIVEPATCH
+struct klp_modinfo {
+	Elf_Ehdr hdr;
+	Elf_Shdr *sechdrs;
+	char *secstrings;
+	unsigned int symndx;
+};
+#endif
+
 struct module {
 	enum module_state state;
 
@@ -455,7 +464,11 @@ struct module {
 #endif
 
 #ifdef CONFIG_LIVEPATCH
+	bool klp; /* Is this a livepatch module? */
 	bool klp_alive;
+
+	/* Elf information */
+	struct klp_modinfo *klp_info;
 #endif
 
 #ifdef CONFIG_MODULE_UNLOAD
@@ -629,6 +642,18 @@ static inline bool module_requested_async_probing(struct module *module)
 	return module && module->async_probe_requested;
 }
 
+#ifdef CONFIG_LIVEPATCH
+static inline bool is_livepatch_module(struct module *mod)
+{
+	return mod->klp;
+}
+#else /* !CONFIG_LIVEPATCH */
+static inline bool is_livepatch_module(struct module *mod)
+{
+	return false;
+}
+#endif /* CONFIG_LIVEPATCH */
+
 #else /* !CONFIG_MODULES... */
 
 /* Given an address, look for it in the exception tables. */
diff --git a/kernel/module.c b/kernel/module.c
index 71c77ed..9c16eb2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1970,6 +1970,82 @@ static void module_enable_nx(const struct module *mod) { }
 static void module_disable_nx(const struct module *mod) { }
 #endif
 
+#ifdef CONFIG_LIVEPATCH
+/*
+ * Persist Elf information about a module. Copy the Elf header,
+ * section header table, section string table, and symtab section
+ * index from info to mod->klp_info.
+ */
+static int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	unsigned int size, symndx;
+	int ret = 0;
+
+	size = sizeof(*mod->klp_info);
+	mod->klp_info = kmalloc(size, GFP_KERNEL);
+	if (mod->klp_info == NULL)
+		return -ENOMEM;
+
+	/* Elf header */
+	size = sizeof(Elf_Ehdr);
+	memcpy(&mod->klp_info->hdr, info->hdr, size);
+
+	/* Elf section header table */
+	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;
+	mod->klp_info->sechdrs = kmalloc(size, GFP_KERNEL);
+	if (mod->klp_info->sechdrs == NULL) {
+		ret = -ENOMEM;
+		goto free_info;
+	}
+	memcpy(mod->klp_info->sechdrs, info->sechdrs, size);
+
+	/* Elf section name string table */
+	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
+	mod->klp_info->secstrings = kmalloc(size, GFP_KERNEL);
+	if (mod->klp_info->secstrings == NULL) {
+		ret = -ENOMEM;
+		goto free_sechdrs;
+	}
+	memcpy(mod->klp_info->secstrings, info->secstrings, size);
+
+	/* Elf symbol section index */
+	symndx = info->index.sym;
+	mod->klp_info->symndx = symndx;
+
+	/*
+	 * For livepatch modules, core_symtab is a complete copy
+	 * of the original symbol table. Adjust sh_addr to point
+	 * to core_symtab since the copy of the symtab in module
+	 * init memory is freed at the end of do_init_module().
+	 */
+	mod->klp_info->sechdrs[symndx].sh_addr = (unsigned long) mod->core_symtab;
+
+	return ret;
+
+free_sechdrs:
+	kfree(mod->klp_info->sechdrs);
+free_info:
+	kfree(mod->klp_info);
+	return ret;
+}
+
+static void free_module_elf(struct module *mod)
+{
+	kfree(mod->klp_info->sechdrs);
+	kfree(mod->klp_info->secstrings);
+	kfree(mod->klp_info);
+}
+#else /* !CONFIG_LIVEPATCH */
+static int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	return 0;
+}
+
+static void free_module_elf(struct module *mod)
+{
+}
+#endif /* CONFIG_LIVEPATCH */
+
 void __weak module_memfree(void *module_region)
 {
 	vfree(module_region);
@@ -2008,6 +2084,10 @@ static void free_module(struct module *mod)
 	/* Free any allocated parameters. */
 	destroy_params(mod->kp, mod->num_kp);
 
+	/* Free Elf information if it was saved */
+	if (is_livepatch_module(mod))
+		free_module_elf(mod);
+
 	/* Now we can delete it from the lists */
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
@@ -2123,6 +2203,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			       (long)sym[i].st_value);
 			break;
 
+		case SHN_LIVEPATCH:
+			/* Livepatch symbols are resolved by livepatch */
+			break;
+
 		case SHN_UNDEF:
 			ksym = resolve_symbol_wait(mod, info, name);
 			/* Ok if resolved.  */
@@ -2171,6 +2255,10 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 			continue;
 
+		/* Livepatch relocation sections are applied by livepatch */
+		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
+			continue;
+
 		if (info->sechdrs[i].sh_type == SHT_REL)
 			err = apply_relocate(info->sechdrs, info->strtab,
 					     info->index.sym, i, mod);
@@ -2466,7 +2554,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 
 	/* Compute total space required for the core symbols' strtab. */
 	for (ndst = i = 0; i < nsrc; i++) {
-		if (i == 0 ||
+		if (i == 0 || is_livepatch_module(mod) ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
 				   info->index.pcpu)) {
 			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
@@ -2509,7 +2597,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	mod->core_strtab = s = mod->core_layout.base + info->stroffs;
 	src = mod->symtab;
 	for (ndst = i = 0; i < mod->num_symtab; i++) {
-		if (i == 0 ||
+		if (i == 0 || is_livepatch_module(mod) ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
 				   info->index.pcpu)) {
 			dst[ndst] = src[i];
@@ -2676,6 +2764,23 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
 	return 0;
 }
 
+#ifdef CONFIG_LIVEPATCH
+static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
+{
+	mod->klp = get_modinfo(info, "livepatch") ? true : false;
+
+	return 0;
+}
+#else /* !CONFIG_LIVEPATCH */
+static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
+{
+	if (get_modinfo(info, "livepatch"))
+		return -ENOEXEC;
+
+	return 0;
+}
+#endif /* CONFIG_LIVEPATCH */
+
 /* Sets info->hdr and info->len. */
 static int copy_module_from_fd(int fd, struct load_info *info)
 {
@@ -2859,6 +2964,10 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
 			"is unknown, you have been warned.\n", mod->name);
 	}
 
+	err = find_livepatch_modinfo(mod, info);
+	if (err)
+		return err;
+
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(info, "license"));
 
@@ -3222,6 +3331,12 @@ static noinline int do_init_module(struct module *mod)
 	 */
 	current->flags &= ~PF_USED_ASYNC;
 
+#ifdef CONFIG_KALLSYMS
+	/* Make symtab and strtab available prior to module init call */
+	mod->num_symtab = mod->core_num_syms;
+	mod->symtab = mod->core_symtab;
+	mod->strtab = mod->core_strtab;
+#endif
 	do_mod_ctors(mod);
 	/* Start the module */
 	if (mod->init != NULL)
@@ -3266,11 +3381,6 @@ static noinline int do_init_module(struct module *mod)
 	/* Drop initial reference. */
 	module_put(mod);
 	trim_init_extable(mod);
-#ifdef CONFIG_KALLSYMS
-	mod->num_symtab = mod->core_num_syms;
-	mod->symtab = mod->core_symtab;
-	mod->strtab = mod->core_strtab;
-#endif
 	mod_tree_remove_init(mod);
 	disable_ro_nx(&mod->init_layout);
 	module_arch_freeing_init(mod);
@@ -3522,6 +3632,13 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err < 0)
 		goto bug_cleanup;
 
+	/* For livepatch modules, save Elf info from load_info struct */
+	if (is_livepatch_module(mod)) {
+		err = copy_module_elf(mod, info);
+		if (err < 0)
+			goto sysfs_cleanup;
+	}
+
 	/* Get rid of temporary copy. */
 	free_copy(info);
 
@@ -3530,6 +3647,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	return do_init_module(mod);
 
+ sysfs_cleanup:
+	mod_sysfs_teardown(mod);
  bug_cleanup:
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
-- 
2.4.3
