From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 1/2] clone3: add CLONE_CLEAR_SIGHAND
Date: Mon, 21 Oct 2019 21:40:59 +0200
Message-ID: <20191021194058.pwgiyu4za2srdfau@wittgenstein>
References: <20191014104538.3096-1-christian.brauner@ubuntu.com>
 <20191021144633.GA2720@redhat.com>
 <20191021151255.GA3459@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191021151255.GA3459@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, libc-alpha@sourceware.org, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Elena Reshetova <elena.reshetova@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>Al Viro <v>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 21, 2019 at 05:12:55PM +0200, Oleg Nesterov wrote:
> On 10/21, Oleg Nesterov wrote:
> >
> > On 10/14, Christian Brauner wrote:
> > >
> > > The child helper process on Linux posix_spawn must ensure that no signal
> > > handlers are enabled, so the signal disposition must be either SIG_DFL
> > > or SIG_IGN. However, it requires a sigprocmask to obtain the current
> > > signal mask and at least _NSIG sigaction calls to reset the signal
> > > handlers for each posix_spawn call
> >
> > Plus the caller has to block/unblock all signals around clone(VM|VFORK).
>        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> just in case... I meant that posix_spawn() has to block/unblock, not its
> caller.

Yeah, I think that is what's currently happening.

Christian
