From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v2] pidns: introduce syscall getvpid
Date: Thu, 24 Sep 2015 19:34:30 +0200
Message-ID: <20150924173430.GA31073@redhat.com>
References: <20150924135332.27813.21640.stgit@buzz> <20150924145647.GA24151@redhat.com> <CALYGNiPCVFNLi=1iL1gOf411iU6tT+DbVx1JuGG+f73Rpvx3dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALYGNiPCVFNLi=1iL1gOf411iU6tT+DbVx1JuGG+f73Rpvx3dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/24, Konstantin Khlebnikov wrote:
>
> On Thu, Sep 24, 2015 at 5:56 PM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On 09/24, Konstantin Khlebnikov wrote:
> >>
> >> +SYSCALL_DEFINE3(getvpid, pid_t, pid, int, source, int, target)
> >> +{
> >> +     struct file *source_file = NULL, *target_file = NULL;
> >> +     struct pid_namespace *source_ns, *target_ns;
> >> +     struct pid *struct_pid;
> >> +     struct ns_common *ns;
> >> +     pid_t result;
> >> +
> >> +     if (source >= 0) {
> >> +             source_file = proc_ns_fget(source);
> >> +             result = PTR_ERR(source_file);
> >> +             if (IS_ERR(source_file))
> >> +                     goto out;
> >> +             ns = get_proc_ns(file_inode(source_file));
> >> +             result = -EINVAL;
> >> +             if (ns->ops->type != CLONE_NEWPID)
> >> +                     goto out;
> >> +             source_ns = container_of(ns, struct pid_namespace, ns);
> >> +     } else
> >> +             source_ns = task_active_pid_ns(current);
> >> +
> >> +     if (target >= 0) {
> >> +             target_file = proc_ns_fget(target);
> >> +             result = PTR_ERR(target_file);
> >> +             if (IS_ERR(target_file))
> >> +                     goto out;
> >> +             ns = get_proc_ns(file_inode(target_file));
> >> +             result = -EINVAL;
> >> +             if (ns->ops->type != CLONE_NEWPID)
> >> +                     goto out;
> >> +             target_ns = container_of(ns, struct pid_namespace, ns);
> >> +     } else
> >> +             target_ns = task_active_pid_ns(current);
> >> +
> >
> > Hmm. Eric, Konstantin, how about (uncompiled/untested) patch below
> > in a preparation? The code above doesn't look very readable.
>
> I've tried to do something like that but that comes too far so send patch as is.

OK, I won't insist.

The code above asks for cleanup/factorization, but we can do this
later.

> Actually we can go deeper and replace struct file* with struct fd: this saves
> couple atomic ops for singlethreaded task.

it's not about performance...

But yes, we can do more and create get_pid_ns_by_fd() similar to
get_net_ns_by_fd(). We do not need file at all, we need pid_ns.

Oleg.
