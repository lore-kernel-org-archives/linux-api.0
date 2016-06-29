From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: modules: add ro_after_init support
Date: Wed, 29 Jun 2016 17:27:14 -0400
Message-ID: <20160629212713.GB30908@packer-debian-8-amd64.digitalocean.com>
References: <1465863198-15947-1-git-send-email-jeyu@redhat.com>
 <1465863198-15947-2-git-send-email-jeyu@redhat.com>
 <8737nwdcog.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8737nwdcog.fsf-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Cc: Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Rusty Russell [29/06/16 10:38 +0930]:
>Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>> Add ro_after_init support for modules by adding a new page-aligned section
>> in the module layout (after rodata) for ro_after_init data and enabling RO
>> protection for that section after module init runs.
>>
>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
>I would prefer a "bool after_init" flag to module_enable_ro().  It's
>more explicit.

Sure thing, I was just initially worried about the
module_{enable,disable}_ro() asymmetry. :)

>Exposing the flags via uapi looks like a wart, but it's kind of a
>feature, since we don't *unset* it in any section; userspace may want to
>know about it.

Hm, I'm still unsure about this. I'm starting to think it might be a
bit overkill to expose SHF_RO_AFTER_INIT through uapi (although that
is where all the other SHF_* flags are defined) SHF_RO_AFTER_INIT
would technically be used only internally in the kernel (i.e. module
loader), and it'd also be considered a non-standard flag, using a bit
from SHF_MASKOS (OS-specific range). What do you think?

>If you could re-spin, that would be great.

Once I figure out where to put SHF_RO_AFTER_INIT, I'll send a v2.

Thanks for the review!
Jessica

>
>> ---
>>  include/linux/module.h   |  2 ++
>>  include/uapi/linux/elf.h |  1 +
>>  kernel/module.c          | 73 +++++++++++++++++++++++++++++++++++++++++-------
>>  3 files changed, 66 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index f777164..a698d23 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -311,6 +311,8 @@ struct module_layout {
>>  	unsigned int text_size;
>>  	/* Size of RO section of the module (text+rodata) */
>>  	unsigned int ro_size;
>> +	/* Size of RO after init section */
>> +	unsigned int ro_after_init_size;
>>
>>  #ifdef CONFIG_MODULES_TREE_LOOKUP
>>  	struct mod_tree_node mtn;
>> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
>> index cb4a72f..70b172ba 100644
>> --- a/include/uapi/linux/elf.h
>> +++ b/include/uapi/linux/elf.h
>> @@ -286,6 +286,7 @@ typedef struct elf64_phdr {
>>  #define SHF_ALLOC		0x2
>>  #define SHF_EXECINSTR		0x4
>>  #define SHF_RELA_LIVEPATCH	0x00100000
>> +#define SHF_RO_AFTER_INIT	0x00200000
>>  #define SHF_MASKPROC		0xf0000000
>>
>>  /* special section indexes */
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 7f21ab2..055bf6f 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1857,10 +1857,11 @@ static void mod_sysfs_teardown(struct module *mod)
>>   * from modification and any data from execution.
>>   *
>>   * General layout of module is:
>> - *          [text] [read-only-data] [writable data]
>> - * text_size -----^                ^               ^
>> - * ro_size ------------------------|               |
>> - * size -------------------------------------------|
>> + *          [text] [read-only-data] [ro-after-init] [writable data]
>> + * text_size -----^                ^               ^               ^
>> + * ro_size ------------------------|               |               |
>> + * ro_after_init_size -----------------------------|               |
>> + * size -----------------------------------------------------------|
>>   *
>>   * These values are always page-aligned (as is base)
>>   */
>> @@ -1883,14 +1884,24 @@ static void frob_rodata(const struct module_layout *layout,
>>  		   (layout->ro_size - layout->text_size) >> PAGE_SHIFT);
>>  }
>>
>> +static void frob_ro_after_init(const struct module_layout *layout,
>> +				int (*set_memory)(unsigned long start, int num_pages))
>> +{
>> +	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
>> +	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
>> +	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
>> +	set_memory((unsigned long)layout->base + layout->ro_size,
>> +		   (layout->ro_after_init_size - layout->ro_size) >> PAGE_SHIFT);
>> +}
>> +
>>  static void frob_writable_data(const struct module_layout *layout,
>>  			       int (*set_memory)(unsigned long start, int num_pages))
>>  {
>>  	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
>> -	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
>> +	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
>>  	BUG_ON((unsigned long)layout->size & (PAGE_SIZE-1));
>> -	set_memory((unsigned long)layout->base + layout->ro_size,
>> -		   (layout->size - layout->ro_size) >> PAGE_SHIFT);
>> +	set_memory((unsigned long)layout->base + layout->ro_after_init_size,
>> +		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
>>  }
>>
>>  /* livepatching wants to disable read-only so it can frob module. */
>> @@ -1898,6 +1909,7 @@ void module_disable_ro(const struct module *mod)
>>  {
>>  	frob_text(&mod->core_layout, set_memory_rw);
>>  	frob_rodata(&mod->core_layout, set_memory_rw);
>> +	frob_ro_after_init(&mod->core_layout, set_memory_rw);
>>  	frob_text(&mod->init_layout, set_memory_rw);
>>  	frob_rodata(&mod->init_layout, set_memory_rw);
>>  }
>> @@ -1908,11 +1920,16 @@ void module_enable_ro(const struct module *mod)
>>  	frob_rodata(&mod->core_layout, set_memory_ro);
>>  	frob_text(&mod->init_layout, set_memory_ro);
>>  	frob_rodata(&mod->init_layout, set_memory_ro);
>> +
>> +	/* after init */
>> +	if (mod->state == MODULE_STATE_LIVE)
>> +		frob_ro_after_init(&mod->core_layout, set_memory_ro);
>>  }
>>
>>  static void module_enable_nx(const struct module *mod)
>>  {
>>  	frob_rodata(&mod->core_layout, set_memory_nx);
>> +	frob_ro_after_init(&mod->core_layout, set_memory_nx);
>>  	frob_writable_data(&mod->core_layout, set_memory_nx);
>>  	frob_rodata(&mod->init_layout, set_memory_nx);
>>  	frob_writable_data(&mod->init_layout, set_memory_nx);
>> @@ -1921,6 +1938,7 @@ static void module_enable_nx(const struct module *mod)
>>  static void module_disable_nx(const struct module *mod)
>>  {
>>  	frob_rodata(&mod->core_layout, set_memory_x);
>> +	frob_ro_after_init(&mod->core_layout, set_memory_x);
>>  	frob_writable_data(&mod->core_layout, set_memory_x);
>>  	frob_rodata(&mod->init_layout, set_memory_x);
>>  	frob_writable_data(&mod->init_layout, set_memory_x);
>> @@ -1963,6 +1981,8 @@ static void disable_ro_nx(const struct module_layout *layout)
>>  	frob_text(layout, set_memory_rw);
>>  	frob_rodata(layout, set_memory_rw);
>>  	frob_rodata(layout, set_memory_x);
>> +	frob_ro_after_init(layout, set_memory_rw);
>> +	frob_ro_after_init(layout, set_memory_x);
>>  	frob_writable_data(layout, set_memory_x);
>>  }
>>
>> @@ -2305,6 +2325,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
>>  		 * finder in the two loops below */
>>  		{ SHF_EXECINSTR | SHF_ALLOC, ARCH_SHF_SMALL },
>>  		{ SHF_ALLOC, SHF_WRITE | ARCH_SHF_SMALL },
>> +		{ SHF_RO_AFTER_INIT | SHF_ALLOC, ARCH_SHF_SMALL },
>>  		{ SHF_WRITE | SHF_ALLOC, ARCH_SHF_SMALL },
>>  		{ ARCH_SHF_SMALL | SHF_ALLOC, 0 }
>>  	};
>> @@ -2336,7 +2357,11 @@ static void layout_sections(struct module *mod, struct load_info *info)
>>  			mod->core_layout.size = debug_align(mod->core_layout.size);
>>  			mod->core_layout.ro_size = mod->core_layout.size;
>>  			break;
>> -		case 3: /* whole core */
>> +		case 2: /* RO after init */
>> +			mod->core_layout.size = debug_align(mod->core_layout.size);
>> +			mod->core_layout.ro_after_init_size = mod->core_layout.size;
>> +			break;
>> +		case 4: /* whole core */
>>  			mod->core_layout.size = debug_align(mod->core_layout.size);
>>  			break;
>>  		}
>> @@ -2366,7 +2391,14 @@ static void layout_sections(struct module *mod, struct load_info *info)
>>  			mod->init_layout.size = debug_align(mod->init_layout.size);
>>  			mod->init_layout.ro_size = mod->init_layout.size;
>>  			break;
>> -		case 3: /* whole init */
>> +		case 2:
>> +			/*
>> +			 * RO after init doesn't apply to init_layout (only
>> +			 * core_layout), so it just takes the value of ro_size.
>> +			 */
>> +			mod->init_layout.ro_after_init_size = mod->init_layout.ro_size;
>> +			break;
>> +		case 4: /* whole init */
>>  			mod->init_layout.size = debug_align(mod->init_layout.size);
>>  			break;
>>  		}
>> @@ -3172,6 +3204,7 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>  {
>>  	/* Module within temporary copy. */
>>  	struct module *mod;
>> +	unsigned int ndx;
>>  	int err;
>>
>>  	mod = setup_load_info(info, flags);
>> @@ -3191,6 +3224,15 @@ static struct module *layout_and_allocate(struct load_info *info, int flags)
>>  	/* We will do a special allocation for per-cpu sections later. */
>>  	info->sechdrs[info->index.pcpu].sh_flags &= ~(unsigned long)SHF_ALLOC;
>>
>> +	/*
>> +	 * Mark ro_after_init section with SHF_RO_AFTER_INIT so that
>> +	 * layout_sections() can put it in the right place.
>> +	 * Note: ro_after_init sections also have SHF_{WRITE,ALLOC} set.
>> +	 */
>> +	ndx = find_sec(info, ".data..ro_after_init");
>> +	if (ndx)
>> +		info->sechdrs[ndx].sh_flags |= SHF_RO_AFTER_INIT;
>> +
>>  	/* Determine total sizes, and put offsets in sh_entsize.  For now
>>  	   this is done generically; there doesn't appear to be any
>>  	   special cases for the architectures. */
>> @@ -3357,12 +3399,19 @@ static noinline int do_init_module(struct module *mod)
>>  	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
>>  	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
>>  #endif
>> +	/*
>> +	 * RO and NX regions should already be protected at this point,
>> +	 * so the below module_enable_ro() call enables additional RO
>> +	 * protection for the ro_after_init section only.
>> +	 */
>> +	module_enable_ro(mod);
>>  	mod_tree_remove_init(mod);
>>  	disable_ro_nx(&mod->init_layout);
>>  	module_arch_freeing_init(mod);
>>  	mod->init_layout.base = NULL;
>>  	mod->init_layout.size = 0;
>>  	mod->init_layout.ro_size = 0;
>> +	mod->init_layout.ro_after_init_size = 0;
>>  	mod->init_layout.text_size = 0;
>>  	/*
>>  	 * We want to free module_init, but be aware that kallsyms may be
>> @@ -3454,7 +3503,11 @@ static int complete_formation(struct module *mod, struct load_info *info)
>>  	/* This relies on module_mutex for list integrity. */
>>  	module_bug_finalize(info->hdr, info->sechdrs, mod);
>>
>> -	/* Set RO and NX regions */
>> +	/*
>> +	 * Set RO and NX regions. Since module is not LIVE yet,
>> +	 * the ro_after_init section will remain RW until after
>> +	 * do_one_initcall().
>> +	 */
>>  	module_enable_ro(mod);
>>  	module_enable_nx(mod);
>>
>> --
>> 2.4.3
