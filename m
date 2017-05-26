From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] firmware: fix sending -ERESTARTSYS due to signal on
 fallback
Date: Fri, 26 May 2017 22:52:21 +0200
Message-ID: <20170526205221.GZ8951@wotan.suse.de>
References: <20170524205658.GK8951@wotan.suse.de>
 <20170524214027.7775-1-mcgrof@kernel.org>
 <CALCETrXUrirO-vg3M+MGhn=0gZTwx0phsRDS4TCwWWgNYC6RsA@mail.gmail.com>
 <CAB=NE6VENGmTEZ3_8EWmv6bhT81k=szg0_POWJm2SP+V21CeBw@mail.gmail.com>
 <CALCETrU4__YUGk36PN=FbuEf0SBaTrxQQqm4sWs2NrZ+6WN7jA@mail.gmail.com>
 <CANh8QzwPb_+RKs5QVt7mdFk8h_rOMVS3j9m0OADgvzBtNqBBLg@mail.gmail.com>
 <20170526194001.GR8951@wotan.suse.de>
 <CANh8QzyqQ5hubWJvWYxgoQ3baL6sgoQPSzEHMY0tu8WNGS2gZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANh8QzyqQ5hubWJvWYxgoQ3baL6sgoQPSzEHMY0tu8WNGS2gZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fuzzey, Martin" <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>
Cc: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas <nbroeking-BUHhN+a2lJ4@public.gmane.org>, John Ewalt <jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-yzvPICuk2ABMcg4IHK0kFoH6Mc4MB0Vx@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 26, 2017 at 10:23:03PM +0200, Fuzzey, Martin wrote:
> On 26 May 2017 at 21:40, Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > No no, this is not how the fallback system works.
> 
> The sysfs file I was talking about is *not* the sysfs file involved in
> the firmware loading mechanism
> but a *custom* sysfs file used by a driver to *trigger* the call to
> request_firmware() [synchronous] in the first place.

OK!

> That is, my driver does not do request_firmware() in its probe()
> function like most but when requested by
> userspace. That's a valid usage as far as I can tell. Nothing says
> request_firmware() is only allowed from probe.

In fact we prefer sync calls not to be done on probe from just a practical
perspective as this can delay boot.

> Not sure it is relevant here but here's the reason for doing it this
> way: (skip this bit if not interested)
> I have a small microcontroller used to manage the power to the main CPU.
> It is connected to the CPU by a GPIO line.
> On power up the microcrontroller powers up the main CPU and starts a timer.
> If the application doesn't start in time the microcontroller power
> cycles the CPU.

OK

> In addition to the the above the microcontroller is connected to the
> CPU by a I2C bus for various other functions
> including firmware update (of the microcontroller software).

OK.

> In order to keep the critical power up code on the microcontroller
> very simple the I2C connection is not available
> until *after* the power up confirmation by the GPIO line.

I was not able to parse this.

You seem to be saying the I2C interface for firmware updates of the
microcontroller software is not available until the CPU it controls
is up, and this is confirmed through the GPIO line ? The I2c firmware
update interface is not for the target CPU the microcontroller controls ?

>From reading the below it seems this is right.

> So, on the linux side, there is a custom driver which exports a sysfs
> entry that userspace writes to in order to confirm
> startup.

OK so Linux runs on this host the microcontroller powers up, and it has
a custom driver, and it just toggles a knob to inform the microcontroller,
"Hey dude, I'm up, give me firmware!" ?

> The driver, when that sysfs file is written to, first sets the GPIO
> line to signal the microcontroller that the application has
> started so it can stop its timer and activate the I2C interface.

Got it! How does it know the I2C interface is ready ? Does it wait ?

> Then it does a request_firmware() to obtain the firmware the microcontroler
> is supposed to have. It then verifies it using commands over I2C to compare
> checksums etc and updates it if needed.

OK. Got it.

> >> 9) The system call machinery invokes the signal handler
> >> 10) The signal handler does its stuff
> >> 11) Because SA_RESTART was set the system call is restarted (calling
> >> the sysfs .store) and we try it all again from step 2
> >
> > OK so this seems to reveal an internal working of some android
> > loader of some sort. Thanks.
> >
> 
> Nothing Android specific here.
> 
> This is the standard *linux* behaviour.
> The retry is done *in the kernel* not on the android userspace side

Alright !

> > This could mean we get a loop on finit_module() if a signal is detected
> > on firmware_request() on every call. Is that fine? Is it expected ?
> 
> Ok so here we are talking about the standard case 

I would not say its standard. We support it, but we prefer async requests
are used there.

But its possible...  And since this as you clarify Linux deals with this
specially it is of interest what we do return.

> of request_firmware() being
> called from probe() If the driver is a loadable module then yes the it will
> be retried.  If it gets a signal on every try then something else is wrong
> I'd say
> 
> If the driver is compiled in then there is no retry since the call to probe
> doesn't go through the syscall machinary. But there shouldn't be a
> signal either in that
> case since it's not being called from a userspace process in that case.

Still -- its all possible on finit_module() so we still must consider the case.
If sending -ERESTARTSYS is not a good idea we could for instance send another
special error to let driver *then* make an informed decision, but that it
could still interpret as it actually having been -ERESTARTSYS.

> > So you seem to be suggesting the driver's should decide to mask or
> > not -ERSTARTSYS.
> >
> 
> Only if the driver knows that it is not restartable *itself*.
> Shoudn't happen very often

I'd prefer to hear more from linux-api folks.

  Luis
