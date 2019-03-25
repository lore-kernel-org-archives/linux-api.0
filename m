From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 20:59:30 +0100
Message-ID: <20190325195929.4ptq3lnm6bkvtvxx@brauner.io>
References: <20190325162052.28987-1-christian@brauner.io>
 <20190325162052.28987-3-christian@brauner.io>
 <071b12db-f84e-8666-d70a-1b6cce71f9c0@nextfour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <071b12db-f84e-8666-d70a-1b6cce71f9c0@nextfour.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mika.penttila@nextfour.com>
Cc: "jannh@google.com" <jannh@google.com>, "khlebnikov@yandex-team.ru" <khlebnikov@yandex-team.ru>, "luto@kernel.org" <luto@kernel.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "serge@hallyn.com" <serge@hallyn.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "keescook@chromium.org" <keescook@chromium.org>, "adobriyan@gmail.com" <adobriyan@gmail.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, "bl0pbl33p@gmail.com" <bl0pbl33p@gmail.com>, "ldv@altlinux.org" <ldv@altlinux.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>"oleg@redhat.com" <o>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 05:20:54PM +0000, Mika Penttilä wrote:
> Hi!
> 
> 
> > +SYSCALL_DEFINE5(pidctl, unsigned int, cmd, pid_t, pid, int, source, int, target,
> > +		unsigned int, flags)
> > +{
> > +	struct pid_namespace *source_ns = NULL, *target_ns = NULL;
> > +	struct pid *struct_pid;
> > +	pid_t result;
> > +
> > +	switch (cmd) {
> > +	case PIDCMD_QUERY_PIDNS:
> > +		if (pid != 0)
> > +			return -EINVAL;
> > +		pid = 1;
> > +		/* fall through */
> > +	case PIDCMD_QUERY_PID:
> > +		if (flags != 0)
> > +			return -EINVAL;
> > +		break;
> > +	case PIDCMD_GET_PIDFD:
> > +		if (flags & ~PIDCTL_CLOEXEC)
> > +			return -EINVAL;
> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	source_ns = get_pid_ns_by_fd(source);
> > +	result = PTR_ERR(source_ns);
> > +	if (IS_ERR(source_ns))
> > +		goto err_source;
> > +
> > +	target_ns = get_pid_ns_by_fd(target);
> > +	result = PTR_ERR(target_ns);
> > +	if (IS_ERR(target_ns))
> > +		goto err_target;
> > +
> > +	if (cmd == PIDCMD_QUERY_PIDNS) {
> > +		result = pidns_related(source_ns, target_ns);
> > +	} else {
> > +		rcu_read_lock();
> > +		struct_pid = find_pid_ns(pid, source_ns);
> > +		result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
> 
> Should you do get_pid(struct_pid) here to keep it alive till 
> pidfd_create_fd() ?

Yes, indeed. You and Jann both pointed this out! Thank you.

> 
> > +		rcu_read_unlock();
> > +
> > +		if (cmd == PIDCMD_GET_PIDFD) {
> > +			int cloexec = (flags & PIDCTL_CLOEXEC) ? O_CLOEXEC : 0;
> > +			if (result > 0)
> > +				result = pidfd_create_fd(struct_pid, cloexec);
> > +			else if (result == 0)
> > +				result = -ENOENT;
> > +		}
> > +	}
> > +
> > +	if (target)
> > +		put_pid_ns(target_ns);
> > +err_target:
> > +	if (source)
> > +		put_pid_ns(source_ns);
> > +err_source:
> > +	return result;
> > +}
> > +
> >  void __init pid_idr_init(void)
> >  {
> >  	/* Verify no one has done anything silly: */
> > diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> > index aa6e72fb7c08..1c863fb3d55a 100644
> > --- a/kernel/pid_namespace.c
> > +++ b/kernel/pid_namespace.c
> > @@ -429,6 +429,31 @@ static struct ns_common *pidns_get_parent(struct ns_common *ns)
> >  	return &get_pid_ns(pid_ns)->ns;
> >  }
> >  
> > +/**
> > + * pidnscmp - Determine if @ancestor is ancestor of @descendant
> > + * @ancestor:   pidns suspected to be the ancestor of @descendant
> > + * @descendant: pidns suspected to be the descendant of @ancestor
> > + *
> > + * Returns -1 if @ancestor is not an ancestor of @descendant,
> > + * 0 if @ancestor is the same pidns as @descendant, 1 if @ancestor
> > + * is an ancestor of @descendant.
> > + */
> > +int pidnscmp(struct pid_namespace *ancestor, struct pid_namespace *descendant)
> > +{
> > +	if (ancestor == descendant)
> > +		return 0;
> > +
> > +	for (;;) {
> > +		if (!descendant)
> > +			return -1;
> > +		if (descendant == ancestor)
> > +			break;
> > +		descendant = descendant->parent;
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> >  static struct user_namespace *pidns_owner(struct ns_common *ns)
> >  {
> >  	return to_pid_ns(ns)->user_ns;
