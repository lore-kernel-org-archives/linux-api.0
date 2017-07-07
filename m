From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Fri, 7 Jul 2017 15:27:35 -0700
Message-ID: <20170707222735.GC30414@linux-80c1.suse>
References: <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse>
 <20170705020635.GD11168@linux-80c1.suse>
 <CA+55aFwR9OTt9fuAj2dW_S2muphhH4akVzSASS7Bn2QRb3brog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwR9OTt9fuAj2dW_S2muphhH4akVzSASS7Bn2QRb3brog@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Martin Fuzzey <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, Rafa?? Mi??ecki <rafal@milecki.pl>, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora>
List-Id: linux-api@vger.kernel.org

On Fri, 07 Jul 2017, Linus Torvalds wrote:

>On Tue, Jul 4, 2017 at 7:06 PM, Davidlohr Bueso <dave@stgolabs.net> wrote:
>>
>> So here's something that boots and builds a kernel. Any thoughts?
>
>This patch ios just nasty crap. Sorry.
>
>It has random whitespace changfes that look entirely unrelated to trhe
>actual real meat of the patch, and that actually make whitespace
>*worse*.

Ok sorry, fwiw those were 80-line fixlets I thought were trivial enough
to just fly by.

>
>WHY?
>
>That alone should just mean that this patch needs to be thrown away
>and never ever looked at again.
>
>But also, this is fundamentally garbage.
>
>Exactly for the same reasons that the swait interfaces were
>fundamentally broken.
>
>It *looks* like it works on regular wait queues, and people can start
>using it that way, but it actually doesn't have the right semantics at
>all.
>
>The new "lockless" function ONLY works if you don't have a private
>wakeup function.

Oh indeed, this was always my intent. Going back to the patch, when
checking DEFINE_WAIT_FUNC I clearly overlooked the ->func()
implications, breaking all kinds of semantics. With that and the
constraints aforementioned in the patch, I see no sane way of using
wake_qs.

>
>So no, this is not only NAK'ed, the whole approach is pure and utter
>shit and this needs to be buried deep and forgotten about so that it
>never ever comes back to life.

Given that you seem to agree that the lockless version is possible as
long as we keep semantics, this imho is another point for some form of
simplified waitqueues.

But yeah.

Thanks,
Davidlohr
