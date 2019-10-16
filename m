From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/5] pidfd: verify task is alive when printing fdinfo
Date: Wed, 16 Oct 2019 18:24:09 +0200
Message-ID: <20191016162408.GB31585@redhat.com>
References: <20191015141332.4055-1-christian.brauner@ubuntu.com>
 <20191016153606.2326-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191016153606.2326-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, christian@kellner.me, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, jannh@google.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, shuah@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 10/16, Christian Brauner wrote:
>
> +static inline bool task_alive(struct pid *pid, enum pid_type type)
> +{
> +	return !hlist_empty(&pid->tasks[type]);
> +}

So you decided to add a helper ;) OK, but note that its name is very
confusing and misleading. Even more than pid_alive() we already have.

What does "alive" actually mean? Say, task_alive(pid, PIDTYPE_SID) == F
after fork(). Then it becomes T if this task does setsid().

And why task_ if it accepts pid+pid_type? May be pid_has_task() or
something like this...

OK, since I can't suggest a better name I won't really argue. Feel free
to add my reviewed-by to this series.

Oleg.
