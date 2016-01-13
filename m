From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v9 00/13] support "task_isolation" mode for nohz_full
Date: Wed, 13 Jan 2016 16:19:56 -0500
Message-ID: <5696BF7C.2080800@ezchip.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <56941B86.9090009@ezchip.com> <20160112100708.GA15737@arm.com>
 <56953CBA.9090208@ezchip.com> <20160113104453.GB9854@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160113104453.GB9854@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/13/2016 05:44 AM, Ingo Molnar wrote:
> * Chris Metcalf <cmetcalf@ezchip.com> wrote:
>
>> (Adding Mark to cc's)
>>
>> On 01/12/2016 05:07 AM, Will Deacon wrote:
>>> On Mon, Jan 11, 2016 at 04:15:50PM -0500, Chris Metcalf wrote:
>>>> Ping!  There has been no substantive feedback to this version of
>>>> the patch in the week since I posted it, which optimistically suggests
>>>> to me that people may be satisfied with it.  If that's true, Frederic,
>>>> I assume this would be pulled into your tree?
>>>>
>>>> I have slightly updated the v9 patch series since this posting:
>>>>
>>>> [...]
>>>>
>>>> - Incorporated Mark Rutland's changes to convert arm64
>>>>    assembly to C code instead of using my own version.
>>> Please avoid queuing these patches -- the first is already in the arm64
>>> queue for 4.5 and the second was found to introduce a substantial
>>> performance regression on the syscall entry/exit path. I think Mark had
>>> an updated version to address that, so it would be easier not to have
>>> an old version sitting in some other queue!
>> I am not formally queueing them anywhere (like linux-next), though
>> now that you mention it, that's a pretty good idea - I'll talk to Steven
>> about that, assuming this merge window closes without the task
>> isolation stuff going in.
> NAK. Given the controversy, no way should this stuff go outside the primary trees
> it affects: the scheduler, timer, irq, etc. trees.

Fair enough.  I'll plan to do v10 once the merge window closes.

Mark, let me know when/if you get a new version of the de-asm stuff
for do_notify_resume() - thanks.  Or, would it be helpful if I worked up
the option I suggested, where we check the thread_info flags in the
assembly code before calling out to the new loop in do_notify_resume()?

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

