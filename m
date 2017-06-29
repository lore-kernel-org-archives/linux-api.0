From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 10:57:53 -0700
Message-ID: <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
References: <20170614222017.14653-1-mcgrof@kernel.org> <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com> <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com> <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com> <20170629174046.GC3954@linux-80c1.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170629174046.GC3954@linux-80c1.suse>
Sender: stable-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Lutomirski <luto@ker>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 10:40 AM, Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> For all the above, what do you think of my 'sswait' proposal?

I see no actual users of such a specialty interface.

I don't think we've *ever* had any actual problems with our current
wait-queues, apart from the RT issues, which were not about the
waitqueues themselves, but purely about RT itself.

So without some very compelling reason, I'd not want to add yet
another wait-queue.

I actually think swait is pure garbage. Most users only wake up one
process anyway, and using swait for that is stupid. If you only wake
up one, you might as well just have a single process pointer, not a
wait list at all, and then use "wake_up_process()".

There is *one* single user of swake_up_all(), and that one looks like
bogus crap also: it does it outside of the spinlock that could have
been used to protect the queue - p,lus I'm not sure there's really a
queue anyway, since I think it's just the grace-period kthread that is
there.

kvm uses swait, but doesn't use swake_up_all(), so it always just
wakes up a single waiter. That may be the right thing to do. Or it's
just another bug. I don't know. The KVM use looks broken too, since it
does

        if (swait_active(wqp)) {
                swake_up(wqp);

which is racy wrt new waiters, which implies that there is some
upper-level synchronization - possibly the same "only one thread
anyway".

So swake really looks like crap. It has crap semantics, it has crap
users, it's just broken.

The last thing we want to do is to create something _else_ specialized
like this.

                Linus
