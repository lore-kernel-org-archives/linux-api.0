From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v9 00/13] support "task_isolation" mode for nohz_full
Date: Tue, 12 Jan 2016 10:07:09 +0000
Message-ID: <20160112100708.GA15737@arm.com>
References: <1451936091-29247-1-git-send-email-cmetcalf@ezchip.com>
 <56941B86.9090009@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56941B86.9090009@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 11, 2016 at 04:15:50PM -0500, Chris Metcalf wrote:
> Ping!  There has been no substantive feedback to this version of
> the patch in the week since I posted it, which optimistically suggests
> to me that people may be satisfied with it.  If that's true, Frederic,
> I assume this would be pulled into your tree?
> 
> I have slightly updated the v9 patch series since this posting:
> 
> - Incorporated a fix to initialize cpu_isolation_mask early if no
>   cpu_isolation= boot argument was given, to avoid crashing on
>   CPUMASK_OFFSTACK platforms.
> 
> - Incorporated Mark Rutland's changes to convert arm64
>   assembly to C code instead of using my own version.

Please avoid queuing these patches -- the first is already in the arm64
queue for 4.5 and the second was found to introduce a substantial
performance regression on the syscall entry/exit path. I think Mark had
an updated version to address that, so it would be easier not to have
an old version sitting in some other queue!

Cheers,

Will
