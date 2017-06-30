From: Krister Johansen <kjlx@templeofstupid.com>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Fri, 30 Jun 2017 10:30:48 -0700
Message-ID: <20170630173048.GA2392@templeofstupid.com>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629191506.GB12368@amt.cnet>
 <CA+55aFykNULx-b6M6FmUYdK2cn-OJKKfjaPwLN5xZGK+bioGaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFykNULx-b6M6FmUYdK2cn-OJKKfjaPwLN5xZGK+bioGaA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, h@amt.cnet, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Martin Fuzzey <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.c>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 09:03:42PM -0700, Linus Torvalds wrote:
> On Thu, Jun 29, 2017 at 12:15 PM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Thu, Jun 29, 2017 at 09:13:29AM -0700, Linus Torvalds wrote:
> >>
> >> swait uses special locking and has odd semantics that are not at all
> >> the same as the default wait queue ones. It should not be used without
> >> very strong reasons (and honestly, the only strong enough reason seems
> >> to be "RT").
> >
> > Performance shortcut:
> >
> > https://lkml.org/lkml/2016/2/25/301
> 
> Now, admittedly I don't know the code and really may be entirely off,
> but looking at the commit (no need to go to the lkml archives - it's
> commit 8577370fb0cb ("KVM: Use simple waitqueue for vcpu->wq") in
> mainline), I really think the swait() use is simply not correct if
> there can be multiple waiters, exactly because swake_up() only wakes
> up a single entry.
> 
> So either there is only a single entry, or *all* the code like
> 
>         dvcpu->arch.wait = 0;
> 
> -       if (waitqueue_active(&dvcpu->wq))
> -               wake_up_interruptible(&dvcpu->wq);
> +       if (swait_active(&dvcpu->wq))
> +               swake_up(&dvcpu->wq);
> 
> is simply wrong. If there are multiple blockers, and you just cleared
> "arch.wait", I think they should *all* be woken up. And that's not
> what swake_up() does.

Code like this is probably wrong for another reason too.  The
swait_active() is likely redudant, since swake_up() also calls
swait_active().  The check in swake_up() returns if it thinks there are
no active waiters.  However, the synchronization needed to ensure a
proper wakeup is left as an exercise to swake_up's caller.

There have been a couple of other discussions around this topic
recently:

https://lkml.org/lkml/2017/5/25/722
https://lkml.org/lkml/2017/6/8/1222

The above is better written as the following, but even then you still
have the single/multiple wakeup problem:

 -       if (waitqueue_active(&dvcpu->wq))
 -               wake_up_interruptible(&dvcpu->wq);
 +       smp_mb();
 +       swake_up(&dvcpu->wq);


Just to add to the confusion, the last time I checked, the semantics of
swake_up() even differ between RT Linux and mainline, which makes this
even more confusing.

-K
