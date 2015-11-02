From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] livepatch: old_name.number scheme in livepatch sysfs
 directory
Date: Mon, 2 Nov 2015 14:16:16 -0600
Message-ID: <20151102201616.GA5438@canonical.com>
References: <1446487137-8469-1-git-send-email-chris.j.arges@canonical.com>
 <20151102195244.GD27488@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151102195244.GD27488@treble.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: live-patching@vger.kernel.org, jeyu@redhat.com, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 02, 2015 at 01:52:44PM -0600, Josh Poimboeuf wrote:
> On Mon, Nov 02, 2015 at 11:58:47AM -0600, Chris J Arges wrote:
> > The following directory structure will allow for cases when the same
> > function name exists in a single object.
> > 	/sys/kernel/livepatch/<patch>/<object>/<function.number>
> > 
> > The number is incremented on each known initialized func kobj thus creating
> > unique names in this case.
> > 
> > An example of this issue is documented here:
> > 	https://github.com/dynup/kpatch/issues/493
> > 
> > Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> > ---
> >  Documentation/ABI/testing/sysfs-kernel-livepatch |  2 +-
> >  kernel/livepatch/core.c                          | 20 ++++++++++++++++++--
> >  2 files changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > index 5bf42a8..dcd36db 100644
> > --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> > +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > @@ -33,7 +33,7 @@ Description:
> >  		The object directory contains subdirectories for each function
> >  		that is patched within the object.
> >  
> > -What:		/sys/kernel/livepatch/<patch>/<object>/<function>
> > +What:		/sys/kernel/livepatch/<patch>/<object>/<function.number>
> >  Date:		Nov 2014
> >  KernelVersion:	3.19.0
> >  Contact:	live-patching@vger.kernel.org
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 6e53441..ecacf65 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -587,7 +587,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
> >   * /sys/kernel/livepatch/<patch>
> >   * /sys/kernel/livepatch/<patch>/enabled
> >   * /sys/kernel/livepatch/<patch>/<object>
> > - * /sys/kernel/livepatch/<patch>/<object>/<func>
> > + * /sys/kernel/livepatch/<patch>/<object>/<func.number>
> >   */
> >  
> >  static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
> > @@ -727,13 +727,29 @@ static void klp_free_patch(struct klp_patch *patch)
> >  	kobject_put(&patch->kobj);
> >  }
> >  
> > +static int klp_count_sysfs_funcs(struct klp_object *obj, const char *name)
> > +{
> > +	struct klp_func *func;
> > +	int n = 0;
> > +
> > +	/* count the times a function name occurs and is initialized */
> > +	klp_for_each_func(obj, func) {
> > +		if ((!strcmp(func->old_name, name) &&
> > +		    func->kobj.state_initialized))
> > +			n++;
> > +	}
> > +
> > +	return n;
> > +}
> > +
> >  static int klp_init_func(struct klp_object *obj, struct klp_func *func)
> >  {
> >  	INIT_LIST_HEAD(&func->stack_node);
> >  	func->state = KLP_DISABLED;
> >  
> >  	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
> > -				    &obj->kobj, "%s", func->old_name);
> > +				    &obj->kobj, "%s.%d", func->old_name,
> > +				    klp_count_sysfs_funcs(obj, func->old_name));
> >  }
> >  
> >  /* parts of the initialization that is done only when the object is loaded */
> > -- 
> > 1.9.1
> 
> I'd prefer something other than a period for the string separator
> because some symbols have a period in their name.  How about a space?
> 

Perhaps a '-' would be better?
/t_next-0
/t_next-1

> Also, this shows the nth occurrence of the symbol name in the patch
> module.  But I think it would be better to instead display the nth
> occurrence of the symbol name in the kallsyms for the patched object.
> That way user space can deterministically detect which function was
> patched.
> 
> For example:
> 
>   $ grep " t_next" /proc/kallsyms
>   ffffffff811597d0 t t_next
>   ffffffff81163bb0 t t_next
>   ...
> 
> In my kernel there are 6 functions named t_next in vmlinux.  "t_next 0"
> would refer to the function at 0xffffffff811597d0.  "t_next 1" would
> refer to the one at 0xffffffff81163bb0.
> 

This makes sense to me.

> While we're at it, should we also encode the replacement function name
> (func->new_func)?  e.g.:
> 
>   "t_next 0 t_next__patched".
> 
> 
> -- 
> Josh
>

Since we are creating a directory for this function, at some point would we add
this as a file in that func directory? I think encoding the func name with
old_name + occurrence should accomplish uniqueness and consistency.

However, another approach would be:

/<old_func>-<new_func>

Which presumably would be unique and consistent (depending on how the patch was
authored).

--chris



 
