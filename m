From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Mon, 23 Jan 2017 12:46:05 +0100
Message-ID: <CAEiveUe87HZK45Vs1VsTKcPMpLAav53JZb9_5-3Bc--FCGDf3A@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
 <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
 <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
 <CALCETrUp9CBWykRUQoJOXeLg9u45H+2VWyQ_BKAhwc9OpBYn+g@mail.gmail.com>
 <CAEiveUdOdMr=gJZsi=Fx-CNeC8jkyi8XxC+qSG-LXWj3o2t=_A@mail.gmail.com> <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX_K7XdyCRo1RSLySRu-2uySaR2+3J7qcw4O+JOepTwag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 21, 2017 at 1:53 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jan 20, 2017 at 8:33 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> On Thu, Jan 19, 2017 at 8:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Thu, Jan 19, 2017 at 5:53 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> [...]
>>>> Sure, the hidepid mount option is old enough, and this per-task
>>>> hidepid is clearly defined only for procfs and per task, we can't add
>>>> another switch that's relate to both a filesystem and pid namespaces,
>>>> it will be a bit complicated and not really useful for cases that are
>>>> in *same* pidns where *each* one have to mount its procfs, it will
>>>> propagate. Also as noted by Lafcadio, the gid thing is a bit hard to
>>>> use now.
>>>
>>> What I'm trying to say is that I want to understand a complete,
>>> real-world use case.  Adding a security-related per-task flag is can
>>> be quite messy and requires a lot of careful thought to get right, and
>>> I'd rather avoid it if at all possible.
>>
>> I do agree, but that's not what we are proposing here. This use case
>> is limited we do not manipulate the creds of the task, there are no
>> security transitions. The task does not change, its only related to
>> procfs and pid entries there. Also the flag applies only to current
>> task and not on remote ones... Nothing new here it's an extension of
>> procfs hidepid.
>>
>>> I'm imaging something like a new RestrictPidVisisbility= option in
>>> systemd.  I agree that this is currently a mess to do.  But maybe a
>>
>> Yes that's one use case, If we manage to land this I'll follow up with
>> it... plus there is, I've a use case related to kubernetes where I do
>> want to reduce the number of processes inside containers per pod to
>> minimal. Some other cases are: lock down children where being
>> unprivileged. Also as noted in other replies on today's desktop
>> systems, under a normal user session, the user should see all
>> processes of the system where the media player, browser etc have no
>> business to see the process tree. This can be easily implemented when
>> launching apps without the need to regain privileges...
>>
>>> simpler solution would be to add a new mount option local_hidepid to
>>> procfs.  If you set that option, then it overrides hidepid for that
>>> instance.  Most of these semi-sandboxed daemon processes already have
>>> their own mount namespace, so the overhead should be minimal.
>>
>> Andy If that could work :-/    we have to re-write or adapt lot of
>> things inside procfs... plus:
>> Procfs is a miror to the current pid namespace. Mount options are not
>> procfs but rather pid namespace. That would not work.
>
> I agree that the kernel change to do it per task is very simple.  But
> this is an unfortunate slippery slope.  What if you want to block off
> everything in /proc that isn't associated with a PID?  What if you
> want to suppress /sys access?  What if you want ot block *all*
> non-current PIDs from being revealed in /proc?  What if you want to
> hide /proc/PID/cmdline?

For /sys we mount an inaccessible directory on top, we even do that
for some static /sys and /proc inodes, of course that doesn't scale
but we try... please see below.

For non-current PIDs from being revealed in /proc, actually the use
case did not come, it will be complex to handle TOCTOU, other races
etc. We don't want that and we don't have a use case for it. The patch
here is a clear parent -> child relation.

> I think that the right solution here is to fix procfs to understand
> per-superblock mount options.

Unfortunately and as also noted by Lafcadio and you this is too
complex. Also from what you have said above and from what /proc
reports to userspace and today's use cases with containers, namespaces
etc. maybe the kernel needs a new way to report *some* kernel objects
and other things to userspace which are not based on /proc... or move
them out of /proc... in some cases the kernel may need to know if the
calling process is in a namespace...
but lets please stay focused here, fixing procfs is a bit out of the
scope for this *specific* use case and patch, we don't have the
resources to explore something new...
The aim here is a simple fix of 2bits that preserves the semantics of
procfs and hidepid, at same time makes the hidepid option local to
current process. It does not require or mess up with privileges,
namespaces etc. Easy to review and maintain.

Also as said in other emails we have clear use cases: some
cloud/container providers tax users for extra processes and resources
that they do not really need, we have mini jails for desktop systems
too... all this can be improved.

Thanks!

> --Andy



-- 
tixxdz
http://opendz.org
