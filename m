From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH v4 4/6] livepatch: reuse module loader code to write
 relocations
Date: Tue, 9 Feb 2016 15:01:06 +0100
Message-ID: <20160209140106.GC12548@pathway.suse.cz>
References: <1454548271-24923-1-git-send-email-jeyu@redhat.com>
 <1454548271-24923-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454548271-24923-5-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2016-02-03 20:11:09, Jessica Yu wrote:
> Reuse module loader code to write relocations, thereby eliminating the need
> for architecture specific relocation code in livepatch. Specifically, reuse
> the apply_relocate_add() function in the module loader to write relocations
> instead of duplicating functionality in livepatch's arch-dependent
> klp_write_module_reloc() function.
> 
> In order to accomplish this, livepatch modules manage their own relocation
> sections (marked with the SHF_RELA_LIVEPATCH section flag) and
> livepatch-specific symbols (marked with SHN_LIVEPATCH symbol section
> index). To apply livepatch relocation sections, livepatch symbols
> referenced by relocs are resolved and then apply_relocate_add() is called
> to apply those relocations.
> 
> In addition, remove x86 livepatch relocation code and the s390
> klp_write_module_reloc() function stub. They are no longer needed since
> relocation work has been offloaded to module loader.
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 7aa975d..c1fe57c 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -28,6 +28,9 @@
>  #include <linux/list.h>
>  #include <linux/kallsyms.h>
>  #include <linux/livepatch.h>
> +#include <linux/elf.h>
> +#include <linux/string.h>
> +#include <linux/moduleloader.h>
>  #include <asm/cacheflush.h>
>  
>  /**
> @@ -87,6 +90,166 @@ static bool klp_is_object_loaded(struct klp_object *obj)
>  	return !obj->name || obj->mod;
>  }
>  
> +/*
> + * Check if a livepatch symbol is formatted properly.
> + *
> + * See Documentation/livepatch/module-elf-format.txt for a
> + * detailed outline of requirements.
> + */
> +static int klp_check_symbol_format(struct module *pmod, Elf_Sym *sym)
> +{
> +	size_t len;
> +	char *s, *objname, *symname;
> +
> +	if (sym->st_shndx != SHN_LIVEPATCH)
> +		return -EINVAL;
> +
> +	/*
> +	 * Livepatch symbol names must follow this format:
> +	 * .klp.sym.objname.symbol_name,sympos
> +	 */
> +	s = pmod->strtab + sym->st_name;
> +	/* [.klp.sym.]objname.symbol_name,sympos */
> +	if (!s || strncmp(s, KLP_SYM_PREFIX, KLP_SYM_PREFIX_LEN))
> +		return -EINVAL;
> +
> +	/* .klp.sym.[objname].symbol_name,sympos */
> +	objname = s + KLP_SYM_PREFIX_LEN;
> +	len = strcspn(objname, ".");
> +	if (!(len > 0))
> +		return -EINVAL;
> +
> +	/* .klp.sym.objname.symbol_name,[sympos] */
> +	if (!strchr(s, ','))
> +		return -EINVAL;
> +
> +	/* .klp.sym.objname.[symbol_name],sympos */
> +	symname = objname + len + 1;
> +	len = strcspn(symname, ",");
> +	if (!(len > 0))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Check if a livepatch relocation section is formatted properly.
> + *
> + * See Documentation/livepatch/module-elf-format.txt for a
> + * detailed outline of requirements.
> + */
> +static int klp_check_relasec_format(struct module *pmod, Elf_Shdr *relasec)
> +{
> +	char *secname;
> +	size_t len;
> +
> +	secname = pmod->klp_info->secstrings + relasec->sh_name;
> +	/* [.klp.rela.]objname.section_name */
> +	if (!secname || strncmp(secname, KLP_RELASEC_PREFIX,
> +				KLP_RELASEC_PREFIX_LEN))
> +		return -EINVAL;
> +
> +	/* .klp.rela.[objname].section_name */
> +	len = strcspn(secname + KLP_RELASEC_PREFIX_LEN, ".");
> +	if (!(len > 0))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/*
> + * Check if obj->name matches the objname encoded in the rela
> + * section name (.klp.rela.[objname].section_name)
> + *
> + * Must pass klp_check_relasec_format() before calling this.
> + */
> +static bool klp_relasec_matches_object(struct module *pmod, Elf_Shdr *relasec,
> +				       struct klp_object *obj)
> +{
> +	size_t len;
> +	const char *obj_objname, *sec_objname, *secname;
> +
> +	secname = pmod->klp_info->secstrings + relasec->sh_name;
> +	/* .klp.rela.[objname].section_name */
> +	sec_objname = secname + KLP_RELASEC_PREFIX_LEN;
> +	obj_objname = klp_is_module(obj) ? obj->name : "vmlinux";
> +
> +	/* Get length of the objname encoded in the section name */
> +	len = strcspn(sec_objname, ".");
> +
> +	if (strlen(obj_objname) != len)
> +		return false;
> +
> +	return strncmp(sec_objname, obj_objname, len) ? false : true;
> +}
> +
> +/*
> + * klp_get_* helper functions
> + *
> + * klp_get_* functions extract different components of the name
> + * of a livepatch symbol. The full symbol name from the strtab
> + * is passed in as parameter @s, and @result is filled in with
> + * the extracted component.
> + *
> + * These functions assume a correctly formatted symbol and the
> + * klp_check_symbol_format() test *must* pass before calling any
> + * of these functions.
> + */
> +
> +/* .klp.sym.[objname].symbol_name,sympos */
> +static int klp_get_sym_objname(char *s, char **result)
> +{
> +	size_t len;
> +	char *objname, *objname_start;
> +
> +	/* .klp.sym.[objname].symbol_name,sympos */
> +	objname_start = s + KLP_SYM_PREFIX_LEN;
> +	len = strcspn(objname_start, ".");
> +	objname = kstrndup(objname_start, len, GFP_KERNEL);
> +	if (objname == NULL)
> +		return -ENOMEM;
> +
> +	/* klp_find_object_symbol() treats NULL as vmlinux */
> +	if (!strcmp(objname, "vmlinux")) {
> +		*result = NULL;
> +		kfree(objname);
> +	} else
> +		*result = objname;
> +
> +	return 0;
> +}
> +
> +/* .klp.sym.objname.[symbol_name],sympos */
> +static int klp_get_symbol_name(char *s, char **result)
> +{
> +	size_t len;
> +	char *objname, *symname;
> +
> +	/* .klp.sym.[objname].symbol_name,sympos */
> +	objname = s + KLP_SYM_PREFIX_LEN;
> +	len = strcspn(objname, ".");
> +
> +	/* .klp.sym.objname.[symbol_name],sympos */
> +	symname = objname + len + 1;
> +	len = strcspn(symname, ",");
> +
> +	*result = kstrndup(symname, len, GFP_KERNEL);
> +	if (*result == NULL)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +/* .klp.sym.objname.symbol_name,[sympos] */
> +static int klp_get_sympos(char *s, unsigned long *result)
> +{
> +	char *sympos;
> +
> +	/* .klp.sym.symbol_name,[sympos] */
> +	sympos = strchr(s, ',') + 1;
> +	return kstrtol(sympos, 10, result);
> +}

The usage of the helper function is nicely strightforward.
Also I like a lot all the comments with the [] brackets
that highlight what each check or search is for.

But I think that there is a lot of duplicated code in
the check_ and in the get_ functions. Also there is
a lot of strdup/free games.

The length of the elemets is limited by definition.
The functions are called under klp_mutex.

Therefore it might be easier to maintain a two parse
function that would fill static buffers and return
error in case of wrong value.

I mean something like:

static char mod_name[MODULE_NAME_LEN + 1];
static char symbol_name[KSYM_SYMBOL_LEN + 1];

static int
klp_parse_symbol_format(struct module *pmod, Elf_Sym *sym,
			char *mod_name, char *symbol_name,
			int *sympos)
{
	char *substr;


	/*
	 * Livepatch symbol names must follow this format:
	 * .klp.sym.objname.symbol_name,sympos
	 */
	s = pmod->strtab + sym->st_name;
	/* [.klp.sym.]objname.symbol_name,sympos */
	if (!s || strncmp(s, KLP_SYM_PREFIX, KLP_SYM_PREFIX_LEN))
		return -EINVAL;

	/* .klp.sym.[objname].symbol_name,sympos */
	substr = s + KLP_SYM_PREFIX_LEN;
	len = strcspn(substr, ".");
	if (!len || len > MODULE_NAME_LEN)
		return -EINVAL;
	strncpy(mod_name, substr, len);
	mod_name[len] = '\0';

	/* .klp.sym.objname.[symbol_name],sympos */
	substr = substr + len + 1;
	len = strcspn(substr, ",");
	if (!len || len > KSYM_SYMBOL_LEN)
		return -EINVAL;
	strncpy(symbol_name, substr, len);
	mod_name[len] = '\0';

	/* .klp.sym.objname.symbol_name,[sympos] */
	substr = substr + len + 1;
	len = strlen(substr);
	if (!len)
		return -EINVAL;

	return kstrtol(substr, 10, sympos);
}

How does that sound, please?

Best Regards,
Petr
