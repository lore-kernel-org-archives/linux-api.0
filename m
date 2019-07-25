From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Thu, 25 Jul 2019 12:21:56 +0200
Message-ID: <20190725102156.nqnngsrb6dwmyztb@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-3-christian@brauner.io>
 <20190725101626.GD4707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725101626.GD4707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 25, 2019 at 12:16:27PM +0200, Oleg Nesterov wrote:
> On 07/24, Christian Brauner wrote:
> >
> > +SYSCALL_DEFINE6(pidfd_wait, int, pidfd, int __user *, stat_addr,
> > +		siginfo_t __user *, info, struct rusage __user *, ru,
> > +		unsigned int, states, unsigned int, flags)
> > +{
> 
> Oh, I too think that P_PIDFD makes more sense.

I have already updated the patch to introduce P_PIDFD.

> 
> and could you explain in the changelog why? I am not arguing and if
> nothing else this is consistent with other pidfd features, but if you
> are parent/debugger you can't hit the problem with pid-reuse, unless
> you races with your sub-threads.

One of the things is that later on this will allow us to make it
possible to retrieve the exit status via waitid(P_PIDFD) for non-parent
processes if handed a _suitable_ pidfd that has this feature set. Maybe
even - if safe - make it possible to wait on a process as a non-parent.
And some tools just really want to do away with pids completely.

Christian
