From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v8 06/14] task_isolation: provide strict mode
 configurable signal
Date: Tue, 20 Oct 2015 21:41:33 -0400
Message-ID: <20151020214133.7e5a4324@grimm.local.home>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
	<1445373372-6567-7-git-send-email-cmetcalf@ezchip.com>
	<20151020205610.51b3d742@grimm.local.home>
	<5626EABC.9060202@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5626EABC.9060202@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 20 Oct 2015 21:30:36 -0400
Chris Metcalf <cmetcalf@ezchip.com> wrote:

> On 10/20/2015 8:56 PM, Steven Rostedt wrote:
> > On Tue, 20 Oct 2015 16:36:04 -0400
> > Chris Metcalf <cmetcalf@ezchip.com> wrote:
> >
> >> Allow userspace to override the default SIGKILL delivered
> >> when a task_isolation process in STRICT mode does a syscall
> >> or otherwise synchronously enters the kernel.
> >>
> > Is this really a good idea? This means that there's no way to terminate
> > a task in this mode, even if it goes astray.
> 
> It doesn't map SIGKILL to some other signal unconditionally.  It just allows
> the "hey, you broke the STRICT contract and entered the kernel" signal
> to be something besides the default SIGKILL.
> 

Ah, I misread the change log. Now looking at the actual code, it makes
sense. Sorry for the noise ;-)

-- Steve
