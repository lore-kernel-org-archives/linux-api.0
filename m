From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Mon, 29 Aug 2016 12:27:06 -0400
Message-ID: <d00bbe64-6e2c-51ce-1dfb-72ef1c4a04fa@mellanox.com>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 8/16/2016 5:19 PM, Chris Metcalf wrote:
> Here is a respin of the task-isolation patch set.
>
> Again, I have been getting email asking me when and where this patch
> will be upstreamed so folks can start using it.  I had been thinking
> the obvious path was via Frederic Weisbecker to Ingo as a NOHZ kind of
> thing.  But perhaps it touches enough other subsystems that that
> doesn't really make sense?  Andrew, would it make sense to take it
> directly via your tree?  Frederic, Ingo, what do you think?

Ping!

No concerns have been raised yet with the v15 version of the patch series
in the two weeks since I posted it, and I think I have addressed all
previously-raised concerns (or perhaps people have just given up arguing
with me).

I did add Catalin's Reviewed-by to 08/13 (thanks!) and updated my
kernel.org repo.

Does this feel like something we can merge when the 4.9 merge window opens?
If so, whose tree is best suited for it?  Or should I ask Stephen to put it into
linux-next now and then ask Linus to merge it directly?  I recall Ingo thought
this was a bad idea when I suggested it back in January, but I'm not sure where
we got to in terms of a better approach.

Thanks all!

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com

