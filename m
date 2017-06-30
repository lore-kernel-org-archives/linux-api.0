From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Fri, 30 Jun 2017 08:57:14 -0300
Message-ID: <20170630115714.GD12169@amt.cnet>
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
Cc: h@amt.cnet, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Martin Fuzzey <mfuzzey@parkeon.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>
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
> Yes, I know why kvm uses it, I just don't think it's necessarily the
> right thing.
> 
> That kvm commit is actually a great example: it uses swake_up() from
> an interrupt, and that's in fact the *reason* it uses swake_up().
> 
> But that also fundamentally means that it cannot use swake_up_all(),
> so it basically *relies* on there only ever being one single entry
> that needs to be woken up.
> 
> And as far as I can tell, it really is because the queue only ever has
> one entry (ie it's per-vcpu, and when the vcpu is blocked, it's
> blocked - so no other user will be waiting there).

Exactly.
> 
> So it isn't that you migth queue multiple entries and then just wake
> them up one at a time. There really is just one entry at a time,
> right?

Yes.

> And that means that swait is actuially completely the wrong thing to
> do. It's more expensive and more complex than just saving the single
> process pointer away and just doing "wake_up_process()".

Aha, i see.

> 
> Now, it really is entirely possible that I'm missing something, but it
> does look like that to me.

Just drop it -- the optimization is not relevant anymore given VMX
hardware improvements.

> We've had wake_up_process() since pretty much day #1. THAT is the
> fastest and simplest direct wake-up there is, not some "simple
> wait-queue".
> 
> Now, admittedly I don't know the code and really may be entirely off,
> but looking at the commit (no need to go to the lkml archives - it's
> commit 8577370fb0cb ("KVM: Use simple waitqueue for vcpu->wq") in
> mainline), I really think the swait() use is simply not correct if
> there can be multiple waiters, exactly because swake_up() only wakes
> up a single entry.

There can't be: its one emulated LAPIC per vcpu. So only one vcpu
waits for that waitqueue.

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
> 
> So I think that kvm_vcpu_block() could easily have instead done
> 
>     vcpu->process = current;
> 
> as the "prepare_to_wait()" part, and "finish_wait()" would be to just
> clear vcpu->process. No wait-queue, just a single pointer to the
> single blocking thread.
> 
> (Of course, you still need serialization, so that
> "wake_up_process(vcpu->process)" doesn't end up using a stale value,
> but since processes are already freed with RCU because of other things
> like that, the serialization is very low-cost, you only need to be
> RCU-read safe when waking up).
> 
> See what I'm saying?
> 
> Note that "wake_up_process()" really is fairly widely used. It's
> widely used because it's fairly obvious, and because that really *is*
> the lowest-possible cost: a single pointer to the sleeping thread, and
> you can often do almost no locking at all.
> 
> And unlike swake_up(), it's obvious that you only wake up a single thread.
> 
>            Linus

Feel free to drop the KVM usage... agreed the interface is a special 
case and a generic one which handles multiple waiters 
and has debugging etc should be preferred to avoid bugs

Not sure if other people are using it (swait). 
