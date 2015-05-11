From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Mon, 11 May 2015 15:15:22 -0700
Message-ID: <CALCETrX64NqYjZ=Sp4DcVrek6sbOvApnbhj8uGtZE3-KgkPY=w@mail.gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
 <20150508172210.559830a9@gandalf.local.home> <554D428E.6020702@ezchip.com>
 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
 <20150509070538.GA9413@gmail.com> <CALCETrXavog018+xLacXeBLaMLjWtqk0bMU5fUzZ+pkwgu7Y3A@mail.gmail.com>
 <555108FC.3060200@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555108FC.3060200-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On May 12, 2015 4:54 AM, "Chris Metcalf" <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
>
> (Oops, resending and forcing html off.)
>
>
> On 05/09/2015 03:19 AM, Andy Lutomirski wrote:
>>
>> Naming aside, I don't think this should be a per-task flag at all.  We
>> already have way too much overhead per syscall in nohz mode, and it
>> would be nice to get the per-syscall overhead as low as possible.  We
>> should strive, for all tasks, to keep syscall overhead down*and*
>> avoid as many interrupts as possible.
>>
>> That being said, I do see a legitimate use for a way to tell the
>> kernel "I'm going to run in userspace for a long time; stay away".
>> But shouldn't that be a single operation, not an ongoing flag?  IOW, I
>> think that we should have a new syscall quiesce() or something rather
>> than a prctl.
>
>
> Yes, if all you are concerned about is quiescing the tick, we could
> probably do it as a new syscall.
>
> I do note that you'd want to try to actually do the quiesce as late as
> possible - in particular, if you just did it in the usual syscall, you
> might miss out on a timer that is set by softirq, or even something
> that happened when you called schedule() on the syscall exit path.
> Doing it as late as we are doing helps to ensure that that doesn't
> happen.  We could still arrange for this semantics by having a new
> quiesce() syscall set a temporary task bit that was cleared on
> return to userspace, but as you pointed out in a different email,
> that gets tricky if you end up doing multiple user_exit() calls on
> your way back to userspace.

We should fix that, then.  A quiesce() syscall can certainly arrange
to clean up on final exit.

>
> More to the point, I think it's actually important to know when an
> application believes it's in userspace-only mode as an actual state
> bit, rather than just during its transitional moment.

We can do that, too, with a new flag that's cleared on the next entry.

>  If an
> application calls the kernel at an unexpected time (third-party code
> is the usual culprit for our customers, whether it's syscalls, page
> faults, or other things) we would prefer to have the "quiesce"
> semantics stay in force and cause the third-party code to be
> visibly very slow, rather than cause a totally unexpected and
> hard-to-diagnose interrupt show up later as we are still going
> around the loop that we thought was safely userspace-only.

I'm not really convinced that we should design this feature around
ease of debugging userspace screwups.  There are already plenty of
ways to do that part.  Userspace getting an interrupt because
userspace accidentally did a syscall is very different from userspace
getting interrupted due to an IPI.

>
> And, for debugging the kernel, it's crazy helpful to have that state
> bit in place: see patch 6/6 in the series for how we can diagnose
> things like "a different core just queued an IPI that will hit a
> dataplane core unexpectedly".  Having that state bit makes this sort
> of thing a trivial check in the kernel and relatively easy to debug.

As above, this can be done with a one-time operation, too.

>
> Finally, I proposed a "strict" mode in patch 5/6 where we kill the
> process if it voluntarily enters the kernel by mistake after saying it
> wasn't going to any more.  To do this requires a state bit, so
> carrying another state bit for "quiesce on user entry" seems pretty
> reasonable.

I still dislike that in the form you chose.  It's too deadly to be
useful for anyone but the hardest RT users.

I think I'd be okay with variants, though: let a suitably privileged
process ask for a signal on inadvertent kernel entry or rig up an fd
to be notified when one of these bad entries happens.  Queueing
something to a pollable fd would work, too.

See that thread for more comments.

--Andy
