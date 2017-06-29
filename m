From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 21:44:55 +0200
Message-ID: <20170629194455.GR21846@wotan.suse.de>
References: <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse>
 <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
 <20170629194015.GQ21846@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629194015.GQ21846@wotan.suse.de>
Sender: stable-owner@vger.kernel.org
To: nbroeking@me.com, Jakub Kicinski <jakub.kicinski@netronome.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, mcgrof@kernel.org, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 09:40:15PM +0200, Luis R. Rodriguez wrote:
> On Thu, Jun 29, 2017 at 11:59:29AM -0700, Linus Torvalds wrote:
> > On Thu, Jun 29, 2017 at 11:33 AM, Davidlohr Bueso <dave@stgolabs.net> wrote:
> > > On Thu, 29 Jun 2017, Linus Torvalds wrote:
> > >
> > >> I actually think swait is pure garbage. Most users only wake up one
> > >> process anyway, and using swait for that is stupid. If you only wake
> > >> up one, you might as well just have a single process pointer, not a
> > >> wait list at all, and then use "wake_up_process()".
> > >
> > > But you still need the notion of a queue, even if you wake one task
> > > at a time... I'm probably missing your point here.
> > 
> > The *reason* they wake up only one seems to be that there really is
> > just one. It's some per-cpu idle thread for kvm, and for RCU it's the
> > RCU workqueue thread.
> > 
> > So the queue literally looks suspiciously pointless.
> > 
> > But I might be wrong, and there can actually be multiple entries.
> 
> Since this swake_up() --> swake_up_all() reportedly *fixed* the one wake up
> issue it would seem this does queue [0]. That said, I don't see any simple tests
> tools/testing/selftests/swait but then again we don't have test for regular
> waits either...
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=195477

I should also note that the swake_up_all() should have only helped in cases where
3 cards were used, as if only 2 were used that should have been covered by just
the swake_up(). Unless of course I hear otherwise by the reporter, Nicolas or
from Jakub.

  Luis
