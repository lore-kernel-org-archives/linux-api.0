From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall V2
Date: Wed, 1 Oct 2008 16:57:58 +0200
Message-ID: <cfd18e0f0810010757j7a9f6deaj47a06f30e371af1e@mail.gmail.com>
References: <20081001095204.343984413@linutronix.de>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081001095204.343984413-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[CC+=linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

On Wed, Oct 1, 2008 at 12:01 PM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> Changes vs. V1: compat_sys_rt_sigqueueinfo implemented. Thanks Roland !
>
> sys_kill has a counterpart sys_tgkill which allows to send signals to
> a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
>
> Aside of the asymetry it is a show stopper for migrating applications
> from other unix-alike RTOSes.
>
> The following patch series implements rt_tgsigqueueinfo and hooks it
> up for x86.

This is an excellent candidate for CCing to the new linux-api@vger
(http://thread.gmane.org/gmane.linux.ltp/5658/), since it is an API
change.

> Find below the raw documentation.

Thanks -- I'll work that up into a man page when this gets closer to release.

Cheers,

Michael

> ----
>
> NAME
>       rt_tgsigqueueinfo - Send signal information to a signal to a thread
>
> SYNOPSIS
>       long sys_rt_tgsigqueueinfo (int tgid, int tid, int sig, siginfo_t *uinfo);
>
> DESCRIPTION
>
>       rt_tgsigqueueinfo sends signal sig information uinfo to the
>       thread with the thread ID tid in the thread group tgid.  (By
>       contrast, rt_sigqueueinfo(2) can only be used to send a signal
>       info to a process (i.e., thread group) as a whole, and the
>       signal will be delivered to an arbitrary thread within that
>       process.)
>
> RETURN VALUE
>
>       rt_tgsigqueueinfo returns 0 on success; otherwise,
>       rt_sigqueueinfo returns one of the errors listed in the
>       "Errors" section.
>
> ERRORS
>       -EFAULT
>              An invalid value for uinfo was specified.
>
>       -EINVAL
>              An invalid TID, TGID or signal was specified.
>
>       -EPERM
>              Permission denied.  For the required permissions,
>              see rt_sigqueueinfo(2).
>
>       -ESRCH
>              No process with the specified thread ID and thread group
>              ID exists.
>
>
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
