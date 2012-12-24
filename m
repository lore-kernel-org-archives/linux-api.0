From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/4] signalfd: a kernel interface for dumping/restoring
 pending signals
Date: Mon, 24 Dec 2012 21:51:10 +0100
Message-ID: <CAHO5Pa0B9KsU-kr=M78kRG5WqOf-ere6YmZ0GPUv4WLF6at_RQ@mail.gmail.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356336807-5517-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC+=3Dlinux-api]

Hi Andrey,

On Mon, Dec 24, 2012 at 9:13 AM, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote=
:
> The idea is simple. We need to get the siginfo for each signal on dum=
p,
> and then return it back on restore.
>
> The first problem is that the kernel doesn=92t report complete siginf=
o-s
> in user-space. In a signal handler the kernel strips SI_CODE from
> siginfo. When a siginfo is received from signalfd, it has a different
> format with fixed sizes of fields. The interface of signalfd was
> extended. If a signalfd is created with the flag SFD_RAW, it returns
> siginfo in a raw format. We need to choose a queue, so two flags
> SFD_GROUP and SFD_PRIVATE were added.
>
> rt_sigqueueinfo looks suitable for restoring signals, but it can=92t =
send
> siginfo with a positive si_code, because these codes are reserved for
> the kernel. In the real world each person has right to do anything wi=
th
> himself, so I think a process should able to send any siginfo to itse=
lf.

I see that you CCed me on a couple of the patches in this series.
Thanks for that. But, since most of the series concerns API changes,
it would be good also to CC linux-api on (future revisions of) the
entire series.

I have a few largely cosmetic comments on some of the patches, which
I'll add in the respective threads.

Thanks,

Michael


> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
