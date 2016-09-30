From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Fri, 30 Sep 2016 13:07:33 -0400
Message-ID: <bf7ccfa0-f05f-913b-0810-de7aecce2d7f@mellanox.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
 <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
 <20160927143511.GD6242@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160927143511.GD6242@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 9/27/2016 10:35 AM, Frederic Weisbecker wrote:
> On 8/16/2016 5:19 PM, Chris Metcalf wrote:
>>> Here is a respin of the task-isolation patch set.
>>>
>>> Again, I have been getting email asking me when and where this patch
>>> will be upstreamed so folks can start using it.  I had been thinking
>>> the obvious path was via Frederic Weisbecker to Ingo as a NOHZ kind of
>>> thing.  But perhaps it touches enough other subsystems that that
>>> doesn't really make sense?  Andrew, would it make sense to take it
>>> directly via your tree?  Frederic, Ingo, what do you think?
> As it seems we are still debating a lot of things in this patchset that has already
> reached v15, I think you should split it in smaller steps in order to move forward
> and only get into the next step once the previous is merged.
>
> You could start with a first batch that introduces the prctl() and does the best effort
> one-shot isolation part. Which means the actions that only need to be performed once
> on the prctl call.

So combining this with my reply a moment ago to Andy about just
disabling all deferrable work creation on task isolation cores, that
means we just need a way of checking that the dyntick is off on return
from the prctl.

We could do this in the prctl() itself, but it feels a bit fragile, since
we could do the check for no dyntick and try to return success,
and then some kind of interrupt and/or schedule event might happen
and by the time we actually got back to userspace the dyntick might
be running again.

I think what we can do is arrange to set a bit in the process state
that says we are returning from prctl, and then right as we are
returning to userspace with interrupts disabled, we can check if
that bit is set, and if so check at that point to see if the dyntick
is enabled, and if it is, force the syscall return value to EAGAIN
(and clear the bit regardless).

Within the prctl() code itself, we check for hard prerequisites like being on
a task-isolation cpu, and fail -EINVAL if not.

The upshot is that we end up spinning on a loop through userspace where
we keep retrying the prctl() until the timer quiesces.

> Once we get that merged we can focus on what needs to be performed on every return
> to userspace if that's really needed. Including possibly waiting on some completion.

So in NOSIG mode, instead of setting EAGAIN in the return to
userspace path, we arrange to just wait.  We can figure out in a
follow-on patch whether we want to wait by spinning in some way
or by actually waiting on a completion.  For now I'll just include the
remainder of the patch (with spinning) as an RFC just so people
can have the next piece to look ahead to, but I like your idea of
breaking it out of the main patch series entirely.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

