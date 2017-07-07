From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Fri, 7 Jul 2017 15:48:07 -0700
Message-ID: <CA+55aFwBF-Yct6VqbJbXF5KXd+2bu6HhX32BQ4WjZd132o2zPw@mail.gmail.com>
References: <20170629125402.GH26046@kroah.com> <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com> <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse> <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse> <20170705020635.GD11168@linux-80c1.suse>
 <CA+55aFwR9OTt9fuAj2dW_S2muphhH4akVzSASS7Bn2QRb3brog@mail.gmail.com> <20170707222735.GC30414@linux-80c1.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170707222735.GC30414@linux-80c1.suse>
Sender: stable-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Martin Fuzzey <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, Rafa?? Mi??ecki <rafal@milecki.pl>, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeauro>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 7, 2017 at 3:27 PM, Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> Ok sorry, fwiw those were 80-line fixlets I thought were trivial enough
> to just fly by.

I find them annoying, because it makes it so much harder to see what
the patch actually does.

In this case, I think that more than 50% of the patch was just
whitespace changes..

> Oh indeed, this was always my intent. Going back to the patch, when
> checking DEFINE_WAIT_FUNC I clearly overlooked the ->func()
> implications, breaking all kinds of semantics. With that and the
> constraints aforementioned in the patch, I see no sane way of using
> wake_qs.

Well, very few people actually use "wake_up_all()", particularly for
any of the things that use special wake functions.

So it probably works in practice.

And then somebody starts using pollfd or something on one the things
that *do* use wake_up_all() and happens to also allow polling (or
whatever), and you get nasty crashes.

> Given that you seem to agree that the lockless version is possible as
> long as we keep semantics, this imho is another point for some form of
> simplified waitqueues.

We just really haven't had a lot of problems with the waitqueues in my
experience. Many of the historical big problems were about the whole
"exclusive vs non-exclusive" thundering herd problems, which is
actually the most complex thing about them (the callback function adds
a pointer to the wait queue, so makes it bigger, but that is very
seldom a huge issue).

Most of the things that want specific wakeups tend to be some really
low-level stuff (ie semaphores etc - both the sysvipc kind of ones and
the kernel locking kind of ones).

They are often doing their very special own things anyway. And often
the regular waitqueues actually work fine, and the biggest thing is to
use the lock within the waitqueue for the object that is being waited
on too, so that you just avoid the double locking.

So you may have hit the one or two cases where the usual wait-queues
didn't work well, but in *most* cases they work wonderfully.

             Linus
