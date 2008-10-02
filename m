From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC patch 0/3] signals: add rt_tgsigqueueinfo syscall V2
Date: Thu, 2 Oct 2008 10:57:38 +0200 (CEST)
Message-ID: <alpine.LFD.1.10.0810021055400.5549@apollo.tec.linutronix.de>
References: <20081001095204.343984413@linutronix.de> <cfd18e0f0810010757j7a9f6deaj47a06f30e371af1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0810010757j7a9f6deaj47a06f30e371af1e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-6lXkIZvqkOAvJsYlp49lxw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 1 Oct 2008, Michael Kerrisk wrote:
> [CC+=linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
> 
> On Wed, Oct 1, 2008 at 12:01 PM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> > Changes vs. V1: compat_sys_rt_sigqueueinfo implemented. Thanks Roland !
> >
> > sys_kill has a counterpart sys_tgkill which allows to send signals to
> > a particular thread. sys_rt_sigqueueinfo is lacking such a counterpart.
> >
> > Aside of the asymetry it is a show stopper for migrating applications
> > from other unix-alike RTOSes.
> >
> > The following patch series implements rt_tgsigqueueinfo and hooks it
> > up for x86.
> 
> This is an excellent candidate for CCing to the new linux-api@vger
> (http://thread.gmane.org/gmane.linux.ltp/5658/), since it is an API
> change.

Oops, yes forgot about that.
 
> > Find below the raw documentation.
> 
> Thanks -- I'll work that up into a man page when this gets closer to release.

I'll send out test code later this week - once I get a breather from
bugs and regressions again.

Thanks,

	tglx

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
