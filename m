From: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 21:40:15 +0200
Message-ID: <20170629194015.GQ21846@wotan.suse.de>
References: <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse>
 <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Coelho, Luciano" <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo@codeaur>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 11:59:29AM -0700, Linus Torvalds wrote:
> On Thu, Jun 29, 2017 at 11:33 AM, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
> > On Thu, 29 Jun 2017, Linus Torvalds wrote:
> >
> >> I actually think swait is pure garbage. Most users only wake up one
> >> process anyway, and using swait for that is stupid. If you only wake
> >> up one, you might as well just have a single process pointer, not a
> >> wait list at all, and then use "wake_up_process()".
> >
> > But you still need the notion of a queue, even if you wake one task
> > at a time... I'm probably missing your point here.
> 
> The *reason* they wake up only one seems to be that there really is
> just one. It's some per-cpu idle thread for kvm, and for RCU it's the
> RCU workqueue thread.
> 
> So the queue literally looks suspiciously pointless.
> 
> But I might be wrong, and there can actually be multiple entries.

Since this swake_up() --> swake_up_all() reportedly *fixed* the one wake up
issue it would seem this does queue [0]. That said, I don't see any simple tests
tools/testing/selftests/swait but then again we don't have test for regular
waits either...

[0] https://bugzilla.kernel.org/show_bug.cgi?id=195477

> If there are, I don't see why the wake-up-one semantics the code uses
> would be valid, though.

Not sure what's wrong with it?

I believe one use case for example is for when we know that waker alone would
be able to ensure the next item in queue will also be woken up. Such was the
case for the kmod.c conversion I tested, and behold it seemed to have wored
with just swake_up(). Its obviously *fragile* though given you *assume* error
cases also wake up. In the case of kmod.c we have no such error cases but in
firmware_class.c we *do*, and actually that is part of the next set of fixes I
have to address next, but that issue would be present even if we move to wait
for completion and complete_all() is used.

  Luis
