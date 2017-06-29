From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 15:53:23 -0700
Message-ID: <20170629155323.06445ddf@cakuba.netronome.com>
References: <20170629133530.GA14747@kroah.com>
        <alpine.DEB.2.20.1706291545320.1861@nanos>
        <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
        <20170629174046.GC3954@linux-80c1.suse>
        <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
        <20170629183339.GD3954@linux-80c1.suse>
        <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
        <20170629194015.GQ21846@wotan.suse.de>
        <20170629194455.GR21846@wotan.suse.de>
        <20170629135822.366fd67a@cakuba.netronome.com>
        <20170629225003.GU21846@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170629225003.GU21846@wotan.suse.de>
Sender: stable-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: nbroeking@me.com, Linus Torvalds <torvalds@linux-foundation.org>, Davidlohr Bueso <dave@stgolabs.net>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, 30 Jun 2017 00:50:03 +0200, Luis R. Rodriguez wrote:
> On Thu, Jun 29, 2017 at 01:58:22PM -0700, Jakub Kicinski wrote:
> > On Thu, 29 Jun 2017 21:44:55 +0200, Luis R. Rodriguez wrote:  
> > > > Since this swake_up() --> swake_up_all() reportedly *fixed* the one wake up
> > > > issue it would seem this does queue [0]. That said, I don't see any simple tests
> > > > tools/testing/selftests/swait but then again we don't have test for regular
> > > > waits either...
> > > > 
> > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=195477    
> > > 
> > > I should also note that the swake_up_all() should have only helped in cases where
> > > 3 cards were used, as if only 2 were used that should have been covered by just
> > > the swake_up(). Unless of course I hear otherwise by the reporter, Nicolas or
> > > from Jakub.  
> > 
> > I was hitting this with 2 cards.  
> 
> Thanks!
> 
> Thing is I'm not convinced the issue with 2 cards was the swake_up() Vs
> swake_up_all() in this case though. Let's recall also the missing wake up on
> errors! And the fact that netronome has optional firmware, which naturally can
> fail.
> 
> So could the issue with 2 cards instead of the miss of a wake up on error due
> to batched requests ? If so then that still would not put blame on the
> swake_up()!

Sorry, that was during manual tests.  I had the driver request the
firmware with _nowait() without an uevent, and then after I manually
wrote -1 to loading only one would get woken up.
