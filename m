From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 20 Jan 2017 16:53:08 -0800
Message-ID: <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
 <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com> <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lafcadio Wluiki <wluikil-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 20, 2017 at 8:33 AM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Jan 19, 2017 at 8:52 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Thu, Jan 19, 2017 at 5:53 AM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> [...]
>>> Sure, the hidepid mount option is old enough, and this per-task
>>> hidepid is clearly defined only for procfs and per task, we can't add
>>> another switch that's relate to both a filesystem and pid namespaces,
>>> it will be a bit complicated and not really useful for cases that are
>>> in *same* pidns where *each* one have to mount its procfs, it will
>>> propagate. Also as noted by Lafcadio, the gid thing is a bit hard to
>>> use now.
>>
>> What I'm trying to say is that I want to understand a complete,
>> real-world use case.  Adding a security-related per-task flag is can
>> be quite messy and requires a lot of careful thought to get right, and
>> I'd rather avoid it if at all possible.
>
> I do agree, but that's not what we are proposing here. This use case
> is limited we do not manipulate the creds of the task, there are no
> security transitions. The task does not change, its only related to
> procfs and pid entries there. Also the flag applies only to current
> task and not on remote ones... Nothing new here it's an extension of
> procfs hidepid.
>
>> I'm imaging something like a new RestrictPidVisisbility= option in
>> systemd.  I agree that this is currently a mess to do.  But maybe a
>
> Yes that's one use case, If we manage to land this I'll follow up with
> it... plus there is, I've a use case related to kubernetes where I do
> want to reduce the number of processes inside containers per pod to
> minimal. Some other cases are: lock down children where being
> unprivileged. Also as noted in other replies on today's desktop
> systems, under a normal user session, the user should see all
> processes of the system where the media player, browser etc have no
> business to see the process tree. This can be easily implemented when
> launching apps without the need to regain privileges...
>
>> simpler solution would be to add a new mount option local_hidepid to
>> procfs.  If you set that option, then it overrides hidepid for that
>> instance.  Most of these semi-sandboxed daemon processes already have
>> their own mount namespace, so the overhead should be minimal.
>
> Andy If that could work :-/    we have to re-write or adapt lot of
> things inside procfs... plus:
> Procfs is a miror to the current pid namespace. Mount options are not
> procfs but rather pid namespace. That would not work.

I agree that the kernel change to do it per task is very simple.  But
this is an unfortunate slippery slope.  What if you want to block off
everything in /proc that isn't associated with a PID?  What if you
want to suppress /sys access?  What if you want ot block *all*
non-current PIDs from being revealed in /proc?  What if you want to
hide /proc/PID/cmdline?

I think that the right solution here is to fix procfs to understand
per-superblock mount options.

--Andy
