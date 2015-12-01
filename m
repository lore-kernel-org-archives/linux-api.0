From: Jessica Yu <jeyu@redhat.com>
Subject: Re: module: preserve Elf information for livepatch modules
Date: Tue, 1 Dec 2015 16:06:01 -0500
Message-ID: <20151201210600.GD3974@packer-debian-8-amd64.digitalocean.com>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448943679-3412-3-git-send-email-jeyu@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>
Cc: linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Jessica Yu [30/11/15 23:21 -0500]:
>For livepatch modules, copy Elf section, symbol, and string information
>from the load_info struct in the module loader.
>
>Livepatch uses special relocation sections in order to be able to patch
>modules that are not yet loaded, as well as apply patches to the kernel
>when the addresses of symbols cannot be determined at compile time (for
>example, when kaslr is enabled). Livepatch modules must preserve Elf
>information such as section indices in order to apply the remaining
>relocation sections at the appropriate time (i.e. when the target module
>loads).
>
>Signed-off-by: Jessica Yu <jeyu@redhat.com>
>---
> include/linux/module.h |  9 +++++
> kernel/module.c        | 98 ++++++++++++++++++++++++++++++++++++++++++++++++--
> 2 files changed, 105 insertions(+), 2 deletions(-)
>
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 3a19c79..9b46256 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -425,6 +425,14 @@ struct module {
>
> 	/* Notes attributes */
> 	struct module_notes_attrs *notes_attrs;
>+
>+	/* Elf information (optionally saved) */
>+	Elf_Ehdr *hdr;
>+	Elf_Shdr *sechdrs;
>+	char *secstrings;
>+	struct {
>+		unsigned int sym, str, mod, vers, info, pcpu;
>+	} index;
> #endif

This particular patch unforunately breaks !CONFIG_KALLSYMS kernel
builds, as I've just discovered. These fields should move out of the
CONFIG_KALLSYMS block. And..

> 	/* The command line arguments (may be mangled).  People like
>@@ -461,6 +469,7 @@ struct module {
> #endif
>
> #ifdef CONFIG_LIVEPATCH
>+	bool klp; /* Is this a livepatch module? */
> 	bool klp_alive;
> #endif
>
>diff --git a/kernel/module.c b/kernel/module.c
>index 8f051a1..433c2d6 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -1984,6 +1984,13 @@ static void unset_module_core_ro_nx(struct module *mod) { }
> static void unset_module_init_ro_nx(struct module *mod) { }
> #endif
>
>+static void free_module_elf(struct module *mod)
>+{
>+	kfree(mod->hdr);
>+	kfree(mod->sechdrs);
>+	kfree(mod->secstrings);
>+}
>+
> void __weak module_memfree(void *module_region)
> {
> 	vfree(module_region);
>@@ -2022,6 +2029,9 @@ static void free_module(struct module *mod)
> 	/* Free any allocated parameters. */
> 	destroy_params(mod->kp, mod->num_kp);
>
>+	/* Free Elf information if it was saved */
>+	free_module_elf(mod);
>+
> 	/* Now we can delete it from the lists */
> 	mutex_lock(&module_mutex);
> 	/* Unlink carefully: kallsyms could be walking list. */
>@@ -2137,6 +2147,10 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
> 			       (long)sym[i].st_value);
> 			break;
>
>+		case SHN_LIVEPATCH:
>+			/* klp symbols are resolved by livepatch */
>+			break;
>+
> 		case SHN_UNDEF:
> 			ksym = resolve_symbol_wait(mod, info, name);
> 			/* Ok if resolved.  */
>@@ -2185,6 +2199,10 @@ static int apply_relocations(struct module *mod, const struct load_info *info)
> 		if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
> 			continue;
>
>+		/* klp relocation sections are applied by livepatch */
>+		if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
>+			continue;
>+
> 		if (info->sechdrs[i].sh_type == SHT_REL)
> 			err = apply_relocate(info->sechdrs, info->strtab,
> 					     info->index.sym, i, mod);
>@@ -2393,6 +2411,11 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
> {
> 	const Elf_Shdr *sechdrs = info->sechdrs;
>
>+	if (ELF_ST_BIND(sym->st_info) == STB_LIVEPATCH_EXT)
>+		return 'K';
>+	if (sym->st_shndx == SHN_LIVEPATCH)
>+		return 'k';
>+
> 	if (ELF_ST_BIND(sym->st_info) == STB_WEAK) {
> 		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT)
> 			return 'v';
>@@ -2475,7 +2498,7 @@ static void layout_symtab(struct module *mod, struct load_info *info)
>
> 	/* Compute total space required for the core symbols' strtab. */
> 	for (ndst = i = 0; i < nsrc; i++) {
>-		if (i == 0 ||
>+		if (i == 0 || mod->klp ||
> 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
> 			strtab_size += strlen(&info->strtab[src[i].st_name])+1;
> 			ndst++;
>@@ -2517,7 +2540,7 @@ static void add_kallsyms(struct module *mod, const struct load_info *info)
> 	mod->core_strtab = s = mod->module_core + info->stroffs;
> 	src = mod->symtab;
> 	for (ndst = i = 0; i < mod->num_symtab; i++) {
>-		if (i == 0 ||
>+		if (i == 0 || mod->klp ||
> 		    is_core_symbol(src+i, info->sechdrs, info->hdr->e_shnum)) {
> 			dst[ndst] = src[i];
> 			dst[ndst++].st_name = s - mod->core_strtab;
>@@ -2638,6 +2661,64 @@ static int elf_header_check(struct load_info *info)
> 	return 0;
> }
>
>+/*
>+ * copy_module_elf - preserve Elf information about a module
>+ */
>+static int copy_module_elf(struct module *mod, struct load_info *info)
>+{
>+	unsigned int size;
>+	int ret = 0;
>+	Elf_Shdr *symsect;
>+
>+	/* Elf header */
>+	size = sizeof(Elf_Ehdr);
>+	mod->hdr = kzalloc(size, GFP_KERNEL);
>+	if (mod->hdr == NULL) {
>+		ret = -ENOMEM;
>+		goto out;
>+	}
>+	memcpy(mod->hdr, info->hdr, size);
>+
>+	/* Elf section header table */
>+	size = sizeof(Elf_Shdr) * info->hdr->e_shnum;
>+	mod->sechdrs = kzalloc(size, GFP_KERNEL);
>+	if (mod->sechdrs == NULL) {
>+		ret = -ENOMEM;
>+		goto free_hdr;
>+	}
>+	memcpy(mod->sechdrs, info->sechdrs, size);
>+
>+	/* Elf section name string table */
>+	size = info->sechdrs[info->hdr->e_shstrndx].sh_size;
>+	mod->secstrings = kzalloc(size, GFP_KERNEL);
>+	if (mod->secstrings == NULL) {
>+		ret = -ENOMEM;
>+		goto free_sechdrs;
>+	}
>+	memcpy(mod->secstrings, info->secstrings, size);
>+
>+	/* Elf section indices */
>+	memcpy(&mod->index, &info->index, sizeof(info->index));
>+
>+	/*
>+	 * Update symtab's sh_addr to point to a valid
>+	 * symbol table, as the temporary symtab in module
>+	 * init memory will be freed
>+	 */
>+	symsect = mod->sechdrs + mod->index.sym;
>+	symsect->sh_addr = (unsigned long)mod->core_symtab;

..instead of relying on CONFIG_KALLSYMS being set, check for
CONFIG_KALLSYMS before the sh_addr assignment above (mod->core_symtab
only exists when CONFIG_KALLSYMS is set). Then we can leave
{free,copy}_module_elf() outside any #ifdef blocks.

Jessica
