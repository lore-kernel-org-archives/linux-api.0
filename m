From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 10:40:46 -0700
Message-ID: <20170629174046.GC3954@linux-80c1.suse>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Lutomirski <luto@ker>
List-Id: linux-api@vger.kernel.org

On Thu, 29 Jun 2017, Linus Torvalds wrote:

>Well, I'd actually say it the other way around: swait should not be
>used in general, only in _very_ particular pieces of code that
>actually explicitly need the odd swait semantics.
>
>swait uses special locking and has odd semantics that are not at all
>the same as the default wait queue ones. It should not be used without
>very strong reasons (and honestly, the only strong enough reason seems
>to be "RT").
>
>The special locking means that swait doesn't do DEBUG_LOCK_ALLOC, but
>it also means that it doesn't even work in all contexts.
>
>So "swake_up()" does surprising things (only wake up one - that's what
>caused a firmware loading bug), and "swake_up_all()" has magic rules
>about interrupt disabling.
>
>The thing is simply a collection of small hacks and should NOT be used
>in general.

For all the above, what do you think of my 'sswait' proposal?

Thanks,
Davidlohr
