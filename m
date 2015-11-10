From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v3] livepatch: old_name,number scheme in livepatch sysfs
 directory
Date: Tue, 10 Nov 2015 10:02:14 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511100949590.16914@pobox.suse.cz>
References: <20151105155656.GD28254@treble.redhat.com> <1447085770-11729-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447085770-11729-1-git-send-email-chris.j.arges@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: live-patching@vger.kernel.org, jeyu@redhat.com, Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 9 Nov 2015, Chris J Arges wrote:

> In cases of duplicate symbols in vmlinux, old_sympos will be used to
> disambiguate instead of old_addr. Normally old_sympos will be 0, and
> default to only returning the first found instance of that symbol. If an
> incorrect symbol position is specified then livepatching will fail.
> Finally, old_addr is now an internal structure element and not to be
> specified by the user.

Hi,

Josh has already mentioned it, but in this case '0' would be same as '1'. 
'0' should fail if the symbol is ambiguous.

Few more things follow, but Josh pointed out the issues.

[...]

> @@ -239,20 +251,19 @@ static int klp_verify_vmlinux_symbol(const char *name, unsigned long addr)
>  static int klp_find_verify_func_addr(struct klp_object *obj,
>  				     struct klp_func *func)
>  {
> +	int sympos = 0;
>  	int ret;
>  
> -#if defined(CONFIG_RANDOMIZE_BASE)
> -	/* If KASLR has been enabled, adjust old_addr accordingly */
> -	if (kaslr_enabled() && func->old_addr)
> -		func->old_addr += kaslr_offset();
> -#endif
> +	if (func->old_sympos && !klp_is_module(obj))
> +		sympos = func->old_sympos;

We need to deal with ambiguity in modules as well. 

Also, maybe the function could be renamed, because there would be no 
verification here in the future.

>  static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
> @@ -732,8 +743,7 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  	INIT_LIST_HEAD(&func->stack_node);
>  	func->state = KLP_DISABLED;
>  
> -	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
> -				    &obj->kobj, "%s", func->old_name);
> +	return 0;
>  }
>  
>  /* parts of the initialization that is done only when the object is loaded */
> @@ -755,6 +765,18 @@ static int klp_init_object_loaded(struct klp_patch *patch,
>  			return ret;
>  	}
>  
> +	/*
> +	 * for each function initialize and add, old_sympos will be already
> +	 * verified at this point
> +	 */
> +	klp_for_each_func(obj, func) {
> +		ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
> +				    &obj->kobj, "%s,%lu", func->old_name,
> +				    func->old_sympos ? func->old_sympos : 0);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	return 0;
>  }

There is a problem with error handling in klp_init_object() after the 
change. 

free:
        klp_free_funcs_limited(obj, func);
        kobject_put(&obj->kobj);
        return ret;

This snippet ensures that all already created sysfs func entries are 
destroyed. 'func' is the function which klp_init_func() failed for (or 
'{}' if nothing failed). When you move kobject_init_and_add() with the 
loop to klp_init_object_loaded(), we do not know where the exact problem 
was in klp_init_object(). So I agree with Josh that it can stay in 
klp_init_func(). old_sympos is defined and if the following 
klp_find_verify_func_addr() fails (for example when old_sympos is '0' and 
the symbol is not unique) we deal with it here in klp_init_object() 
correctly.

Thanks,
Miroslav
