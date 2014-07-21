From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Mon, 21 Jul 2014 23:43:53 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407212341290.20847@nanos>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com> <8761iq3bp3.fsf@tassilo.jf.intel.com> <871tte3bjw.fsf@tassilo.jf.intel.com> <CFF29A00.9D44A%dvhart@linux.intel.com> <CFF29E4A.9D44E%dvhart@linux.intel.com> <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20140721212740.GS3935@laptop>
Sender: linux-doc-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>
List-Id: linux-api@vger.kernel.org



On Mon, 21 Jul 2014, Peter Zijlstra wrote:

> On Mon, Jul 21, 2014 at 10:16:37PM +0200, Thomas Gleixner wrote:
> > On Mon, 21 Jul 2014, Darren Hart wrote:
> > > We observed some significant improvements under some very specific use
> > > cases, but a more thorough dive into performance impact in the other cases
> > > as well as security implications with the vdso is still wanting.
> > 
> > The security implication is that the feature can only be available for
> > process private futexes. There is no way to expose information which
> > crosses the process spaces.
> > 
> > But the way worse issue is storage.
> > 
> > While you can cache the namespace specific TID of a thread in the
> > task_struct, you still need a O(1) zero overhead mechanism to update
> > the thread state (only on/off cpu is interesting) in a per process
> > shared data structure from the guts of schedule()
> > 
> > For that you have basically two choices:
> > 
> > 1) cpu_thread_id[NR_CPUS]
> > 
> >    Simple to update from the scheduler, and a halfways moderate
> >    storage size (NR_CPUS * 4 bytes) in the worst case, i.e. 16k
> >    today. Set to 0 on scheduling out and to the namespace specific TID
> >    on scheduling in.
> > 
> >    But that requires a linear search in the user space spin loop. And
> >    that's required for every iteration of the loop. Can you imagine
> >    how well that works performance wise?
> > 
> > 2) Bitmap threads_on_cpu
> >    
> >    Again, simple to update from the scheduler, cache line bouncing
> >    issues aside. Clear the bit on schedule out and set it on schedule
> >    in.
> > 
> >    But the bitmap needs the size of PID_MAX_LIMIT, which is a whopping
> >    512k per process in the worst case.
> > 
> > Anything else would involve search/lookup schemes which are just
> > overkill in both the scheduler and the user space loop.
> >    
> > Now for enhanced fun you need immutable pages for that storage, as you
> > can't have pagefaults in the guts of schedule().
> > 
> > So once you found a way to make that opt-in as you don't want inflict
> > any of this to all processes by default, it might be a worthwhile
> > optimization. So the probably tolerable impact on schedule() would be
> > 
> > schedule_out()
> > 	if (curr->threads_on_cpu)
> > 		clear_bit(curr->ns_tid, curr->threads_on_cpu);
> > and
> > 
> > schedule_in()
> > 	if (curr->threads_on_cpu)
> > 		clear_bit(curr->ns_tid, curr->threads_on_cpu);
> > 
> > Anything more complex is just going to defeat the whole purpose.
> 
> All this is predicated on the fact that syscalls are 'expensive'.
> Weren't syscalls only 100s of cycles? All this bitmap mucking is far
> more expensive due to cacheline misses, which due to the size of the
> things is almost guaranteed.

I completely agree.

This wants to backed by proper numbers taken from a proper
implementation and not from some randomly cobbled together works for
me hackery.

As I said: It might be a worthwhile optimization....

Thanks,

	tglx

