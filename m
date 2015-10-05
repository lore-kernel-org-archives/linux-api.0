From: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Subject: Re: [PATCH] timerfd: expose uapi header
Date: Mon, 5 Oct 2015 21:20:57 +0200
Message-ID: <20151005212057.396698cc@lse.epita.fr>
References: <1444056829-9118-1-git-send-email-gabriel@lse.epita.fr>
	<5414742.dPp9ExW9xv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5414742.dPp9ExW9xv@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, stephen hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Masahiro Yamada <yamada.m-NAum8xwdG0+S7A1Ibl2khg@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 05 Oct 2015 16:57:21 +0200
Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:

> On Monday 05 October 2015 16:53:39 Gabriel Laskar wrote:
> > this patch expose the timerfd apis to the userland. It is already in
> > glibc header sys/timerfd.h but not synchronised, and missing the ioctl
> > number definition.
> > 
> > Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> > 
> 
> What happens if you include both sys/timerfd.h and linux/timerfd.h then? 

It will conflict, yes, what should I do? make the kernel header in a
way that this will not conflict, or just patch the glibc headers too?

> > header-y += telephony.h
> > header-y += termios.h
> > header-y += thermal.h
> >+header-y += tiemrfd.h
> > header-y += time.h
> > header-y += times.h
> > header-y += timex.h
> 
> s/tiemrfd/timerfd/

I miss that, I really need to me more careful about this. Will send a
correction for this part.


-- 
Gabriel Laskar
