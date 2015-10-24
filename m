From: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v8 06/14] task_isolation: provide strict mode configurable
 signal
Date: Sat, 24 Oct 2015 09:16:23 +0000
Message-ID: <AM2PR02MB041742EF947F7182286282FCBD250@AM2PR02MB0417.eurprd02.prod.outlook.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-7-git-send-email-cmetcalf@ezchip.com>
 <20151020205610.51b3d742@grimm.local.home> <5626EABC.9060202@ezchip.com>
 <CALCETrXqDi24EPn79X9SXuz+5sYGZBF3yCRzb8PwdL=YbxVujw@mail.gmail.com>
 <AM2PR02MB041772AEFFA939F2F8619B36BD380@AM2PR02MB0417.eurprd02.prod.outlook.com>
 <CALCETrVuE_VCk-7_VMJ-orL8pg+0F5vq6qvt4SfgXzt_MRr-SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVuE_VCk-7_VMJ-orL8pg+0F5vq6qvt4SfgXzt_MRr-SQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Hi Andy,

Thank for the feedback.


> From: Andy Lutomirski [mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org]
> Sent: Wednesday, October 21, 2015 9:53 PM
> To: Gilad Ben Yossef
> Cc: Chris Metcalf; Steven Rostedt; Ingo Molnar; Peter Zijlstra; Andrew
> Morton; Rik van Riel; Tejun Heo; Frederic Weisbecker; Thomas Gleixner; Paul
> E. McKenney; Christoph Lameter; Viresh Kumar; Catalin Marinas; Will Deacon;
> linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux API; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode
> configurable signal
> 


> >> >> On Tue, 20 Oct 2015 16:36:04 -0400
> >> >> Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> >> >>
> >> >>> Allow userspace to override the default SIGKILL delivered
> >> >>> when a task_isolation process in STRICT mode does a syscall
> >> >>> or otherwise synchronously enters the kernel.
> >> >>>
> > <snip>
> >> >
> >> > It doesn't map SIGKILL to some other signal unconditionally.  It just allows
> >> > the "hey, you broke the STRICT contract and entered the kernel" signal
> >> > to be something besides the default SIGKILL.
> >> >
> >>
> >
> > <snip>
> >>
> >> I still dislike this thing.  It seems like a debugging feature being
> >> implemented using signals instead of existing APIs.  I *still* don't
> >> see why perf can't be used to accomplish your goal.
> >>
> >
> > It is not (just) a debugging feature. There are workloads were not
> performing an action is much preferred to being late.
> >
> > Consider the following artificial but representative scenario: a task running
> in strict isolation is controlling a radiotherapy alpha emitter.
> > The code runs in a tight event loop, reading an MMIO register with location
> data, making some calculation and in response writing an
> > MMIO register that triggers the alpha emitter. As a safety measure, each
> trigger is for a specific very short time frame - the alpha emitter
> > auto stops.
> >
> > The code has a strict assumption that no more than X cycles pass between
> reading the value and the response and the system is built in
> > such a way that as long as the code has mastery of the CPU the assumption
> holds true. If something breaks this assumption (unplanned
> > context switch to kernel), what you want to do is just stop place
> > rather than fire the alpha emitter X nanoseconds too late.
> >
> > This feature lets you say: if the "contract" of isolation is broken, notify/kill
> me at once.
> 
> That's a fair point.  It's risky, though, for quite a few reasons.
> 
> 1. If someone builds an alpha emitter like this, they did it wrong.
> The kernel should write a trigger *and* a timestamp to the hardware
> and the hardware should trigger at the specified time if the time is
> in the future and throw an error if it's in the past.  If you need to
> check that you made the deadline, check the actual desired condition
> (did you meat the deadline?) not a proxy (did the signal fire?).
> 

As I wrote above it is an *artificial* scenario. 

Yes, hardware and systems can be designed better, but they are not
always are and in these kind of systems, you really do want to have
double or triple checks.

Knowing such systems, even IF the hardware was designed as you 
specified (and I agree it should!) you would still add the software
protection.

> 2. This strict mode thing isn't exhaustive.  It's missing, at least,
> coverage for NMI, MCE, and SMI.  Sure, you can think that you've
> disabled all NMI sources, you can try to remember to set the
> appropriate boot flag that panics on MCE (and hope that you don't get
> screwed by broadcast MCE on Intel systems before it got fixed
> (Skylake?  Is the fix even available in a released chip?), and, for
> SMI, good luck...

You are right - it isn't exhaustive. It is one piece in a bigger puzzle.
Many of the other bits are platform specific and some of them have
been dealt with on the platform that care about these things.

Yes, we don't have dark magic to detect SMIs. Is that a reason to penalize
platforms where there is no such thing as SMI? 
 
 
> 3. You haven't dealt with IPIs.  The TLB flush code in particular
> seems like it will break all your assumptions.
>

But we have - in the general context. Consider this patch set from 2012 -
https://lwn.net/Articles/479510/

Not finished for sure. But what we have is now useful enough that it is used
in the real world for different workloads on different platforms, from packet
 processing, through HPC to high frequency trading.

> Maybe it would make sense to whack more of the moles before adding a
> big assertion that there aren't any moles any more.
> 

hm... maybe you are reading too much into this specific feature - its a 
"notify me, the application, if I asked you to do something that violates 
my previous request to be isolated", rather than "notify me whenever isolation is broken".

Does that make more sense?

Thanks,
Gilad--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
