From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: UAPI headers including non-UAPI headers by accident?
Date: Thu, 18 Jun 2015 09:52:36 +0200
Message-ID: <CAKgNAkjLmBUayYjVOr6Stcbmcn=ENb3Uyt0dkFQCmn-Lxdn0xw@mail.gmail.com>
References: <CALCETrVaWJVDFydhXv320iCuFhTMi9txx+MpzsA_Q7yeZxMDSQ@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVaWJVDFydhXv320iCuFhTMi9txx+MpzsA_Q7yeZxMDSQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC += David]

On 2 June 2015 at 18:36, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> include/uapi/linux/signal.h starts with:
>
> #ifndef _UAPI_LINUX_SIGNAL_H
> #define _UAPI_LINUX_SIGNAL_H
>
> #include <asm/signal.h>
> #include <asm/siginfo.h>
>
> This causes it to include <asm/signal.h>, which is not the same thing
> as <uapi/asm/signal.h>.  Changing that will break userspace use of
> this header, though, as the uapi/ won't get removed.
>
> What's the correct fix?  This is causing trouble with a UML build for me.

Perhaps David has some insight, since he architected the original UAPI split.

Cheers,

Michael
