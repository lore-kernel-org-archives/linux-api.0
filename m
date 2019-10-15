From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] pidfd: verify task is alive when printing fdinfo
Date: Tue, 15 Oct 2019 16:43:57 +0200
Message-ID: <20191015144356.GA16978@redhat.com>
References: <20191015141332.4055-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191015141332.4055-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Christian Kellner <christian@kellner.me>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>, linux-kselftest@vger.kernel.org, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/15, Christian Brauner wrote:
>
> +static inline bool task_alive(struct pid *pid)
> +{
> +	bool alive = true;
> +
> +	rcu_read_lock();
> +	if (!pid_task(pid, PIDTYPE_PID))
> +		alive = false;
> +	rcu_read_unlock();
> +
> +	return alive;
> +}

Well, the usage of rcu_read_lock/unlock looks confusing to me...

I mean, this helper does not need rcu lock at all. Except
rcu_dereference_check() will complain.

	static inline bool task_alive(struct pid *pid)
	{
		bool alive;

		/* shut up rcu_dereference_check() */
		rcu_lock_acquire(&rcu_lock_map);
		alive = !!pid_task(pid, PIDTYPE_PID));
		rcu_lock_release(&rcu_lock_map);

		return alive;
	}

looks more clear imo.

But in fact I'd suggest to simply use !hlist_empty(&pid->tasks[PIDTYPE_PID])
in pidfd_show_fdinfo() and do not add a new helper.

Oleg.
