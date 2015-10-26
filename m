From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Mon, 26 Oct 2015 17:13:05 -0400
Message-ID: <562E9761.1060601@ezchip.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWzhrYreizoKG0w6Jtz3RLFjNx9Qk_JLykcLLUQcCXBEA@mail.gmail.com>
 <5626B00E.3010309@ezchip.com>
 <CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ@mail.gmail.com>
 <20151020202929.485a1ef0@grimm.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151020202929.485a1ef0@grimm.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Andy Lutomirski <luto@amacapital.net>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/20/2015 08:29 PM, Steven Rostedt wrote:
> Also, doesn't RCU need to have a few ticks go by before it can safely
> disable itself from userspace? I recall something like that. Paul?

The current patch series supports that by testing tick_nohz_tick_stopped(),
which internally only becomes true after tick_nohz_stop_sched_tick()
manages to stop the tick, and it won't if rcu_needs_cpu() is true.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
