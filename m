From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 5/5] cgroup: introduce cgroup namespaces
Date: Fri, 18 Jul 2014 09:51:33 -0700
Message-ID: <CALCETrW6YpyJBmr3sZC6KL03GP4dcGYavQF5DFZfys6Cok-vpw@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-6-git-send-email-adityakali@google.com> <CALCETrWXMMGzptvEu6TfzTjBou4t==W39_nNB5FJwSk2Zy8uCQ@mail.gmail.com>
 <CAGr1F2Ht1q_nYGJwmQvEEyj8r3R1stgD=g3s8_5zYOTogjz-UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGr1F2Ht1q_nYGJwmQvEEyj8r3R1stgD=g3s8_5zYOTogjz-UQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Jul 17, 2014 1:56 PM, "Aditya Kali" <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Thu, Jul 17, 2014 at 12:57 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> > On Thu, Jul 17, 2014 at 12:52 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >> Introduce the ability to create new cgroup namespace. The newly created
> >> cgroup namespace remembers the 'struct cgroup *root_cgrp' at the point
> >> of creation of the cgroup namespace. The task that creates the new
> >> cgroup namespace and all its future children will now be restricted only
> >> to the cgroup hierarchy under this root_cgrp. In the first version,
> >> setns() is not supported for cgroup namespaces.
> >> The main purpose of cgroup namespace is to virtualize the contents
> >> of /proc/self/cgroup file. Processes inside a cgroup namespace
> >> are only able to see paths relative to their namespace root.
> >> This allows container-tools (like libcontainer, lxc, lmctfy, etc.)
> >> to create completely virtualized containers without leaking system
> >> level cgroup hierarchy to the task.
> >
> > What happens if someone moves a task in a cgroup namespace outside of
> > the namespace root cgroup?
> >
>
> Attempt to move a task outside of cgroupns root will fail with EPERM.
> This is true irrespective of the privileges of the process attempting
> this. Once cgroupns is created, the task will be confined to the
> cgroup hierarchy under its cgroupns root until it dies.

Can a task in a non-init userns create a cgroupns?  If not, that's
unusual.  If so, is it problematic if they can prevent themselves from
being moved?

I hate to say it, but it might be worth requiring explicit permission
from the cgroup manager for this.  For example, there could be a new
cgroup attribute may_unshare, and any attempt to unshare the cgroup ns
will fail with -EPERM unless the caller is in a may_share=1 cgroup.
may_unshare in a parent cgroup would not give child cgroups the
ability to unshare.

--Andy
