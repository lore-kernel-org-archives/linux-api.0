From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] [retry] vt: add ioctl commands to /dev/vcsaN to get/put
 the current palette of the given tty
Date: Wed, 4 Mar 2009 14:16:35 -0800
Message-ID: <20090304141635.fa756831.akpm@linux-foundation.org>
References: <427911.793301236157128303.JavaMail.root@spooler2-g27.priv.proxad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <427911.793301236157128303.JavaMail.root-u0VDug3vKOpsFmKuirFwRhh1pbbyJDp15NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cedric Roux <sed-GANU6spQydw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 4 Mar 2009 09:58:48 +0100 (CET)
Cedric Roux <sed-GANU6spQydw@public.gmane.org> wrote:

> From: Cedric Roux <sed-GANU6spQydw@public.gmane.org>
> 
> A ioctl interface and two ioctl commands added to /dev/vcsaN
> to get/put the current palette of the given tty.
> 
> ...
>
> - lock_kernel() is called. Maybe it's not necessary? I'm not
>   confident enough. You decide.

I wouldn't have a clue what it's protecting in there.  But it seems
sane to put it in - once someone gets down and de-lock_kernel()s that
code, they can work out what it should be replaced by.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
