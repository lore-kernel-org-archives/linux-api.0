From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [RFC PATCH 3/3] i2c: show and change bus frequency via sysfs
Date: Sun, 12 Oct 2014 10:06:37 -0700
Message-ID: <20141012170637.GA12591@roeck-us.net>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
 <1412885235-14026-4-git-send-email-octavian.purdila@intel.com>
 <CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ@mail.gmail.com>
 <CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Mark Roszko <mark.roszko@gmail.com>, linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Johan Hovold <johan@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 12, 2014 at 12:32:56PM +0300, Octavian Purdila wrote:
> On Sat, Oct 11, 2014 at 11:14 PM, Mark Roszko <mark.roszko@gmail.com> wrote:
> 
> > This seems limiting to arches with peripherals that can support a range of
> > frequencies rather than fixed numbers.
> > Also it creates some portability quirkiness between platforms when all the
> > i2c bus drivers have different supported freq lists and you have to match
> > exactly the right frequency. I.e. one guy does 60khz but another only has
> > 80khz.
> 
> Sorry, I don't understand your points here. If this limitations exists
> they are not introduced by this patch. This patch just exposes the
> frequency so that it can be read or changed in userspace.
> 
> > Another issue is in systems where you have i2c devices on the same bus as
> > the sysfs user space driver. User space could set a bus frequency that
> > prevents operation with a system i2c device.
> 
> Changing the frequency is limited to root. Also, bus drivers do not
> have to implement set_freq if it is thought not to be safe.
> 
> On a different not, I have noticed that a fixed set of frequencies
> might not be the best API, since multiple drivers rather support a
> rather large set of frequencies in a range. A better API might be to
> expose a min-max range and let the bus driver adjust the requested
> frequency. I will follow up with a second version that does that.

As two separate sysfs attributes, maybe ? sysfs is supposed to provide
one value per attribute.

For the patch itself, I would find it better if you used is_visible to
determine if the new attributes should be visible (and/or writable) instead
of returning -EOPNOTSUPP.

Guenter
