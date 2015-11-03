From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Tue, 3 Nov 2015 08:58:43 -0600
Message-ID: <20151103145843.GH27488@treble.redhat.com>
References: <20151102203241.GF27488@treble.redhat.com>
 <1446505187-28970-1-git-send-email-chris.j.arges@canonical.com>
 <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1511031146070.6257@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Miroslav Benes <mbenes@suse.cz>
Cc: Chris J Arges <chris.j.arges@canonical.com>, live-patching@vger.kernel.org, jeyu@redhat.com, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 03, 2015 at 11:52:08AM +0100, Miroslav Benes wrote:
> On Mon, 2 Nov 2015, Chris J Arges wrote:
> 
> [...]
> 
> > +static int klp_get_func_pos_callback(void *data, const char *name,
> > +				      struct module *mod, unsigned long addr)
> > +{
> > +	struct klp_find_arg *args = data;
> > +
> > +	if ((mod && !args->objname) || (!mod && args->objname))
> > +		return 0;
> > +
> > +	if (strcmp(args->name, name))
> > +		return 0;
> > +
> > +	if (args->objname && strcmp(args->objname, mod->name))
> > +		return 0;
> > +
> > +	/* on address match, return 1 to break kallsyms_on_each_symbol loop */
> > +	if (args->addr == addr)
> > +		return 1;
> > +
> > +	/* if we don't match addr, count instance of named symbol */
> > +	args->count++;
> > +
> > +	return 0;
> > +}
> > +
> > +static int klp_get_func_pos(struct klp_object *obj, struct klp_func *func)
> > +{
> > +	struct klp_find_arg args = {
> > +		.objname = obj->name,
> > +		.name = func->old_name,
> > +		.addr = func->old_addr,
> > +		.count = 0,
> > +	};
> > +
> > +	mutex_lock(&module_mutex);
> > +	kallsyms_on_each_symbol(klp_get_func_pos_callback, &args);
> > +	mutex_unlock(&module_mutex);
> > +
> > +	return args.count;
> > +}
> > +
> >  static int klp_init_func(struct klp_object *obj, struct klp_func *func)
> >  {
> >  	INIT_LIST_HEAD(&func->stack_node);
> >  	func->state = KLP_DISABLED;
> >  
> >  	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
> > -				    &obj->kobj, "%s", func->old_name);
> > +				    &obj->kobj, "%s,%d", func->old_name,
> > +				    klp_get_func_pos(obj, func));
> >  }
> 
> There is a problem which I missed before. klp_init_func() is called before 
> klp_find_verify_func_addr() in klp_init_object(). This means that 
> func->old_addr is either not verified yet or worse it is still 0. This 
> means that klp_get_func_pos_callback() never returns 1 and is thus called 
> on each symbol. So if you for example patched cmdline_proc_show the 
> resulting directory in sysfs would be called cmdline_proc_show,1 because 
> addr is never matched. Had old_addr been specified the name would have 
> been probably correct, but not for sure.
> 
> This should be fixed as well.

Even worse, klp_init_func() can be called even if the object hasn't been
loaded.  In that case there's no way to know what the value of n is, and
therefore no way to reliably create the sysfs entry.

Should we create "func,n" in klp_init_object_loaded() instead of
klp_init_func()?

-- 
Josh
