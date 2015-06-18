From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: UAPI headers including non-UAPI headers by accident?
Date: Thu, 18 Jun 2015 09:58:52 +0200
Message-ID: <9141492.JqTlmk9dHk@wuerfel>
References: <CALCETrVaWJVDFydhXv320iCuFhTMi9txx+MpzsA_Q7yeZxMDSQ@mail.gmail.com> <CAKgNAkjLmBUayYjVOr6Stcbmcn=ENb3Uyt0dkFQCmn-Lxdn0xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkjLmBUayYjVOr6Stcbmcn=ENb3Uyt0dkFQCmn-Lxdn0xw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 18 June 2015 09:52:36 Michael Kerrisk wrote:
> [CC += David]
> 
> On 2 June 2015 at 18:36, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > include/uapi/linux/signal.h starts with:
> >
> > #ifndef _UAPI_LINUX_SIGNAL_H
> > #define _UAPI_LINUX_SIGNAL_H
> >
> > #include <asm/signal.h>
> > #include <asm/siginfo.h>
> >
> > This causes it to include <asm/signal.h>, which is not the same thing
> > as <uapi/asm/signal.h>.  Changing that will break userspace use of
> > this header, though, as the uapi/ won't get removed.
> >
> > What's the correct fix?  This is causing trouble with a UML build for me.
> 
> Perhaps David has some insight, since he architected the original UAPI split.

The uapi headers are installed without the uapi prefix. This means
that inside of the kernel, we get


 linux/signal.h
 -> uapi/linux/signal.h
    -> asm/signal.h
       -> uapi/asm/signal.h

while in the installed headers we just get

    linux/signal.h
       -> asm/signal.h

This all looks right to me: user space only sees the exported portions
under the traditional names, while the kernel sees both the kernel-side
and user-side definitions from the same path.

	Arnd
