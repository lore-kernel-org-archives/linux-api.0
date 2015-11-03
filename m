From: Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Tue, 3 Nov 2015 11:52:08 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz>
References: <20151102203241.GF27488@treble.redhat.com> <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446505187-28970-1-git-send-email-chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2 Nov 2015, Chris J Arges wrote:

[...]

> +static int klp_get_func_pos_callback(void *data, const char *name,
> +				      struct module *mod, unsigned long addr)
> +{
> +	struct klp_find_arg *args = data;
> +
> +	if ((mod && !args->objname) || (!mod && args->objname))
> +		return 0;
> +
> +	if (strcmp(args->name, name))
> +		return 0;
> +
> +	if (args->objname && strcmp(args->objname, mod->name))
> +		return 0;
> +
> +	/* on address match, return 1 to break kallsyms_on_each_symbol loop */
> +	if (args->addr == addr)
> +		return 1;
> +
> +	/* if we don't match addr, count instance of named symbol */
> +	args->count++;
> +
> +	return 0;
> +}
> +
> +static int klp_get_func_pos(struct klp_object *obj, struct klp_func *func)
> +{
> +	struct klp_find_arg args = {
> +		.objname = obj->name,
> +		.name = func->old_name,
> +		.addr = func->old_addr,
> +		.count = 0,
> +	};
> +
> +	mutex_lock(&module_mutex);
> +	kallsyms_on_each_symbol(klp_get_func_pos_callback, &args);
> +	mutex_unlock(&module_mutex);
> +
> +	return args.count;
> +}
> +
>  static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  {
>  	INIT_LIST_HEAD(&func->stack_node);
>  	func->state = KLP_DISABLED;
>  
>  	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
> -				    &obj->kobj, "%s", func->old_name);
> +				    &obj->kobj, "%s,%d", func->old_name,
> +				    klp_get_func_pos(obj, func));
>  }

There is a problem which I missed before. klp_init_func() is called before 
klp_find_verify_func_addr() in klp_init_object(). This means that 
func->old_addr is either not verified yet or worse it is still 0. This 
means that klp_get_func_pos_callback() never returns 1 and is thus called 
on each symbol. So if you for example patched cmdline_proc_show the 
resulting directory in sysfs would be called cmdline_proc_show,1 because 
addr is never matched. Had old_addr been specified the name would have 
been probably correct, but not for sure.

This should be fixed as well.

Miroslav
