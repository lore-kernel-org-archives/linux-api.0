From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] i2c: show and change bus frequency via sysfs
Date: Tue, 14 Oct 2014 12:24:51 +0300
Message-ID: <CAE1zotLVrSN-Dfw-GnCuu6jjBh6_bKC_S0goJj7ZYu4hFC_zqA@mail.gmail.com>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
	<1412885235-14026-4-git-send-email-octavian.purdila@intel.com>
	<CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ@mail.gmail.com>
	<CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
	<CAJjB1qJsmFebE2u_wMe2gdrQYcEwY1-yDLpufK97EXjEoR6omQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJjB1qJsmFebE2u_wMe2gdrQYcEwY1-yDLpufK97EXjEoR6omQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Roszko <mark.roszko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 14, 2014 at 4:53 AM, Mark Roszko <mark.roszko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> > If this limitations exists
> >they are not introduced by this patch. This patch just exposes the
> >frequency so that it can be read or changed in userspace.
>
> Ah, well right now you can have an i2c bus with driver 1 and 2. Say
> the i2c bus is configured for 60khz in kernel space which normally
> can't be changed. Driver 1 talks to a slave that cannot go above
> 100khz. Now the userspace interface is added to the i2c bus. Some
> userspace application decides to reconfigure the bus for 400khz and do
> its communication to some slave device. Now the kernel tries to do
> some background talking to the drive 1 slave and suddenly finds it can
> no longer communicate with it. Right now with the kernel space only
> configuration, the system is safe from being messed up easily. It's
> more of a sanity of configuration issue.

You need privileges to change the bus frequency, so this is a
configuration issue. Which you still have today, since can still set
the i2c frequency on some busses via a module parameter.

>
>
> >On a different not, I have noticed that a fixed set of frequencies
> >might not be the best API, since multiple drivers rather support a
> >rather large set of frequencies in a range. A better API might be to
> >expose a min-max range and let the bus driver adjust the requested
> >frequency. I will follow up with a second version that does that.
>
> I was actually thinking you could eliminate the table of supported
> frequencies and just have the bus driver handle the set frequency
> decision itself and just return an error code if it's invalid. There
> are legitiamate drivers that cannot do more than a list of frequencies
> already as well. One example is here:
> http://lxr.free-electrons.com/source/drivers/i2c/busses/i2c-bcm-kona.c#L717

Yes, I will do that for v2 and in addition I will also add min and max
attributes to make it easier to determine if a bus supports fast mode,
fast plus, high, etc.
