From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: UAPI headers including non-UAPI headers by accident?
Date: Tue, 23 Jun 2015 22:44:50 +0200
Message-ID: <5721321.xeloEYqQC1@wuerfel>
References: <CALCETrVaWJVDFydhXv320iCuFhTMi9txx+MpzsA_Q7yeZxMDSQ@mail.gmail.com> <9141492.JqTlmk9dHk@wuerfel> <CALCETrVxa9U9GMOnPZ5cAnPJvtCqjia1J1e5YBET6deAPKU82g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVxa9U9GMOnPZ5cAnPJvtCqjia1J1e5YBET6deAPKU82g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 18 June 2015 11:57:56 Andy Lutomirski wrote:
> On Thu, Jun 18, 2015 at 12:58 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> > On Thursday 18 June 2015 09:52:36 Michael Kerrisk wrote:
> >> [CC += David]
> >>
> >> On 2 June 2015 at 18:36, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> > include/uapi/linux/signal.h starts with:
> >> >
> >> > #ifndef _UAPI_LINUX_SIGNAL_H
> >> > #define _UAPI_LINUX_SIGNAL_H
> >> >
> >> > #include <asm/signal.h>
> >> > #include <asm/siginfo.h>
> >> >
> >> > This causes it to include <asm/signal.h>, which is not the same thing
> >> > as <uapi/asm/signal.h>.  Changing that will break userspace use of
> >> > this header, though, as the uapi/ won't get removed.
> >> >
> >> > What's the correct fix?  This is causing trouble with a UML build for me.
> >>
> >> Perhaps David has some insight, since he architected the original UAPI split.
> >
> > The uapi headers are installed without the uapi prefix. This means
> > that inside of the kernel, we get
> >
> >
> >  linux/signal.h
> >  -> uapi/linux/signal.h
> >     -> asm/signal.h
> >        -> uapi/asm/signal.h
> >
> > while in the installed headers we just get
> >
> >     linux/signal.h
> >        -> asm/signal.h
> >
> > This all looks right to me: user space only sees the exported portions
> > under the traditional names, while the kernel sees both the kernel-side
> > and user-side definitions from the same path.
> >
> 
> It seems counterintuitive and error-prone to me that including
> <uapi/linux/signal.h> would pull in non-UAPI asm/signal.h declarations
> in the kernel but not when used from userspace.  It would make it very
> easy to break the header such that it's only broken in a userspace
> context.
> 

It's an artifact of how the files were originally generated, as the UAPI
headers used to be part of the normal headers, with #ifdef __KERNEL__ around
the parts that are not in include/uapi now.

For some reason, we now have device drivers including the uapi headers
directly, which was probably done as an accident. Maybe we can just
change them all back to use the normal header file names and add a
checkpatch warning in case someone else tries to use the uapi headers
directly?

	Arnd
