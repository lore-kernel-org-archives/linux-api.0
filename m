From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Thu, 2 Feb 2017 13:32:19 -0800
Message-ID: <CALCETrW6Mqj9VLogd0XaLgVAzEqsZ+VnZjN5NROCqr0ssdYaKg@mail.gmail.com>
References: <20170202200632.13992-1-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170202200632.13992-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 2, 2017 at 12:06 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> This patchset implements cgroup v2 thread mode.  It is largely based
> on the discussions that we had at the plumbers last year.  Here's the
> rough outline.

I like this, but I have some design questions:

>
> * Thread mode is explicitly enabled on a cgroup by writing "enable"
>   into "cgroup.threads" file.  The cgroup shouldn't have any child
>   cgroups or enabled controllers.

Why do you need to manually turn it on?  That is, couldn't it be
automatic based on what controllers are enabled?

>
> * Once enabled, arbitrary sub-hierarchy can be created and threads can
>   be put anywhere in the subtree by writing TIDs into "cgroup.threads"
>   file.  Process granularity and no-internal-process constraint don't
>   apply in a threaded subtree.

I'm a bit worried that this conflates two different things.  There's
thread support, i.e. allowing individual threads to be placed into
cgroups.  There's also more flexible sub-hierarchy support, i.e.
relaxing no-internal-process constraints.  For the "cpuacct"
controller, for example, both of these make sense.  But what if
someone writes a controller (directio, for example, just to make
something up) for which thread granularity makes sense but relaxing
no-internal-process constraints does not?

--Andy
