From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 19:29:21 +0200
Message-ID: <20170629172921.GM21846@wotan.suse.de>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <BY2PR21MB00365B4A70BD334F4568A086CBD20@BY2PR21MB0036.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BY2PR21MB00365B4A70BD334F4568A086CBD20@BY2PR21MB0036.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "mfuzzey@parkeon.com" <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, "jewalt@lgsinnovations.com" <jewalt@lgsinnovations.com>, "rafal@milecki.pl" <rafal@milecki.pl>, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, "atull@kernel.org" <atull@kernel.org>, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emman
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 04:31:08PM +0000, Matthew Wilcox wrote:
> Linus Torvalds wrote:
> > The thing is simply a collection of small hacks and should NOT be used
> > in general.
> > 
> > I never want to see a driver use that code, for example. It was
> > designed for RCU and RT, and it should damn well be limited to that.
> 
> Maybe put #ifndef MODULE around the entire include file then?
> And definitely remove this line:
> 
> * One would recommend using this wait queue where possible.

I'll respin and port away from swait, and add the #ifndef MODULE and special
note on swait.h.

  Luis
