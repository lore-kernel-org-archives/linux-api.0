From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Implement fchmodat4 system call
Date: Tue, 12 May 2015 10:48:52 +0200
Message-ID: <CAHO5Pa1-5X1yC5qkNPKe19zj-JOWMdr_oHmtbyK20+pMjznzAw@mail.gmail.com>
References: <1431310042-52247-1-git-send-email-will@worrbase.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431310042-52247-1-git-send-email-will-o9VNkMWGZsBWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: William Orr <will-o9VNkMWGZsBWk0Htik3J/w@public.gmane.org>
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Ayer <agwa-vM4+sZUQx5cvLxMWut27OA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

Hello William,

Since this is a kernel-user-space API change, please CC linux-api@.
The kernel source file Documentation/SubmitChecklist notes that all
Linux kernel patches that change userspace interfaces should be CCed
to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Aside from that, I've added a few other people/lists to CC that seem
likely to be relevant. Some additional comments below.

On Mon, May 11, 2015 at 4:07 AM, William Orr <will-o9VNkMWGZsBWk0Htik3J/w@public.gmane.org> wrote:
> Hey,
>
> Currently, Linux's fchmodat(2) doesn't honor the flags argument. To bring it
> more in-line with POSIX and other implementations, this patch adds fchmodat4,
> which honors the flags argument, and implements the same flags as fchownat(2).
>
> This makes it possible to chmod a file without following symlinks, without
> having to call open(2) on a file with O_NOFOLLOW. This is heavily based off
> of Andrew Ayer's work in 2012, and is sent with his permission. Let me know
> if this can be applied.
>
> Please CC me, since I'm not subscribed to this list.

This seems an obviously sensible addition, and it was an obvious
mistake not to have a 'flags' argument in the original system call
(https://lwn.net/Articles/585415/). As well as getting us a proper
POSIX compliant API (and one that is consistent with other
implementations, such as FreeBSD), it allows for future behavior
expansion via the 'flags' argument.

Cheers,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
