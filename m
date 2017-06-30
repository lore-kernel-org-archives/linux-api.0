From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Thu, 29 Jun 2017 21:03:42 -0700
Message-ID: <CA+55aFykNULx-b6M6FmUYdK2cn-OJKKfjaPwLN5xZGK+bioGaA@mail.gmail.com>
References: <20170614222017.14653-1-mcgrof@kernel.org> <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com> <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com> <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com> <20170629191506.GB12368@amt.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170629191506.GB12368-I4X2Mt4zSy4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: h@amt.cnet, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, jewalt-d4N2ExZK1jaSe5ORCPIMD9BPR1lH4CV8@public.gmane.org, rafal-g1n6cQUeyibVItvQsEIGlw@public.gmane.org, Arend Van Spriel <arend.vanspriel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "Li, Yi" <yi1.li-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Moritz Fischer <moritz.fischer-+aYTwkv1SeIAvxtiuMwx3w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Johannes Berg <johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Emmanuel Grumbach <emmanuel.grumbach-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Coelho, Luciano" <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kalle Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 29, 2017 at 12:15 PM, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Jun 29, 2017 at 09:13:29AM -0700, Linus Torvalds wrote:
>>
>> swait uses special locking and has odd semantics that are not at all
>> the same as the default wait queue ones. It should not be used without
>> very strong reasons (and honestly, the only strong enough reason seems
>> to be "RT").
>
> Performance shortcut:
>
> https://lkml.org/lkml/2016/2/25/301

Yes, I know why kvm uses it, I just don't think it's necessarily the
right thing.

That kvm commit is actually a great example: it uses swake_up() from
an interrupt, and that's in fact the *reason* it uses swake_up().

But that also fundamentally means that it cannot use swake_up_all(),
so it basically *relies* on there only ever being one single entry
that needs to be woken up.

And as far as I can tell, it really is because the queue only ever has
one entry (ie it's per-vcpu, and when the vcpu is blocked, it's
blocked - so no other user will be waiting there).

So it isn't that you migth queue multiple entries and then just wake
them up one at a time. There really is just one entry at a time,
right?

And that means that swait is actuially completely the wrong thing to
do. It's more expensive and more complex than just saving the single
process pointer away and just doing "wake_up_process()".

Now, it really is entirely possible that I'm missing something, but it
does look like that to me.

We've had wake_up_process() since pretty much day #1. THAT is the
fastest and simplest direct wake-up there is, not some "simple
wait-queue".

Now, admittedly I don't know the code and really may be entirely off,
but looking at the commit (no need to go to the lkml archives - it's
commit 8577370fb0cb ("KVM: Use simple waitqueue for vcpu->wq") in
mainline), I really think the swait() use is simply not correct if
there can be multiple waiters, exactly because swake_up() only wakes
up a single entry.

So either there is only a single entry, or *all* the code like

        dvcpu->arch.wait = 0;

-       if (waitqueue_active(&dvcpu->wq))
-               wake_up_interruptible(&dvcpu->wq);
+       if (swait_active(&dvcpu->wq))
+               swake_up(&dvcpu->wq);

is simply wrong. If there are multiple blockers, and you just cleared
"arch.wait", I think they should *all* be woken up. And that's not
what swake_up() does.

So I think that kvm_vcpu_block() could easily have instead done

    vcpu->process = current;

as the "prepare_to_wait()" part, and "finish_wait()" would be to just
clear vcpu->process. No wait-queue, just a single pointer to the
single blocking thread.

(Of course, you still need serialization, so that
"wake_up_process(vcpu->process)" doesn't end up using a stale value,
but since processes are already freed with RCU because of other things
like that, the serialization is very low-cost, you only need to be
RCU-read safe when waking up).

See what I'm saying?

Note that "wake_up_process()" really is fairly widely used. It's
widely used because it's fairly obvious, and because that really *is*
the lowest-possible cost: a single pointer to the sleeping thread, and
you can often do almost no locking at all.

And unlike swake_up(), it's obvious that you only wake up a single thread.

           Linus
