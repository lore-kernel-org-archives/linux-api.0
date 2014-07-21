From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 22:16:37 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407212025130.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com> <CFF29A00.9D44A%dvhart@linux.intel.com> <CFF29E4A.9D44E%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CFF29E4A.9D44E%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 21 Jul 2014, Darren Hart wrote:
> We observed some significant improvements under some very specific use
> cases, but a more thorough dive into performance impact in the other cases
> as well as security implications with the vdso is still wanting.

The security implication is that the feature can only be available for
process private futexes. There is no way to expose information which
crosses the process spaces.

But the way worse issue is storage.

While you can cache the namespace specific TID of a thread in the
task_struct, you still need a O(1) zero overhead mechanism to update
the thread state (only on/off cpu is interesting) in a per process
shared data structure from the guts of schedule()

For that you have basically two choices:

1) cpu_thread_id[NR_CPUS]

   Simple to update from the scheduler, and a halfways moderate
   storage size (NR_CPUS * 4 bytes) in the worst case, i.e. 16k
   today. Set to 0 on scheduling out and to the namespace specific TID
   on scheduling in.

   But that requires a linear search in the user space spin loop. And
   that's required for every iteration of the loop. Can you imagine
   how well that works performance wise?

2) Bitmap threads_on_cpu
   
   Again, simple to update from the scheduler, cache line bouncing
   issues aside. Clear the bit on schedule out and set it on schedule
   in.

   But the bitmap needs the size of PID_MAX_LIMIT, which is a whopping
   512k per process in the worst case.

Anything else would involve search/lookup schemes which are just
overkill in both the scheduler and the user space loop.
   
Now for enhanced fun you need immutable pages for that storage, as you
can't have pagefaults in the guts of schedule().

So once you found a way to make that opt-in as you don't want inflict
any of this to all processes by default, it might be a worthwhile
optimization. So the probably tolerable impact on schedule() would be

schedule_out()
	if (curr->threads_on_cpu)
		clear_bit(curr->ns_tid, curr->threads_on_cpu);
and

schedule_in()
	if (curr->threads_on_cpu)
		clear_bit(curr->ns_tid, curr->threads_on_cpu);

Anything more complex is just going to defeat the whole purpose.

Thanks,

	tglx
