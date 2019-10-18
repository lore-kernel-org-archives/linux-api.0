From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v3 1/5] pidfd: check pid has attached task in fdinfo
Date: Fri, 18 Oct 2019 17:05:27 +0200
Message-ID: <20191018150526.mgmucts33p7gspqo@wittgenstein>
References: <20191016153606.2326-1-christian.brauner@ubuntu.com>
 <20191017101832.5985-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191017101832.5985-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: oleg@redhat.com, linux-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, christian@kellner.me, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, jannh@google.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, shuah@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Thu, Oct 17, 2019 at 12:18:28PM +0200, Christian Brauner wrote:
> Currently, when a task is dead we still print the pid it used to use in
> the fdinfo files of its pidfds. This doesn't make much sense since the
> pid may have already been reused. So verify that the task is still alive
> by introducing the pid_has_task() helper which will be used by other
> callers in follow-up patches.
> If the task is not alive anymore, we will print -1. This allows us to
> differentiate between a task not being present in a given pid namespace
> - in which case we already print 0 - and a task having been reaped.
> 
> Note that this uses PIDTYPE_PID for the check. Technically, we could've
> checked PIDTYPE_TGID since pidfds currently only refer to thread-group
> leaders but if they won't anymore in the future then this check becomes
> problematic without it being immediately obvious to non-experts imho. If
> a thread is created via clone(CLONE_THREAD) than struct pid has a single
> non-empty list pid->tasks[PIDTYPE_PID] and this pid can't be used as a
> PIDTYPE_TGID meaning pid->tasks[PIDTYPE_TGID] will return NULL even
> though the thread-group leader might still be very much alive. So
> checking PIDTYPE_PID is fine and is easier to maintain should we ever
> allow pidfds to refer to threads.
> 
> Cc: Jann Horn <jannh@google.com>
> Cc: Christian Kellner <christian@kellner.me>
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Applied this series to:
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=pidfd

Thanks!
Christian
