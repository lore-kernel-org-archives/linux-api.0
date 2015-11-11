From: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3 v4] livepatch: old_name,number scheme in livepatch
 sysfs directory
Date: Wed, 11 Nov 2015 12:01:56 -0600
Message-ID: <20151111180156.GG5331@treble.redhat.com>
References: <20151103200608.GQ27488@treble.redhat.com>
 <1447259366-7055-1-git-send-email-chris.j.arges@canonical.com>
 <1447259366-7055-4-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447259366-7055-4-git-send-email-chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 11, 2015 at 10:29:01AM -0600, Chris J Arges wrote:
> The following directory structure will allow for cases when the same
> function name exists in a single object.
> 	/sys/kernel/livepatch/<patch>/<object>/<function,number>
> 
> The number corresponds to the nth occurrence of the symbol name in
> kallsyms for the patched object.
> 
> An example of patching multiple symbols can be found here:
> 	https://github.com/dynup/kpatch/issues/493

Instead of 'function,number' here and everywhere else, maybe
'function,sympos' would be a little clearer.

Also, s/old_name/function/ in the patch subject to be consistent.

> Signed-off-by: Chris J Arges <chris.j.arges-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  Documentation/ABI/testing/sysfs-kernel-livepatch |  6 +++++-
>  kernel/livepatch/core.c                          | 10 ++++++++--
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
> index 5bf42a8..21b6bc1 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -33,7 +33,7 @@ Description:
>  		The object directory contains subdirectories for each function
>  		that is patched within the object.
>  
> -What:		/sys/kernel/livepatch/<patch>/<object>/<function>
> +What:		/sys/kernel/livepatch/<patch>/<object>/<function,number>
>  Date:		Nov 2014
>  KernelVersion:	3.19.0
>  Contact:	live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> @@ -41,4 +41,8 @@ Description:
>  		The function directory contains attributes regarding the
>  		properties and state of the patched function.
>  
> +		The directory name contains the patched function name and a
> +		number corresponding to the nth occurrence of the symbol name
> +		in kallsyms for the patched object.
> +
>  		There are currently no such attributes.
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 4eb8691..ed2cbbf 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -542,7 +542,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
>   * /sys/kernel/livepatch/<patch>
>   * /sys/kernel/livepatch/<patch>/enabled
>   * /sys/kernel/livepatch/<patch>/<object>
> - * /sys/kernel/livepatch/<patch>/<object>/<func>
> + * /sys/kernel/livepatch/<patch>/<object>/<func,number>
>   */
>  
>  static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
> @@ -687,8 +687,14 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  	INIT_LIST_HEAD(&func->stack_node);
>  	func->state = KLP_DISABLED;
>  
> +	/* The format for the sysfs directory is <func,number> where number is
> +	 * the occurrence of this symbol in kallsyms. If the user selects 0 for

... of this symbol in kallsyms *for the patched object*.

> +	 * old_sympos, then 1 will be used since a unique symbol will be the
> +	 * first occurrence.
> +	 */
>  	return kobject_init_and_add(&func->kobj, &klp_ktype_func,
> -				    &obj->kobj, "%s", func->old_name);
> +				    &obj->kobj, "%s,%lu", func->old_name,
> +				    func->old_sympos ? func->old_sympos : 1);
>  }
>  
>  /* parts of the initialization that is done only when the object is loaded */
> -- 
> 1.9.1

-- 
Josh
