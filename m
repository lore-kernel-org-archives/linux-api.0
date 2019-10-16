From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v2 1/5] pidfd: verify task is alive when printing fdinfo
Date: Wed, 16 Oct 2019 18:31:08 +0200
Message-ID: <20191016163107.5zwt6fmjyd5mkqqw@wittgenstein>
References: <20191015141332.4055-1-christian.brauner@ubuntu.com>
 <20191016153606.2326-1-christian.brauner@ubuntu.com>
 <20191016162408.GB31585@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191016162408.GB31585@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, christian@kellner.me, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, jannh@google.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, shuah@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Wed, Oct 16, 2019 at 06:24:09PM +0200, Oleg Nesterov wrote:
> On 10/16, Christian Brauner wrote:
> >
> > +static inline bool task_alive(struct pid *pid, enum pid_type type)
> > +{
> > +	return !hlist_empty(&pid->tasks[type]);
> > +}
> 
> So you decided to add a helper ;) OK, but note that its name is very
> confusing and misleading. Even more than pid_alive() we already have.

That's why I chose that name. This is the second time I get bitten by
taking inspiration from prior naming examples. :)

> 
> What does "alive" actually mean? Say, task_alive(pid, PIDTYPE_SID) == F
> after fork(). Then it becomes T if this task does setsid().

Yes, that annoyed me to. If you think about pidfd_open() you have a
similar problem. The question we are asking in pidfd_open() is not
task_alive() but rather was-this-pid-used-as.

> 
> And why task_ if it accepts pid+pid_type? May be pid_has_task() or
> something like this...

Given what I said above that might be a decent name.

> 
> OK, since I can't suggest a better name I won't really argue. Feel free
> to add my reviewed-by to this series.

No, naming is important. Thanks for being picky about that too and I'll
happily resend. :)

Thanks!
Christian
