From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCHv6 01/36] ns: Introduce Time Namespace
Date: Thu, 15 Aug 2019 23:11:19 -0700
Message-ID: <20190816061119.GA14312@gmail.com>
References: <20190815163836.2927-1-dima@arista.com>
 <20190815163836.2927-2-dima@arista.com>
 <alpine.DEB.2.21.1908151908230.1908@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908151908230.1908@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Aug 15, 2019 at 07:19:12PM +0200, Thomas Gleixner wrote:
> Dmitry,
> 
> On Thu, 15 Aug 2019, Dmitry Safonov wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 420567d1519a..97b7737f5aba 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -12898,6 +12898,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
> >  S:	Maintained
> >  F:	fs/timerfd.c
> >  F:	include/linux/timer*
> > +F:	include/linux/time_namespace.h
> > +F:	kernel/time_namespace.c
> 
> Shouldn't this be kernel/time/namespace.c so all that stuff is lumped
> together. No strong opinion though.

Sure, we can move this in kernel/time. I don't remember why I decided to
place it in kernel/.

> 
> > +++ b/kernel/time_namespace.c
> > +static struct ucounts *inc_time_namespaces(struct user_namespace *ns)
> > +{
> > +	return inc_ucount(ns, current_euid(), UCOUNT_TIME_NAMESPACES);
> > +}
> > +
> > +static void dec_time_namespaces(struct ucounts *ucounts)
> > +{
> > +	dec_ucount(ucounts, UCOUNT_TIME_NAMESPACES);
> > +}
> > +
> > +static struct time_namespace *create_time_ns(void)
> > +{
> > +	struct time_namespace *time_ns;
> > +
> > +	time_ns = kmalloc(sizeof(struct time_namespace), GFP_KERNEL);
> 
> Shouldn't this use kzalloc()? There are tons of members in that struct.

I don't think so. All of other members are initialized in clone_time_ns.
Maybe we don't need this helper. When I wrote this code, I looked at
kernel/utsname.c. I will think what we can do here to make this code
more clear.

> 
> > +	if (time_ns) {
> > +		kref_init(&time_ns->kref);
> > +		time_ns->initialized = false;
> 
> And you spare this one.

This one should be initialized in clone_time_ns too.
> 
> > +	}
> > +	return time_ns;
> > +}
> > +
> > +/*
> > + * Clone a new ns copying @old_ns, setting refcount to 1
> > + * @old_ns: namespace to clone
> > + * Return the new ns or ERR_PTR.
> 
> If you use kernel-doc style then please use te proper syntax
> 
> /*
>  * clone_time_ns - Clone a time namespace
>  * @old_ns:	Namespace to clone
>  *
>  * Clone @old_ns and set the clone refcount to 1
>  *
>  * Return: The new namespace or ERR_PTR.
>  */

Will fix. Thanks!

> 
> > + */
> > +static struct time_namespace *clone_time_ns(struct user_namespace *user_ns,
> > +					  struct time_namespace *old_ns)
> > +{
> > +	struct time_namespace *ns;
> > +	struct ucounts *ucounts;
> > +	int err;
> > +
> > +	err = -ENOSPC;
> > +	ucounts = inc_time_namespaces(user_ns);
> > +	if (!ucounts)
> > +		goto fail;
> > +
> > +	err = -ENOMEM;
> > +	ns = create_time_ns();
> > +	if (!ns)
> > +		goto fail_dec;
> > +
> > +	err = ns_alloc_inum(&ns->ns);
> > +	if (err)
> > +		goto fail_free;
> > +
> > +	ns->ucounts = ucounts;
> > +	ns->ns.ops = &timens_operations;
> > +	ns->user_ns = get_user_ns(user_ns);
> > +	return ns;
> > +
> > +fail_free:
> > +	kfree(ns);
> > +fail_dec:
> > +	dec_time_namespaces(ucounts);
> > +fail:
> > +	return ERR_PTR(err);
> > +}
> > +
> > +/*
> > + * Add a reference to old_ns, or clone it if @flags specify CLONE_NEWTIME.
> > + * In latter case, changes to the time of this process won't be seen by parent,
> > + * and vice versa.
> 
> Ditto

Will fix.

> 
> > + */
> > +struct time_namespace *copy_time_ns(unsigned long flags,
> > +	struct user_namespace *user_ns, struct time_namespace *old_ns)
> > +{
> > +	if (!(flags & CLONE_NEWTIME))
> > +		return get_time_ns(old_ns);
> > +
> > +	return clone_time_ns(user_ns, old_ns);
> > +}
> > +
> > +void free_time_ns(struct kref *kref)
> > +{
> > +	struct time_namespace *ns;
> > +
> > +	ns = container_of(kref, struct time_namespace, kref);
> > +	dec_time_namespaces(ns->ucounts);
> > +	put_user_ns(ns->user_ns);
> > +	ns_free_inum(&ns->ns);
> > +	kfree(ns);
> > +}
> > +
> > +static struct time_namespace *to_time_ns(struct ns_common *ns)
> > +{
> > +	return container_of(ns, struct time_namespace, ns);
> > +}
> > +
> > +static struct ns_common *timens_get(struct task_struct *task)
> > +{
> > +	struct time_namespace *ns = NULL;
> > +	struct nsproxy *nsproxy;
> > +
> > +	task_lock(task);
> > +	nsproxy = task->nsproxy;
> > +	if (nsproxy) {
> > +		ns = nsproxy->time_ns;
> > +		get_time_ns(ns);
> > +	}
> > +	task_unlock(task);
> > +
> > +	return ns ? &ns->ns : NULL;
> > +}
> > +
> > +static struct ns_common *timens_for_children_get(struct task_struct *task)
> > +{
> > +	struct time_namespace *ns = NULL;
> > +	struct nsproxy *nsproxy;
> > +
> > +	task_lock(task);
> > +	nsproxy = task->nsproxy;
> > +	if (nsproxy) {
> > +		ns = nsproxy->time_ns_for_children;
> > +		get_time_ns(ns);
> > +	}
> > +	task_unlock(task);
> > +
> > +	return ns ? &ns->ns : NULL;
> > +}
> > +
> > +static void timens_put(struct ns_common *ns)
> > +{
> > +	put_time_ns(to_time_ns(ns));
> > +}
> > +
> > +static int timens_install(struct nsproxy *nsproxy, struct ns_common *new)
> > +{
> > +	struct time_namespace *ns = to_time_ns(new);
> > +
> > +	if (!current_is_single_threaded())
> > +		return -EUSERS;
> > +
> > +	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
> > +	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	get_time_ns(ns);
> > +	get_time_ns(ns);
> 
> Why is this a double get?

Because we change nsproxy->time_ns and nsproxy->time_ns_for_children.

Probably, I need to reorgonize the code this way:

	get_time_ns(ns);
	put_time_ns(nsproxy->time_ns);
	nsproxy->time_ns = ns;

	get_time_ns(ns);
	put_time_ns(nsproxy->time_ns_for_children);
	nsproxy->time_ns_for_children = ns;
> 
> > +	put_time_ns(nsproxy->time_ns);
> > +	put_time_ns(nsproxy->time_ns_for_children);
> > +	nsproxy->time_ns = ns;
> > +	nsproxy->time_ns_for_children = ns;
> > +	ns->initialized = true;
> > +	return 0;
> > +}
> > +
> > +int timens_on_fork(struct nsproxy *nsproxy, struct task_struct *tsk)
> > +{
> > +	struct ns_common *nsc = &nsproxy->time_ns_for_children->ns;
> > +	struct time_namespace *ns = to_time_ns(nsc);
> > +
> > +	if (nsproxy->time_ns == nsproxy->time_ns_for_children)
> > +		return 0;
> > +
> > +	get_time_ns(ns);
> > +	put_time_ns(nsproxy->time_ns);
> > +	nsproxy->time_ns = ns;
> > +	ns->initialized = true;
> 
> Isn't that one initialized already?

When we discussed time namespaces last year, we decided that clock
offsets can be set only before any task enters a namespace.

When a namespace is created, ns->initialized is set to false. When a
task enters the namespace, ns->initialized is set to true.

Namespace clock offsets can be changed only if ns->initialized is false.

A new task can be forked to a specified time namespace or it can call
setns, so we set ns->initialized to true in timens_on_fork and
timens_install.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static struct user_namespace *timens_owner(struct ns_common *ns)
> > +{
> > +	return to_time_ns(ns)->user_ns;
> > +}
> > +
> > +const struct proc_ns_operations timens_operations = {
> > +	.name		= "time",
> > +	.type		= CLONE_NEWTIME,
> > +	.get		= timens_get,
> > +	.put		= timens_put,
> > +	.install	= timens_install,
> > +	.owner		= timens_owner,
> > +};
> > +
> > +const struct proc_ns_operations timens_for_children_operations = {
> > +	.name		= "time_for_children",
> > +	.type		= CLONE_NEWTIME,
> > +	.get		= timens_for_children_get,
> > +	.put		= timens_put,
> > +	.install	= timens_install,
> > +	.owner		= timens_owner,
> > +};
> > +
> > +struct time_namespace init_time_ns = {
> > +	.kref = KREF_INIT(3),
> > +	.user_ns = &init_user_ns,
> > +	.ns.inum = PROC_TIME_INIT_INO,
> > +	.ns.ops = &timens_operations,
> > +};
> 
> Inconsisten formatting. The above static initializers are nicely
> tabular. This on not.

Will fix. Thanks.

Thanks,
Andrei
> 
> Thanks,
> 
> 	tglx
