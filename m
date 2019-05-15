From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 1/2] pid: add pidfd_open()
Date: Wed, 15 May 2019 16:49:28 +0200
Message-ID: <20190515144927.f2yxyi6w6lhn3xx7@brauner.io>
References: <20190515100400.3450-1-christian@brauner.io>
 <20190515143857.GB18892@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190515143857.GB18892@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: jannh@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, arnd@arndb.de, dhowells@redhat.com, akpm@linux-foundation.org, cyphar@cyphar.com, ebiederm@xmission.com, elena.reshetova@intel.com, keescook@chromium.org, luto@amacapital.net, luto@kernel.org, tglx@linutronix.de, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 15, 2019 at 04:38:58PM +0200, Oleg Nesterov wrote:
> On 05/15, Christian Brauner wrote:
> >
> > +SYSCALL_DEFINE2(pidfd_open, pid_t, pid, unsigned int, flags)
> > +{
> > +	int fd, ret;
> > +	struct pid *p;
> > +	struct task_struct *tsk;
> > +
> > +	if (flags)
> > +		return -EINVAL;
> > +
> > +	if (pid <= 0)
> > +		return -EINVAL;
> > +
> > +	p = find_get_pid(pid);
> > +	if (!p)
> > +		return -ESRCH;
> > +
> > +	rcu_read_lock();
> > +	tsk = pid_task(p, PIDTYPE_PID);
> 
> You do not need find_get_pid() before rcu_lock and put_pid() at the end.
> You can just do find_vpid() under rcu_read_lock().

Will do.

> 
> > +	if (!tsk)
> > +		ret = -ESRCH;
> > +	else if (unlikely(!thread_group_leader(tsk)))
> > +		ret = -EINVAL;
> 
> it seems that you can do a single check
> 
> 	tsk = pid_task(p, PIDTYPE_TGID);
> 	if (!tsk)
> 		ret = -ESRCH;
> 
> this even looks more correct if we race with exec changing the leader.

The logic here being that you can only reach the thread_group leader
from struct pid if PIDTYPE_PID == PIDTYPE_TGID for this struct pid?

Thanks, Oleg.
Christian
