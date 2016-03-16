From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Wed, 16 Mar 2016 17:25:56 -0400
Message-ID: <20160316212556.GB6872@packer-debian-8-amd64.digitalocean.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1458157628-8264-3-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [16/03/16 15:47 -0400]:
>For livepatch modules, copy Elf section, symbol, and string information
>from the load_info struct in the module loader. Persist copies of the
>original symbol table and string table.
>
>Livepatch manages its own relocation sections in order to reuse module
>loader code to write relocations. Livepatch modules must preserve Elf
>information such as section indices in order to apply livepatch relocation
>sections using the module loader's apply_relocate_add() function.
>
>In order to apply livepatch relocation sections, livepatch modules must
>keep a complete copy of their original symbol table in memory. Normally, a
>stripped down copy of a module's symbol table (containing only "core"
>symbols) is made available through module->core_symtab. But for livepatch
>modules, the symbol table copied into memory on module load must be exactly
>the same as the symbol table produced when the patch module was compiled.
>This is because the relocations in each livepatch relocation section refer
>to their respective symbols with their symbol indices, and the original
>symbol indices (and thus the symtab ordering) must be preserved in order
>for apply_relocate_add() to find the right symbol.
>
>Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>---
> include/linux/module.h |  25 ++++++++++
> kernel/module.c        | 123 ++++++++++++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 146 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 2bb0c30..3daf2b3 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -330,6 +330,15 @@ struct mod_kallsyms {
> 	char *strtab;
> };
>
>+#ifdef CONFIG_LIVEPATCH
>+struct klp_modinfo {
>+	Elf_Ehdr hdr;
>+	Elf_Shdr *sechdrs;
>+	char *secstrings;
>+	unsigned int symndx;
>+};
>+#endif
>+
> struct module {
> 	enum module_state state;
>
>@@ -456,7 +465,11 @@ struct module {
> #endif
>
> #ifdef CONFIG_LIVEPATCH
>+	bool klp; /* Is this a livepatch module? */
> 	bool klp_alive;
>+
>+	/* Elf information */
>+	struct klp_modinfo *klp_info;
> #endif
>
> #ifdef CONFIG_MODULE_UNLOAD
>@@ -630,6 +643,18 @@ static inline bool module_requested_async_probing(struct module *module)
> 	return module && module->async_probe_requested;
> }
>
>+#ifdef CONFIG_LIVEPATCH
>+static inline bool is_livepatch_module(struct module *mod)
>+{
>+	return mod->klp;
>+}
>+#else /* !CONFIG_LIVEPATCH */
>+static inline bool is_livepatch_module(struct module *mod)
>+{
>+	return false;
>+}
>+#endif /* CONFIG_LIVEPATCH */
>+
> #else /* !CONFIG_MODULES... */
>
> /* Given an address, look for it in the exception tables. */
>diff --git a/kernel/module.c b/kernel/module.c
>index 87cfeb2..80b7fd9 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -1971,6 +1971,82 @@ static void module_enable_nx(const struct module *mod) { }
> static void module_disable_nx(const struct module *mod) { }
> #endif
>
>+#ifdef CONFIG_LIVEPATCH
>+/*
>+ * Persist Elf information about a module. Copy the Elf header,
>+ * section header table, section string table, and symtab section
>+ * index from info to mod->klp_info.
>+ */
>+static int copy_module_elf(struct module *mod, struct load_info *info)
>+{
>+	unsigned int size, symndx;
>+	int ret;
>+
>+	size = sizeof(*mod->klp_info);
>+	mod->klp_info = kmalloc(size, GFP_KERNEL);
>+	if (mod->klp_info == NULL)
>+		return -ENOMEM;
>+
>+	/* Elf header */
>+	size = sizeof(Elf_Ehdr);
>+	memcpy(&mod->klp_info->hdr, info->hdr, size);
>+
>+	/* Elf section header table */
>+	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;
>+	mod->klp_info->sechdrs = kmalloc(size, GFP_KERNEL);
>+	if (mod->klp_info->sechdrs == NULL) {
>+		ret = -ENOMEM;
>+		goto free_info;
>+	}
>+	memcpy(mod->klp_info->sechdrs, info->sechdrs, size);
>+
>+	/* Elf section name string table */
>+	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
>+	mod->klp_info->secstrings = kmalloc(size, GFP_KERNEL);
>+	if (mod->klp_info->secstrings == NULL) {
>+		ret = -ENOMEM;
>+		goto free_sechdrs;
>+	}
>+	memcpy(mod->klp_info->secstrings, info->secstrings, size);
>+
>+	/* Elf symbol section index */
>+	symndx = info->index.sym;
>+	mod->klp_info->symndx = symndx;
>+
>+	/*
>+	 * For livepatch modules, core_symtab is a complete copy
>+	 * of the original symbol table. Adjust sh_addr to point
>+	 * to core_symtab since the copy of the symtab in module
>+	 * init memory is freed at the end of do_init_module().
>+	 */
>+	mod->klp_info->sechdrs[symndx].sh_addr = (unsigned long) mod->core_kallsyms.symtab;
>+
>+	return 0;
>+
>+free_sechdrs:
>+	kfree(mod->klp_info->sechdrs);
>+free_info:
>+	kfree(mod->klp_info);
>+	return ret;
>+}
>+
>+static void free_module_elf(struct module *mod)
>+{
>+	kfree(mod->klp_info->sechdrs);
>+	kfree(mod->klp_info->secstrings);
>+	kfree(mod->klp_info);
>+}
>+#else /* !CONFIG_LIVEPATCH */
>+static int copy_module_elf(struct module *mod, struct load_info *info)
>+{
>+	return 0;
>+}
>+
>+static void free_module_elf(struct module *mod)
>+{
>+}
>+#endif /* CONFIG_LIVEPATCH */
>+
> void __weak module_memfree(void *module_region)
> {
> 	vfree(module_region);
>@@ -2009,6 +2085,9 @@ static void free_module(struct module *mod)
> 	/* Free any allocated parameters. */
> 	destroy_params(mod->kp, mod->num_kp);
>
>+	if (is_livepatch_module(mod))
>+		free_module_elf(mod);
>+
> 	/* Now we can delete it from the lists */
> 	mutex_lock(&module_mutex);
> 	/* Unlink carefully: kallsyms could be walking list. */
>@@ -2124,6 +2203,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
> 			       (long)sym[i].st_value);
> 			break;
>
>+		case SHN_LIVEPATCH:
>+			/* Livepatch symbols are resolved by livepatch */
>+			break;
>+
> 		case SHN_UNDEF:
> 			ksym = resolve_symbol_wait(mod, info, name);
> 			/* Ok if resolved.  */
>@@ -2172,6 +2255,10 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
> 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
> 			continue;
>
>+		/* Livepatch relocation sections are applied by livepatch */
>+		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
>+			continue;
>+
> 		if (info->sechdrs[i].sh_type == SHT_REL)
> 			err = apply_relocate(info->sechdrs, info->strtab,
> 					     info->index.sym, i, mod);
>@@ -2467,7 +2554,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
>
> 	/* Compute total space required for the core symbols' strtab. */
> 	for (ndst = i = 0; i < nsrc; i++) {
>-		if (i == 0 ||
>+		if (i == 0 || is_livepatch_module(mod) ||
> 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
> 				   info->index.pcpu)) {
> 			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
>@@ -2526,7 +2613,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
> 	mod->core_kallsyms.strtab = s = mod->core_layout.base + info->stroffs;
> 	src = mod->kallsyms->symtab;
> 	for (ndst = i = 0; i < mod->kallsyms->num_symtab; i++) {
>-		if (i == 0 ||
>+		if (i == 0 || is_livepatch_module(mod) ||
> 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum,
> 				   info->index.pcpu)) {
> 			dst[ndst] = src[i];
>@@ -2665,6 +2752,26 @@ static int copy_chunked_from_user(void *dst, const void __user *usrc, unsigned l
> 	return 0;
> }
>
>+#ifdef CONFIG_LIVEPATCH
>+static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
>+{
>+	mod->klp = get_modinfo(info, "livepatch") ? true : false;
>+
>+	return 0;
>+}
>+#else /* !CONFIG_LIVEPATCH */
>+static int find_livepatch_modinfo(struct module *mod, struct load_info *info)
>+{
>+	if (get_modinfo(info, "livepatch")) {
>+		pr_err("%s: module is marked as livepatch module, but livepatch support is disabled"
>+		       mod->name);

...And that is why I should have tested the changes with !CONFIG_LIVEPATCH
before sending this out. :-\ The above line should've been (w/ comma and newline):

	pr_err("%s: module is marked as livepatch module, but livepatch support is disabled\n",
		mod->name);

Jessica
