From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Date: Wed, 9 Mar 2011 16:25:13 -0800
Message-ID: <20110309162513.5058c824.akpm@linux-foundation.org>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299681411-9227-1-git-send-email-virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken MacLeod <ken-VbOJbV3qneKf+c8Povm/Gg@public.gmane.org>, Shaun Reich <predator106-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Tokarev <mjt-XAri/EZa3C4vJsYlp49lxw@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Stultz <johnstul-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed,  9 Mar 2011 16:36:51 +0200
Alexander Shishkin <virtuoso-0lOfPCoBze7YtjvyW6yDsg@public.gmane.org> wrote:

> Changes since v3:
>  - changed timerfd_settime() semantics (see below)
> Changes since v2:
>  - replaced sysfs interface with a syscall
>  - added sysctl/procfs handle to set a limit to the number of users
>  - fixed issues pointed out by Greg.
> Changes since v1:
>  - updated against 2.6.36-rc1,
>  - added notification/filtering options,
>  - added Documentation/ABI/sysfs-kernel-time-notify interface description.
> 
> Certain userspace applications (like "clock" desktop applets or cron or
> systemd) might want to be notified when some other application changes
> the system time. There are several known to me reasons for this:
>  - avoiding periodic wakeups to poll time changes;
>  - rearming CLOCK_REALTIME timers when said changes happen;
>  - changing system timekeeping policy for system-wide time management
>    programs;
>  - keeping guest applications/operating systems running in emulators
>    up to date;
>  - recalculation of traffic signal cycles in Advanced Traffic Controllers
>    (ATC), which is part of ATC API requirements [1] as developed by ATC
>    working group of the U.S. Institute of Transportation Engineers (ITE).
> 
> The major change since the previous version is the new semantics of
> timerfd_settime() when it's called on a time change notification
> descriptor: it will set the system time to utmr.it_value if the time
> change counter is zero, otherwise it will return EBUSY, this is required
> to prevent a race between setting the time and reading the counter, when
> the time controlling procees changes the time immediately after another
> process in the system did the same (the counter is greater than one),
> that process' time change will be lost. Thus, the time controlling
> process should use timerfd_settime() instead of clock_settime() or
> settimeofday() to ensure that other processes' time changes don't get
> lost.
> 
> This is another attempt to approach notifying userspace about system
> clock changes. The other one is using an eventfd and a syscall [1]. In
> the course of discussing the necessity of a syscall for this kind of
> notifications, it was suggested that this functionality can be achieved
> via timers [2] (and timerfd in particular [3]). This idea got quite
> some support [4], [5], [6] and some vague criticism [7], so I decided
> to try and go a bit further with it.

Looks sane to me.  The changelog is a bit of a pickle - I stole a
useful-looking paragraph from your other please-ignore-this-email
email.

I also cc'ed Michael and linux-api: there isn't much point in adding
kernel features if we don't tell anyone about them.

It would be helpful to know if the identified users of this feature
actually find it useful and adequate.  I guess the most common
application is the 1,001 desktop clock widgets.  Do you have any
feedback from any of the owners of those?

Thanks.
