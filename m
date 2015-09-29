From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/1] ns: introduce proc_get_ns_by_fd()
Date: Tue, 29 Sep 2015 18:43:15 +0200
Message-ID: <20150929164315.GA16734@redhat.com>
References: <20150925135246.27620.97496.stgit@buzz> <20150925175654.GA12504@redhat.com> <871tdi8pqj.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <871tdi8pqj.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/28, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>
> > Honestly, I do not really like the new helper... I understand this
> > is subjective, so I won't insist. But how about 1/1? We do not need
> > fd/file at all. With this patch your sys_getvpid() can just use
> > proc_get_ns_by_fd(fd, CLONE_NEWPID) and put_pid_ns().
> >
> > Eric, what do you think?
>
> At some level I don't care this is not exposed to userspace.

I agree, this is minor. But you know, the kernel is already complicated
too much, we should try to simplify/cleanup everything we can ;)

> Of the existing uses several of them sleep, which unfortunately means we
> can not use rcu locking for everything.  The network namespace ones wind
> up taking a reference to struct net because the have the legacy pid case
> to deal with. Which makes we can not use fdget for all callers either.

And that is why 1/1 adds proc_get_ns_by_fd/get_type which can also be used
by the network namespace.

> For this translate_pid rcu locking is sufficient, rcu locking is easy
> and doing any more than rcu locking just seems silly.  So let me
> respectfully suggest.
>
> struct ns_common *ns_by_fd_rcu(int fd, int type)
> {
> 	struct files_struct *files = current->files;
> 	struct file *file;
> 	struct ns_common *ns;
> 	void *ret;
>
> 	file = fcheck_files(files, fd);
>         if (!file)
> 		return ERR_PTR(-EBADF);
>
> 	if (file->f_mode & FMODE_PATH)
> 		return ERR_PTR(-EINVAL);
>
> 	if (file->f_op != &ns_file_operations)
>         	return ERR_PTR(-EINVAL);
>
> 	ns = get_proc_ns(file_inode(file));
> 	if (ns->ops->type != type)
> 		return ERR_PTR(-EINVAL);
>
> 	return ns;
> }

OK, I won't insist, this too looks better to me than proc_ns_fdget(&fd_ref).

And in any case fcheck_files() makes more sense than fdget(), somehow I did
not think about this when I sent 1/1.

Hmm. and after the quick look at cleanup_net() I can't understand whether
get_net_ns_by_fd() can use ns_by_fd_rcu() + maybe_get_net(to_net_ns()) or
not... Can it?

Oleg.
