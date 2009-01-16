From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Sat, 17 Jan 2009 05:53:28 +1300
Message-ID: <cfd18e0f0901160853v4cf76602g4ab389dc30a5a225@mail.gmail.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1232124344-25892-1-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Gerd,

On Sat, Jan 17, 2009 at 5:45 AM, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>  Hi folks,
>
> Next round of the preadv & pwritev patch series.

Have you somewhere along the way posted some userland example/test
programs for these syscalls?  If not, could you provide some?

Cheers,

Michael

> Had no review comments
> to fix.  That means it is ready to be merged, right?
>
> Changes:
>  - compat_sys_{read,write}v bugfix patch dropped (merged).
>  - rebase to latest git, adapt to CVE-2009-0029 changes.
>
> How to proceed now?  Is there a syscall maintainer where I could queue
> up the patches?  If not, anyone (akpm?) willng to pick this up?  Should
> I try to send to Linus directly?
>
> What is the usual way to handle the arch-specific syscall windup?  I'd
> prefer to leave that to the arch maintainers as they know best what
> needs to be done, is that ok?  Right now only x86 (/me) and mips (patch
> from Ralf Baechle) is covered ...
>
> cheers,
>  Gerd
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
