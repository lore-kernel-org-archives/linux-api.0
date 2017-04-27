From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Thu, 27 Apr 2017 18:22:54 +0200
Message-ID: <20170427162254.GB19579@redhat.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
 <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
 <20170426155352.GA12131@redhat.com>
 <785e1986-da03-72aa-06c0-234ed2dbc0fd@virtuozzo.com>
 <20170427161255.GA19350@redhat.com>
 <fdd61d9c-6f88-1669-4d12-31748395fe99@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fdd61d9c-6f88-1669-4d12-31748395fe99-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/27, Kirill Tkhai wrote:
>
> On 27.04.2017 19:12, Oleg Nesterov wrote:
> > On 04/26, Kirill Tkhai wrote:
> >>
> >> On 26.04.2017 18:53, Oleg Nesterov wrote:
> >>>
> >>>> +static long set_last_pid_vec(struct pid_namespace *pid_ns,
> >>>> +			     struct pidns_ioc_req *req)
> >>>> +{
> >>>> +	char *str, *p;
> >>>> +	int ret = 0;
> >>>> +	pid_t pid;
> >>>> +
> >>>> +	read_lock(&tasklist_lock);
> >>>> +	if (!pid_ns->child_reaper)
> >>>> +		ret = -EINVAL;
> >>>> +	read_unlock(&tasklist_lock);
> >>>> +	if (ret)
> >>>> +		return ret;
> >>>
> >>> why do you need to check ->child_reaper under tasklist_lock? this looks pointless.
> >>>
> >>> In fact I do not understand how it is possible to hit pid_ns->child_reaper == NULL,
> >>> there must be at least one task in this namespace, otherwise you can't open a file
> >>> which has f_op == ns_file_operations, no?
> >>
> >> Sure, it's impossible to pick a pid_ns, if there is no the pid_ns's tasks. I added
> >> it under impression of
> >> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=dfda351c729733a401981e8738ce497eaffcaa00
> >> but here it's completely wrong. It will be removed in v2.
> > 
> > Hmm. But if I read this commit correctly then we really need to check
> > pid_ns->child_reaper != NULL ?
> > 
> > Currently we can't pick an "empty" pid_ns. But after the commit above a task
> > can do sys_unshare(CLONE_NEWPID), another (or the same) task can open its
> > /proc/$pid/ns/pid_for_children and call ns_ioctl() before the 1st alloc_pid() ?
> 
> Another task can't open /proc/$pid/ns/pid_for_children before the 1st alloc_pid(),
> because pid_for_children is available to open only after the 1st alloc_pid().
> So, it's impossible to call ioctl() on it.

Ah, OK, I didn't notice the ns->child_reaper check in pidns_for_children_get().

But note that it doesn't need tasklist_lock too.

Oleg.
