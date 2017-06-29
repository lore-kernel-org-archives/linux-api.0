From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 11:33:39 -0700
Message-ID: <20170629183339.GD3954@linux-80c1.suse>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Lutomirski <luto@ker>
List-Id: linux-api@vger.kernel.org

On Thu, 29 Jun 2017, Linus Torvalds wrote:

>So without some very compelling reason, I'd not want to add yet
>another wait-queue.

Yes, I was expecting this and very much agree.

I'll actually take a look at wake_q for wake_up_all() and co. to see if
we can reduce the spinlock hold times. Of course it would only make sense
for more than a one wakeup.

>I actually think swait is pure garbage. Most users only wake up one
>process anyway, and using swait for that is stupid. If you only wake
>up one, you might as well just have a single process pointer, not a
>wait list at all, and then use "wake_up_process()".

But you still need the notion of a queue, even if you wake one task
at a time... I'm probably missing your point here.

>There is *one* single user of swake_up_all(), and that one looks like
>bogus crap also: it does it outside of the spinlock that could have
>been used to protect the queue - p,lus I'm not sure there's really a
>queue anyway, since I think it's just the grace-period kthread that is
>there.

So those cases when there's only one waiter I completely agree should
not be using waitqueues. pcpu-rwsems in the past suffered from this.

Thanks,
Davidlohr
