From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 2.4] CAP_FS_MASK: add CAP_LINUX_IMMUTABLE and CAP_MKNOD
Date: Thu, 26 Mar 2009 06:29:58 +0100
Message-ID: <20090326052958.GC13146@1wt.eu>
References: <20090325173954.GA19299@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090325173954.GA19299-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Stephen Smalley <sds-FVV4AS6k8l2W8mdqIt43Ew@public.gmane.org>, Andrew Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Igor Zhbanov <izh1979-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Wright <chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Mar 25, 2009 at 12:39:54PM -0500, Serge E. Hallyn wrote:
> When POSIX capabilities were introduced during the 2.1 Linux
> cycle, the fs mask, which represents the capabilities which having
> fsuid==0 is supposed to grant, did not include CAP_MKNOD and
> CAP_LINUX_IMMUTABLE.  However, before capabilities the privilege
> to call these did in fact depend upon fsuid==0.
> 
> This patch introduces those capabilities into the fsmask,
> restoring the old behavior.
> 
> See the thread starting at http://lkml.org/lkml/2009/3/11/157 for
> reference.

Thanks to Igor and you for fixing this. The impact did not appear
obvious to me at first, to be honnest! I'm queuing the patch for
next release.

BTW, I've noticed your other patch for 2.2.26, but it's not worth
wasting time on it, as 2.2 has remained unmaintained for years now
and people are really discouraged from using it as many holes have
never been fixed there.

Cheers,
Willy

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
