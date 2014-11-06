From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init cgroupns
Date: Thu, 6 Nov 2014 09:28:25 -0800
Message-ID: <CAGr1F2Es3nkWePqRpKoAFoRB5SZp=BvQh7espyxjaRy_fYAbCw@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com> <CALCETrXTaZ3SJ_t-gnbc93BVZXg-912NqO78kFd0Tpi-5-dZoQ@mail.gmail.com>
 <CAGr1F2FuPQxLraYv7PstJ9c8H-XQsgawaAtj4AS77B+_0k2o+A@mail.gmail.com> <20141104135726.GB14014@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141104135726.GB14014-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 4, 2014 at 5:57 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Aditya.
>
> On Mon, Nov 03, 2014 at 03:12:28PM -0800, Aditya Kali wrote:
>> I think the sane-behavior flag is only temporary and will be removed
>> anyways, right? So I didn't bother asking user to supply it. But I can
>> make the change as you suggested. We just have to make sure that tasks
>> inside cgroupns cannot mount non-default hierarchies as it would be a
>> regression.
>
> I'm not sure whether supporting mounting from inside a ns is even
> necessary but, if it is, can't you just test against cgrp_dfl_root?
> There's no reason to do anything differnetly for ns mounting.
>

I am not sure I fully understand what you mean. But we don't have a
way to test against cgrp_dfl_root while parsing mount-options. They
only way we know that user is trying to mount a default hierarchy is
via the sane_behavior flag. So I need to test against this flag it if
we want to restrict processes inside cgroupns to mounting the default
hierarchy only.
Or are you suggesting that its OK for nsown_capable(CAP_SYS_ADMIN)
processes to mount any cgroup hierarchy (irrespective of their
cgroupns)? I assumed that this will be a undesirable.

> Thanks.
>
> --
> tejun


Thanks,
-- 
Aditya
