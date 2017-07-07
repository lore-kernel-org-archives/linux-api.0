From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Fri, 7 Jul 2017 12:58:26 -0700
Message-ID: <CA+55aFwR9OTt9fuAj2dW_S2muphhH4akVzSASS7Bn2QRb3brog@mail.gmail.com>
References: <20170614222017.14653-1-mcgrof@kernel.org> <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com> <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com> <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse> <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse> <20170705020635.GD11168@linux-80c1.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705020635.GD11168-3dK4OQgjB4rH06JGZaSw0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org>, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Coelho, Luciano" <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kal
List-Id: linux-api@vger.kernel.org

On Tue, Jul 4, 2017 at 7:06 PM, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:
>
> So here's something that boots and builds a kernel. Any thoughts?

This patch ios just nasty crap. Sorry.

It has random whitespace changfes that look entirely unrelated to trhe
actual real meat of the patch, and that actually make whitespace
*worse*.

WHY?

That alone should just mean that this patch needs to be thrown away
and never ever looked at again.

But also, this is fundamentally garbage.

Exactly for the same reasons that the swait interfaces were
fundamentally broken.

It *looks* like it works on regular wait queues, and people can start
using it that way, but it actually doesn't have the right semantics at
all.

The new "lockless" function ONLY works if you don't have a private
wakeup function.

So it completely changes the semantics of "wake_up_all()".

It used to be that "wake_up_all()" did what the name suggested.

With this patch, "wake_up_all()" will not cause random kernel oopses
or memory corruption if you use any of the more specialized wakeup
functions

Guys, STOP DOING SHIT LIKE THIS!

The swake interface was incredible crap, with bad semantics that
confused people, and bad performance too.

Don't make the normal wait-queues have similar idiotic problems.

So no, this is not only NAK'ed, the whole approach is pure and utter
shit and this needs to be buried deep and forgotten about so that it
never ever comes back to life.

               Linus
