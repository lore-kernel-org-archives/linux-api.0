From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v16 00/13] support "task_isolation" mode
Date: Tue, 7 Nov 2017 11:10:02 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711071109090.19523@nuc-kabylake>
References: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1711060932520.9015@nuc-kabylake> <bd5526d4-7b6e-3b3d-79d0-5d6567c0bdf8@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bd5526d4-7b6e-3b3d-79d0-5d6567c0bdf8@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-mm@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 6 Nov 2017, Chris Metcalf wrote:

> On 11/6/2017 10:38 AM, Christopher Lameter wrote:
> > > What about that d*mn 1 Hz clock?
> > >
> > > It's still there, so this code still requires some further work before
> > > it can actually get a process into long-term task isolation (without
> > > the obvious one-line kernel hack).  Frederic suggested a while ago
> > > forcing updates on cpustats was required as the last gating factor; do
> > > we think that is still true?  Christoph was working on this at one
> > > point - any progress from your point of view?
> > Well if you still have the 1 HZ clock then you can simply defer the numa
> > remote page cleanup of the page allocator to that the time you execute
> > that tick.
>
> We have to get rid of the 1 Hz tick, so we don't want to tie anything
> else to it...

Yes we want to get rid of the 1 HZ tick but the work on that could also
include dealing with the remove page cleanup issue that we have deferred.

Presumably we have another context there were we may be able to call into
the cleanup code with interrupts enabled.
