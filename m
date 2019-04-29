From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v1 1/2] Add polling support to pidfd
Date: Mon, 29 Apr 2019 12:32:59 -0400
Message-ID: <20190429163259.GA201155@google.com>
References: <20190425190010.46489-1-joel@joelfernandes.org>
 <20190425222359.sqhboc4x4daznr6r@brauner.io>
 <20190428162405.GA6757@redhat.com>
 <20190429140245.GB233442@google.com>
 <20190429142030.GA17715@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429142030.GA17715@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, dancol@google.com, sspatil@google.com, jannh@google.com, surenb@google.com, timmurray@google.com, Jonathan Kowalski <bl0pbl33p@gmail.com>, torvalds@linux-foundation.org, kernel-team@android.com, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>, linux-kselftest@vger.kernel.org, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Serge Hallyn <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Gleixner <tgl>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 29, 2019 at 04:20:30PM +0200, Oleg Nesterov wrote:
> On 04/29, Joel Fernandes wrote:
> >
> > However, in your code above, it is avoided because we get:
> >
> > Task A (poller)		Task B (exiting task being polled)
> > ------------            ----------------
> > poll() called
> > add_wait_queue()
> > 			exit_state is set to non-zero
> > read exit_state
> > remove_wait_queue()
> > 			wake_up_all()
> 
> just to clarify... No, sys_poll() path doesn't do remove_wait_queue() until
> it returns to user mode, and that is why we can't race with set-exit_code +
> wake_up().

I didn't follow what you mean, the removal from the waitqueue happens in
free_poll_entry() called from poll_freewait() which happens from
do_sys_poll() which is before the syscall returns to user mode. Could you
explain more?

> pidfd_poll() can race with the exiting task, miss exit_code != 0, and return
> zero. However, do_poll() won't block after that and pidfd_poll() will be called
> again.

Here also I didn't follow what you mean. If exit_code is read as 0 in
pidfd_poll(), then in do_poll() the count will be 0 and it will block in
poll_schedule_timeout(). Right? But above you're saying it wont block.
Also if you could show a timing diagram of this different race you're talking
about, that will make things clear. It is a bit hard for me to picture
otherwise.

Also, I will use task_pid() for getting the pid from the task, as you suggest
in the other thread.

thanks,

- Joel
