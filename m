From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ioctl manpages?
Date: Tue, 15 Dec 2015 12:53:26 +0100
Message-ID: <566FFF36.4060103@gmail.com>
References: <20151215083358.GE10584@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151215083358.GE10584-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Darrick,

On 12/15/2015 09:33 AM, Darrick J. Wong wrote:
> Hi,
> 
> Just out of curiosity, how does one submit manpages for specific
> ioctls?  There's a manpage for ioctl() itself, but I can't find
> anything for things like, say, FIEMAP or FICLONE or FICLONERANGE.
> I guess they'd be section 2, right?

Yes. (And it sure would be nice to see some of those documented.
Is this an offer? :-) )

> Something like /usr/share/man/man2/ficlone.2.gz?  Or a separate
> ioctl-ficlone.2.gz, just in case there's ever a ficlone syscall?

We already have ioctl_fat.2 and ioctl_list.2, so I'd say 
ioctl_ficlone.2 and so on.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
