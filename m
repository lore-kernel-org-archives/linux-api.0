From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] i2c: show and change bus frequency via sysfs
Date: Sun, 12 Oct 2014 12:32:56 +0300
Message-ID: <CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
	<1412885235-14026-4-git-send-email-octavian.purdila@intel.com>
	<CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Roszko <mark.roszko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 11, 2014 at 11:14 PM, Mark Roszko <mark.roszko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This seems limiting to arches with peripherals that can support a range of
> frequencies rather than fixed numbers.
> Also it creates some portability quirkiness between platforms when all the
> i2c bus drivers have different supported freq lists and you have to match
> exactly the right frequency. I.e. one guy does 60khz but another only has
> 80khz.

Sorry, I don't understand your points here. If this limitations exists
they are not introduced by this patch. This patch just exposes the
frequency so that it can be read or changed in userspace.

> Another issue is in systems where you have i2c devices on the same bus as
> the sysfs user space driver. User space could set a bus frequency that
> prevents operation with a system i2c device.

Changing the frequency is limited to root. Also, bus drivers do not
have to implement set_freq if it is thought not to be safe.

On a different not, I have noticed that a fixed set of frequencies
might not be the best API, since multiple drivers rather support a
rather large set of frequencies in a range. A better API might be to
expose a min-max range and let the bus driver adjust the requested
frequency. I will follow up with a second version that does that.
