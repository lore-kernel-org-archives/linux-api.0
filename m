From: Minfei Huang <mnfhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/6] livepatch: reuse module loader code to write
 relocations
Date: Thu, 10 Dec 2015 22:20:32 +0800
Message-ID: <20151210142032.GA2399@huangminfeis-MacBook-Pro.local>
References: <1448943679-3412-1-git-send-email-jeyu@redhat.com>
 <1448943679-3412-5-git-send-email-jeyu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448943679-3412-5-git-send-email-jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/30/15 at 11:21P, Jessica Yu wrote:
> +	klp_for_each_reloc_sec(obj, reloc_sec) {
> +		relindex = reloc_sec->index;
> +		num_relas = pmod->sechdrs[relindex].sh_size / sizeof(Elf_Rela);
> +		rela = (Elf_Rela *) pmod->sechdrs[relindex].sh_addr;
> +
> +		/* For each rela in this __klp_rela section */
> +		for (i = 0; i < num_relas; i++, rela++) {
> +			sym = symtab + ELF_R_SYM(rela->r_info);
> +			symname = pmod->core_strtab + sym->st_name;
> +
> +			if (sym->st_shndx == SHN_LIVEPATCH) {
> +				if (sym->st_info == 'K')
> +					ret = klp_find_external_symbol(pmod, symname, &addr);
> +				else
> +					ret = klp_find_object_symbol(obj->name, symname, &addr);
> +				if (ret)
> +					return ret;
> +				sym->st_value = addr;
> +			}
>  		}
> +		ret = apply_relocate_add(pmod->sechdrs, pmod->core_strtab,
> +					 pmod->index.sym, relindex, pmod);

It is more appropiate to test the ret.

Thanks
Minfei

>  	}
>  
> -	return 0;
> +	return ret;
