From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] futex: add new exclusive lock & unlock command
 codes
Date: Tue, 22 Jul 2014 23:00:13 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407222217230.23352@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <1405956271-34339-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.10.1407211811360.20847@nanos> <53CEABD7.3030509@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53CEABD7.3030509-VXdhtT5mjnY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 22 Jul 2014, Waiman Long wrote:
> On 07/21/2014 12:42 PM, Thomas Gleixner wrote:
> > > +	/*
> > > +	 * The unlocker may have cleared the TID value and another task may
> > > +	 * steal it. However, if its TID is still set, we need to clear
> > > +	 * it as well as the FUTEX_WAITERS bit.
> >
> > No, that's complete and utter crap. The unlocker is current and it may
> > not have cleared anything.
> > 
> > Your design or the lack thereof is a complete disaster.
> 
> In patch 5, the documentation and the sample unlock does clear the TID before
> going in. The code here is just a safety measure in case the unlocker doesn't
> follow the recommendation.

I don't care about patch 5 at all. I'm already fed up reading 1/5. The
code is no safety measure it's a completely disastrous workaround.

We do not care whether user space follows recommendations. We set
rules and if the rules are violated then we act accordingly. Did you
even take the time to read the git history of futex.c? Did you notice
that we had a major security incident related to that code which we
fixed not long ago?
 
No, you obviously did not, otherwise you would not come up with
hackery which is going to explode in your face if exposed to a simple
syscall fuzzer, not to talk about a competent hacker. Without even
looking too deep I found two simple ways to leak kernel state and one
to corrupt kernel state. Brilliant stuff, really!

> > Sit down first and define the exact semantics of the new opcode. That
> > includes user and kernel space and the interaction with robust list,
> > which you happily ignored.
> > 
> > What are the semantics of uval? When can it be changed in kernel and
> > in user space? How do we deal with corruption of the user space value?
> 
> The semantics of the uval is the same as that of PI and robust futex where the
> TID portion contains the thread ID of the lock owner. It is my intention to
> make it works with the robust futex mechanism before it can be merged. This
> RPC patch series is for soliciting feedbacks and make the necessary changes
> that make the patch acceptable before I go deep into making it works with
> robust futex.

No, the semantics are not the same. PI and robust futexes have
different semantics, but you did not notice that at all.

Your so called semantics are really well thought out as as you have
proven with completely uncomprehensible hackeries, which you call
"safety measures".

And I do not care about your intention to make it work with robustness
etc. If you do not design it upfront to do so, then this code is going
to be a complete disaster. But to do that you need to sit down and
provide a proper design document and that wants to be patch 1/x not
the last one. And the code actually needs to follow that design.

> > How are faults handled?
> 
> As you have a lot more experience working with futexes than me, any
> suggestions on what kind of faults will happen and what are the best practices
> to handle them will be highly appreciated.

So shall I fly over and read you the source code of futex.c as a
bedtime story?

You did not even try to understand how futexes work and what corner
cases they have by studying the existing code and reading the git
history.

No, you simply cobbled something together and created random
performance numbers and because they are so wonderful, you expect that
I and the other people who worked hard on that code do your homework.

No, that's not how it works.

Your numbers are completely useless because they just measure the fast
path by omitting all the required security measures and corner case
handling.

Darren had his version of spinning done years ago, but we had to
ground it due to not resolvable issues at that point. I'm quite sure,
that you did not even try to figure out whether people had looked into
that issue before and tried to understand why it failed, otherwise you
would have been clever enough to provide a reference and explain why
your approach is better or solves the underlying problems.

So your RFC is not impressive at all. It's just an inferior
implementation of something we are aware of for a very long time.

I'm already tired of this, really. Unless you start to understand the
problem of futexes in the first place and you should ask your coworker
how mind boggling that can be, do not even bother to send another half
arsed patch. Spare the electrons and the time of everyone involved.

Thanks,

	tglx
