From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 4/6] nohz: support PR_DATAPLANE_QUIESCE
Date: Tue, 12 May 2015 21:35:25 -0700
Message-ID: <CALCETrXGb1_JXLBb62KU=Hb8FZfCuRT1e60xW2KTBEPsYiaAXg@mail.gmail.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <1431107927-13998-5-git-send-email-cmetcalf@ezchip.com> <20150512093349.GH21418@twins.programming.kicks-ass.net>
 <20150512095030.GD11477@gmail.com> <20150512103805.GJ21418@twins.programming.kicks-ass.net>
 <20150512125200.GB17244@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150512125200.GB17244@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Metcalf <cmetcalf@ezchip.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 5:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> > So if then a prctl() (or other system call) could be a shortcut
>> > to:
>> >
>> >  - move the task to an isolated CPU
>> >  - make sure there _is_ such an isolated domain available
>> >
>> > I.e. have some programmatic, kernel provided way for an
>> > application to be sure it's running in the right environment.
>> > Relying on random administration flags here and there won't cut
>> > it.
>>
>> No, we already have sched_setaffinity() and we should not duplicate
>> its ability to move tasks about.
>
> But sched_setaffinity() does not guarantee isolation - it's just a
> syscall to move a task to a set of CPUs, which might be isolated or
> not.
>
> What I suggested is that it might make sense to offer a system call,
> for example a sched_setparam() variant, that makes such guarantees.
>
> Say if user-space does:
>
>         ret = sched_setscheduler(0, BIND_ISOLATED, &isolation_params);
>
> ... then we would get the task moved to an isolated domain and get a 0
> return code if the kernel is able to do all that and if the current
> uid/namespace/etc. has the required permissions and such.
>
> ( BIND_ISOLATED will not replace the current p->policy value, so it's
>   still possible to use the regular policies as well on top of this. )

I think we shouldn't have magic selection of an isolated domain.
Anyone using this has already configured some isolated CPUs and
probably wants to choose the CPU and, especially, NUMA node
themselves.  Also, maybe it should be a special type of realtime
class/priority -- doing this should require RT permission IMO.

--Andy
