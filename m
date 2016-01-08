From: Jessica Yu <jeyu@redhat.com>
Subject: [RFC PATCH v3 2/6] module: preserve Elf information for livepatch modules
Date: Fri,  8 Jan 2016 14:28:20 -0500
Message-ID: <1452281304-28618-3-git-send-email-jeyu@redhat.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

For livepatch modules, copy Elf section, symbol, and string information
from the load_info struct in the module loader.

Livepatch uses special relocation sections in order to be able to patch
modules that are not yet loaded, as well as apply patches to the kernel
when the addresses of symbols cannot be determined at compile time (for
example, when kaslr is enabled). Livepatch modules must preserve Elf
information such as section indices in order to apply the remaining
relocation sections at the appropriate time (i.e. when the target module
loads).

Signed-off-by: Jessica Yu <jeyu@redhat.com>
---
 include/linux/module.h |  31 ++++++++++
 kernel/module.c        | 149 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 164 insertions(+), 16 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 4560d8f..ba6052d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -281,6 +281,21 @@ void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
 #define symbol_get(x) ((typeof(&x))(__symbol_get(VMLINUX_SYMBOL_STR(x))))
 
+struct load_info {
+	Elf_Ehdr *hdr;
+	unsigned long len;
+	Elf_Shdr *sechdrs;
+	char *secstrings, *strtab;
+	unsigned long symoffs, stroffs;
+	struct _ddebug *debug;
+	unsigned int num_debug;
+	bool sig_ok;
+	struct {
+		unsigned int sym, str, mod, vers, info, pcpu;
+	} index;
+};
+
+
 /* modules using other modules: kdb wants to see this. */
 struct module_use {
 	struct list_head source_list;
@@ -455,7 +470,11 @@ struct module {
 #endif
 
 #ifdef CONFIG_LIVEPATCH
+	bool klp; /* Is this a livepatch module? */
 	bool klp_alive;
+
+	/* Elf information */
+	struct load_info *info;
 #endif
 
 #ifdef CONFIG_MODULE_UNLOAD
@@ -798,4 +817,16 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
+#ifdef CONFIG_LIVEPATCH
+static inline bool is_livepatch_module(struct module *mod)
+{
+	return mod->klp;
+}
+#else
+static inline bool is_livepatch_module(struct module *mod)
+{
+	return false;
+}
+#endif /* CONFIG_LIVEPATCH */
+
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/module.c b/kernel/module.c
index 912e891..3d14e36 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -294,20 +294,6 @@ int unregister_module_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_module_notifier);
 
-struct load_info {
-	Elf_Ehdr *hdr;
-	unsigned long len;
-	Elf_Shdr *sechdrs;
-	char *secstrings, *strtab;
-	unsigned long symoffs, stroffs;
-	struct _ddebug *debug;
-	unsigned int num_debug;
-	bool sig_ok;
-	struct {
-		unsigned int sym, str, mod, vers, info, pcpu;
-	} index;
-};
-
 /* We require a truly strong try_module_get(): 0 means failure due to
    ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
@@ -1966,6 +1952,89 @@ static void module_enable_nx(const struct module *mod) { }
 static void module_disable_nx(const struct module *mod) { }
 #endif
 
+#ifdef CONFIG_LIVEPATCH
+/*
+ * copy_module_elf - preserve Elf information about a module
+ *
+ * Copy relevant Elf information from the load_info struct.
+ * Note: not all fields from the original load_info are
+ * copied into mod->info.
+ */
+static int copy_module_elf(struct module *mod, struct load_info *info)
+{
+	unsigned int size;
+	int ret = 0;
+
+	mod->info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (mod->info == NULL)
+		return -ENOMEM;
+
+	/* Elf header */
+	size = sizeof(Elf_Ehdr);
+	mod->info->hdr = kmalloc(size, GFP_KERNEL);
+	if (mod->info->hdr == NULL) {
+		ret = -ENOMEM;
+		goto free_info;
+	}
+	memcpy(mod->info->hdr, info->hdr, size);
+
+	/* Elf section header table */
+	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;
+	mod->info->sechdrs = kmalloc(size, GFP_KERNEL);
+	if (mod->info->sechdrs == NULL) {
+		ret = -ENOMEM;
+		goto free_hdr;
+	}
+	memcpy(mod->info->sechdrs, info->sechdrs, size);
+
+	/* Elf section name string table */
+	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
+	mod->info->secstrings = kmalloc(size, GFP_KERNEL);
+	if (mod->info->secstrings == NULL) {
+		ret = -ENOMEM;
+		goto free_sechdrs;
+	}
+	memcpy(mod->info->secstrings, info->secstrings, size);
+
+	/* Elf section indices */
+	memcpy(&mod->info->index, &info->index, sizeof(info->index));
+
+	/*
+	 * Update symtab's sh_addr to point to a valid
+	 * symbol table, as the temporary symtab in module
+	 * init memory will be freed
+	 */
+	mod->info->sechdrs[mod->info->index.sym].sh_addr = (unsigned long)mod->core_symtab;
+
+	return ret;
+
+free_sechdrs:
+	kfree(mod->info->sechdrs);
+free_hdr:
+	kfree(mod->info->hdr);
+free_info:
+	kfree(mod->info);
+	return ret;
+}
+
+static void free_module_elf(struct module *mod)
+{
+	kfree(mod->info->sechdrs);
+	kfree(mod->info->hdr);
+	kfree(mod->info->secstrings);
+	kfree(mod->info);
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
@@ -2004,6 +2073,10 @@ static void free_module(struct module *mod)
 	/* Free any allocated parameters. */
 	destroy_params(mod->kp, mod->num_kp);
 
+	/* Free Elf information if it was saved */
+	if (is_livepatch_module(mod))
+		free_module_elf(mod);
+
 	/* Now we can delete it from the lists */
 	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
@@ -2119,6 +2192,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			       (long)sym[i].st_value);
 			break;
 
+		case SHN_LIVEPATCH:
+			/* klp symbols are resolved by livepatch */
+			break;
+
 		case SHN_UNDEF:
 			ksym = resolve_symbol_wait(mod, info, name);
 			/* Ok if resolved.  */
@@ -2167,6 +2244,10 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
 			continue;
 
+		/* klp relocation sections are applied by livepatch */
+		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
+			continue;
+
 		if (info->sechdrs[i].sh_type == SHT_REL)
 			err = apply_relocate(info->sechdrs, info->strtab,
 					     info->index.sym, i, mod);
@@ -2385,6 +2466,8 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
 		return 'U';
 	if (sym->st_shndx == SHN_ABS || sym->st_shndx == info->index.pcpu)
 		return 'a';
+	if (sym->st_shndx == SHN_LIVEPATCH)
+		return 'k';
 	if (sym->st_shndx >= SHN_LORESERVE)
 		return '?';
 	if (sechdrs[sym->st_shndx].sh_flags & SHF_EXECINSTR)
@@ -2462,7 +2545,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 
 	/* Compute total space required for the core symbols' strtab. */
 	for (ndst = i = 0; i < nsrc; i++) {
-		if (i == 0 ||
+		if (i == 0 || is_livepatch_module(mod) ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
 				   info->index.pcpu)) {
 			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
@@ -2505,7 +2588,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
 	mod->core_strtab = s = mod->core_layout.base + info->stroffs;
 	src = mod->symtab;
 	for (ndst = i = 0; i < mod->num_symtab; i++) {
-		if (i == 0 ||
+		if (i == 0 || is_livepatch_module(mod) ||
 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
 				   info->index.pcpu)) {
 			dst[ndst] = src[i];
@@ -2672,6 +2755,24 @@ static int copy_module_from_user(const void __user *umod, unsigned long len,
 	return 0;
 }
 
+#ifdef CONFIG_LIVEPATCH
+static int check_livepatch_modinfo(struct module *mod, struct load_info *info)
+{
+	mod->klp = get_modinfo(info, "livepatch") ? true : false;
+
+	return 0;
+}
+#else
+static int check_livepatch_modinfo(struct module *mod, struct load_info *info)
+{
+	if (get_modinfo(info, "livepatch"))
+		return -EINVAL;
+
+	return 0;
+}
+#endif
+
+
 /* Sets info->hdr and info->len. */
 static int copy_module_from_fd(int fd, struct load_info *info)
 {
@@ -2855,6 +2956,10 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
 			"is unknown, you have been warned.\n", mod->name);
 	}
 
+	err = check_livepatch_modinfo(mod, info);
+	if (err)
+		return -ENOEXEC;
+
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(info, "license"));
 
@@ -3511,6 +3616,16 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err < 0)
 		goto bug_cleanup;
 
+	/*
+	 * Save sechdrs, indices, and other data from
+	 * load_info for livepatch modules
+	 */
+	if (is_livepatch_module(mod)) {
+		err = copy_module_elf(mod, info);
+		if (err < 0)
+			goto sysfs_cleanup;
+	}
+
 	/* Get rid of temporary copy. */
 	free_copy(info);
 
@@ -3519,6 +3634,8 @@ static int load_module(struct load_info *info, const char __user *uargs,
 
 	return do_init_module(mod);
 
+ sysfs_cleanup:
+	mod_sysfs_teardown(mod);
  bug_cleanup:
 	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
-- 
2.4.3
