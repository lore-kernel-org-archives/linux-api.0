From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 16:00:32 -0700
Message-ID: <CAB=NE6V_6RmvJkXkYUU9xUO_7_+RGQre+CR2z-mCR=QkYSq8vA@mail.gmail.com>
References: <20170629133530.GA14747@kroah.com> <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse> <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse> <CA+55aFz8Mhx+A-g-5yOG-O1ZLRUR_fpeeA4iBNGH8EnDBZEdpA@mail.gmail.com>
 <20170629194015.GQ21846@wotan.suse.de> <20170629194455.GR21846@wotan.suse.de>
 <20170629135822.366fd67a@cakuba.netronome.com> <20170629225003.GU21846@wotan.suse.de>
 <20170629155323.06445ddf@cakuba.netronome.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170629155323.06445ddf@cakuba.netronome.com>
Sender: stable-owner@vger.kernel.org
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Nicolas Broeking <nbroeking@me.com>, Linus Torvalds <torvalds@linux-foundation.org>, Davidlohr Bueso <dave@stgolabs.net>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, Martin Fuzzey <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, Co
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 3:53 PM, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
> On Fri, 30 Jun 2017 00:50:03 +0200, Luis R. Rodriguez wrote:
>> On Thu, Jun 29, 2017 at 01:58:22PM -0700, Jakub Kicinski wrote:
>> > On Thu, 29 Jun 2017 21:44:55 +0200, Luis R. Rodriguez wrote:
>> > > > Since this swake_up() --> swake_up_all() reportedly *fixed* the one wake up
>> > > > issue it would seem this does queue [0]. That said, I don't see any simple tests
>> > > > tools/testing/selftests/swait but then again we don't have test for regular
>> > > > waits either...
>> > > >
>> > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=195477
>> > >
>> > > I should also note that the swake_up_all() should have only helped in cases where
>> > > 3 cards were used, as if only 2 were used that should have been covered by just
>> > > the swake_up(). Unless of course I hear otherwise by the reporter, Nicolas or
>> > > from Jakub.
>> >
>> > I was hitting this with 2 cards.
>>
>> Thanks!
>>
>> Thing is I'm not convinced the issue with 2 cards was the swake_up() Vs
>> swake_up_all() in this case though. Let's recall also the missing wake up on
>> errors! And the fact that netronome has optional firmware, which naturally can
>> fail.
>>
>> So could the issue with 2 cards instead of the miss of a wake up on error due
>> to batched requests ? If so then that still would not put blame on the
>> swake_up()!
>
> Sorry, that was during manual tests.  I had the driver request the
> firmware with _nowait() without an uevent,

Can you provide the output of

grep  CONFIG_FW_LOADER_USER_HELPER .config

I'd like to see if CONFIG_FW_LOADER_USER_HELPER_FALLBACK was disabled.
Not to be confused with the CONFIG_FW_LOADER_USER_HELPER.

When the uevent is not set its also known as "a custom fallback
mechanism" and by default that has set a timeout of
MAX_SCHEDULE_TIMEOUT, which means that even if the direct filesystem
lookup failed the fallback mechanism would be used and just sit and
wait for what seems to be forever until user input was provided.

> and then after I manually
> wrote -1 to loading only one would get woken up.

Great, this helps, so for those not familiar with the firmware sysfs
fallback mechanism:

The relevant values one could use are:

1: Start a load, discarding any previous partial load.
0: Conclude the load and hand the data to the driver code.
-1: Conclude the load with an error and discard any written data.

So you are triggering a failure. And indeed I expect the patch I just
provided to be the one to fix your issue with 2 cards.

  Luis
