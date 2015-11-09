From: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v3] livepatch: old_name,number scheme in livepatch sysfs
 directory
Date: Mon, 9 Nov 2015 17:01:18 -0600
Message-ID: <564125BE.2090604@canonical.com>
References: <20151105155656.GD28254@treble.redhat.com>
 <1447085770-11729-1-git-send-email-chris.j.arges@canonical.com>
 <20151109205608.GC3914@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151109205608.GC3914-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/09/2015 02:56 PM, Josh Poimboeuf wrote:
> I'd recommend splitting this up into two separate patches:
> 
> 1. introduce old_sympos
> 2. change the sysfs interface
> 
> On Mon, Nov 09, 2015 at 10:16:05AM -0600, Chris J Arges wrote:
>> In cases of duplicate symbols in vmlinux, old_sympos will be used to
>> disambiguate instead of old_addr. Normally old_sympos will be 0, and
>> default to only returning the first found instance of that symbol. If an
>> incorrect symbol position is specified then livepatching will fail.
> 
> In the case of old_sympos == 0, instead of just returning the first
> symbol it finds, I think it should ensure that the symbol is unique.  As
> Miroslav suggested:
> 
>   0 - default, preserve more or less current behaviour. If the symbol is 
>       unique there is no problem. If it is not the patching would fail.
>   1, 2, ... - occurrence of the symbol in kallsyms.
>   
>   The advantage is that if the user does not care and is certain that the 
>   symbol is unique he doesn't have to do anything. If the symbol is not 
>   unique he still has means how to solve it.
> 

So one part that will be confusing here is as follows.

If '0' is specified for old_sympos, should the symbol be 'func_name,0'
or 'func_name,1' provided we have a unique symbol? We could also default
to 'what the user provides', but this seems odd.

Another option would be to use no postfix when 0 is given, and only
introduce the ',n' postfix if old_sympos is > 0.

--chris

>> Finally, old_addr is now an internal structure element and not to be
>> specified by the user.
>>
>> The following directory structure will allow for cases when the same
>> function name exists in a single object.
>> 	/sys/kernel/livepatch/<patch>/<object>/<function.number>
> 
> Period should be changed to a comma.
> 
>> The number corresponds to the nth occurrence of the symbol name in
>> kallsyms for the patched object.
>>
>> An example of patching multiple symbols can be found here:
>> 	https://github.com/dynup/kpatch/issues/493
>>
>> Signed-off-by: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>  Documentation/ABI/testing/sysfs-kernel-livepatch |  6 ++-
>>  include/linux/livepatch.h                        | 20 ++++---
>>  kernel/livepatch/core.c                          | 66 ++++++++++++++++--------
>>  3 files changed, 61 insertions(+), 31 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
>> index 5bf42a8..21b6bc1 100644
>> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
>> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
>> @@ -33,7 +33,7 @@ Description:
>>  		The object directory contains subdirectories for each function
>>  		that is patched within the object.
>>  
>> -What:		/sys/kernel/livepatch/<patch>/<object>/<function>
>> +What:		/sys/kernel/livepatch/<patch>/<object>/<function,number>
>>  Date:		Nov 2014
>>  KernelVersion:	3.19.0
>>  Contact:	live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> @@ -41,4 +41,8 @@ Description:
>>  		The function directory contains attributes regarding the
>>  		properties and state of the patched function.
>>  
>> +		The directory name contains the patched function name and a
>> +		number corresponding to the nth occurrence of the symbol name
>> +		in kallsyms for the patched object.
>> +
>>  		There are currently no such attributes.
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 31db7a0..986e06d 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -37,8 +37,9 @@ enum klp_state {
>>   * struct klp_func - function structure for live patching
>>   * @old_name:	name of the function to be patched
>>   * @new_func:	pointer to the patched function code
>> - * @old_addr:	a hint conveying at what address the old function
>> + * @old_sympos: a hint indicating which symbol position the old function
>>   *		can be found (optional, vmlinux patches only)
> 
> Why is old_sympos only checked for vmlinux patches only?  It's a
> per-object count, so it should work for modules as well.
> 
>> + * @old_addr:	the address of the function being patched
>>   * @kobj:	kobject for sysfs resources
>>   * @state:	tracks function-level patch application state
>>   * @stack_node:	list node for klp_ops func_stack list
>> @@ -47,17 +48,20 @@ struct klp_func {
>>  	/* external */
>>  	const char *old_name;
>>  	void *new_func;
>> +
>>  	/*
>> -	 * The old_addr field is optional and can be used to resolve
>> -	 * duplicate symbol names in the vmlinux object.  If this
>> -	 * information is not present, the symbol is located by name
>> -	 * with kallsyms. If the name is not unique and old_addr is
>> -	 * not provided, the patch application fails as there is no
>> -	 * way to resolve the ambiguity.
>> +	 * The old_sympos field is optional and can be used to resolve duplicate
>> +	 * symbol names in the vmlinux object.  If this information is not
>> +	 * present, the first symbol located with kallsyms is used. This value
>> +	 * corresponds to the nth occurrence of the symbol name in kallsyms for
>> +	 * the patched object. If the name is not unique and old_sympos is not
>> +	 * provided, the patch application fails as there is no way to resolve
>> +	 * the ambiguity.
>>  	 */
>> -	unsigned long old_addr;
>> +	unsigned long old_sympos;
>>  
>>  	/* internal */
>> +	unsigned long old_addr;
>>  	struct kobject kobj;
>>  	enum klp_state state;
>>  	struct list_head stack_node;
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 6e53441..1dd0d44 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -142,6 +142,7 @@ struct klp_find_arg {
>>  	 * name in the same object.
>>  	 */
>>  	unsigned long count;
>> +	unsigned long pos;
>>  };
>>  
>>  static int klp_find_callback(void *data, const char *name,
>> @@ -166,28 +167,39 @@ static int klp_find_callback(void *data, const char *name,
>>  	args->addr = addr;
>>  	args->count++;
>>  
>> +	/*
>> +	 * ensure count matches the symbol position
>> +	 */
>> +	if (args->pos == (args->count-1))
>> +		return 1;
>> +
> 
> The code can be simplified a bit if args->addr only gets set when
> args->pos is a match.  Then klp_find_object_symbol() only needs to check
> args.addr to see if a match was found.
> 
>>  	return 0;
>>  }
>>  
>>  static int klp_find_object_symbol(const char *objname, const char *name,
>> -				  unsigned long *addr)
>> +				  unsigned long *addr, unsigned long sympos)
>>  {
>>  	struct klp_find_arg args = {
>>  		.objname = objname,
>>  		.name = name,
>>  		.addr = 0,
>> -		.count = 0
>> +		.count = 0,
>> +		.pos = sympos,
>>  	};
>>  
>>  	mutex_lock(&module_mutex);
>>  	kallsyms_on_each_symbol(klp_find_callback, &args);
>>  	mutex_unlock(&module_mutex);
>>  
>> -	if (args.count == 0)
>> +	/*
>> +	 * Ensure an address was found, then check that the symbol position
>> +	 * count matches sympos.
>> +	 */
>> +	if (args.addr == 0)
>>  		pr_err("symbol '%s' not found in symbol table\n", name);
>> -	else if (args.count > 1)
>> -		pr_err("unresolvable ambiguity (%lu matches) on symbol '%s' in object '%s'\n",
>> -		       args.count, name, objname);
>> +	else if (sympos != (args.count - 1))
>> +		pr_err("symbol position %lu for symbol '%s' in object '%s' not found\n",
>> +		       sympos, name, objname ? objname : "vmlinux");
>>  	else {
>>  		*addr = args.addr;
>>  		return 0;
>> @@ -239,20 +251,19 @@ static int klp_verify_vmlinux_symbol(const char *name, unsigned long addr)
>>  static int klp_find_verify_func_addr(struct klp_object *obj,
>>  				     struct klp_func *func)
>>  {
>> +	int sympos = 0;
>>  	int ret;
>>  
>> -#if defined(CONFIG_RANDOMIZE_BASE)
>> -	/* If KASLR has been enabled, adjust old_addr accordingly */
>> -	if (kaslr_enabled() && func->old_addr)
>> -		func->old_addr += kaslr_offset();
>> -#endif
>> +	if (func->old_sympos && !klp_is_module(obj))
>> +		sympos = func->old_sympos;
>>  
>> -	if (!func->old_addr || klp_is_module(obj))
>> -		ret = klp_find_object_symbol(obj->name, func->old_name,
>> -					     &func->old_addr);
>> -	else
>> -		ret = klp_verify_vmlinux_symbol(func->old_name,
>> -						func->old_addr);
>> +	/*
>> +	 * Verify the symbol, find old_addr, and write it to the structure.
>> +	 * By default sympos will be 0 and thus will only look for the first
>> +	 * occurrence. If another value is specified then that will be used.
>> +	 */
>> +	ret = klp_find_object_symbol(obj->name, func->old_name,
>> +				     &func->old_addr, sympos);
>>  
>>  	return ret;
>>  }
>> @@ -277,7 +288,7 @@ static int klp_find_external_symbol(struct module *pmod, const char *name,
>>  	preempt_enable();
>>  
>>  	/* otherwise check if it's in another .o within the patch module */
>> -	return klp_find_object_symbol(pmod->name, name, addr);
>> +	return klp_find_object_symbol(pmod->name, name, addr, 0);
>>  }
>>  
>>  static int klp_write_object_relocations(struct module *pmod,
>> @@ -307,7 +318,7 @@ static int klp_write_object_relocations(struct module *pmod,
>>  			else
>>  				ret = klp_find_object_symbol(obj->mod->name,
>>  							     reloc->name,
>> -							     &reloc->val);
>> +							     &reloc->val, 0);
> 
> I think it would be a good idea to also add old_sympos to klp_reloc so
> the relocation code is consistent with the klp_func symbol addressing.
>

So you are thinking as an optional external field as well? I'll have to
look at this a bit more but makes sense to me.
--chris


>>  			if (ret)
>>  				return ret;
>>  		}
>> @@ -587,7 +598,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
>>   * /sys/kernel/livepatch/<patch>
>>   * /sys/kernel/livepatch/<patch>/enabled
>>   * /sys/kernel/livepatch/<patch>/<object>
>> - * /sys/kernel/livepatch/<patch>/<object>/<func>
>> + * /sys/kernel/livepatch/<patch>/<object>/<func,number>
>>   */
>>  
>>  static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
>> @@ -732,8 +743,7 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>>  	INIT_LIST_HEAD(&func->stack_node);
>>  	func->state = KLP_DISABLED;
>>  
>> -	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
>> -				    &obj->kobj, "%s", func->old_name);
>> +	return 0;
>>  }
> 
> The sysfs entry can still be created here, since the function name and
> sympos are both already known.
> 
>>  
>>  /* parts of the initialization that is done only when the object is loaded */
>> @@ -755,6 +765,18 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>>  			return ret;
>>  	}
>>  
>> +	/*
>> +	 * for each function initialize and add, old_sympos will be already
>> +	 * verified at this point
>> +	 */
>> +	klp_for_each_func(obj, func) {
>> +		ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
>> +				    &obj->kobj, "%s,%lu", func->old_name,
>> +				    func->old_sympos ? func->old_sympos : 0);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> -- 
>> 1.9.1
>>
> 
