From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] pidfd: verify task is alive when printing fdinfo
Date: Tue, 15 Oct 2019 17:43:27 +0200
Message-ID: <20191015154327.GB16978@redhat.com>
References: <20191015141332.4055-1-christian.brauner@ubuntu.com>
 <20191015144356.GA16978@redhat.com>
 <20191015145646.72eqrw6j52ehvfn2@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191015145646.72eqrw6j52ehvfn2@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Elena Reshetova <elena.reshetova@intel.com>, Christian Kellner <christian@kellner.me>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>, "Dmitry V. Levin" <ldv@altlinux.org>, linux-kselftest@vger.kernel.org, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/15, Christian Brauner wrote:
>
> On Tue, Oct 15, 2019 at 04:43:57PM +0200, Oleg Nesterov wrote:
> > But in fact I'd suggest to simply use !hlist_empty(&pid->tasks[PIDTYPE_PID])
> > in pidfd_show_fdinfo() and do not add a new helper.
>
> Sounds good to me. But can't we then just do something similar just with
> !hlist_empty(&pid->tasks[PIDTYPE_TGID])
>
> in v5.4-rc3:kernel/pid.c:pidfd_open():514-517 ?

Agreed. Actually, it seems to me I suggested to use rcu_lock_acquire() rather
than rcu_read_lock() in pidfd_open() too.

But hlist_empty(pid->tasks[type]) looks even better.

If you decide to add a new helper, you can also change do_wait() which checks
hlist_empty(&wo->wo_pid->tasks[wo->wo_type]). May be even __change_pid().

Oleg.
