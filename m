From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v1 1/2] Add polling support to pidfd
Date: Tue, 30 Apr 2019 14:07:59 +0200
Message-ID: <20190430120759.GC23020@redhat.com>
References: <20190425190010.46489-1-joel@joelfernandes.org>
 <20190425222359.sqhboc4x4daznr6r@brauner.io>
 <20190428162405.GA6757@redhat.com>
 <20190429140245.GB233442@google.com>
 <20190429142030.GA17715@redhat.com>
 <20190429163259.GA201155@google.com>
 <20190430115332.GB23020@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190430115332.GB23020@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, dancol@google.com, sspatil@google.com, jannh@google.com, surenb@google.com, timmurray@google.com, Jonathan Kowalski <bl0pbl33p@gmail.com>, torvalds@linux-foundation.org, kernel-team@android.com, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>, linux-kselftest@vger.kernel.org, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Serge Hallyn <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Gleixner <tgl>
List-Id: linux-api@vger.kernel.org

On 04/30, Oleg Nesterov wrote:
>
> > > pidfd_poll() can race with the exiting task, miss exit_code != 0, and return
> > > zero. However, do_poll() won't block after that and pidfd_poll() will be called
> > > again.
> >
> > Here also I didn't follow what you mean. If exit_code is read as 0 in
> > pidfd_poll(), then in do_poll() the count will be 0 and it will block in
> > poll_schedule_timeout(). Right?
>
> No. Please note the pwq->triggered check and please read __pollwake().
>
> But if you want to understand this you can forget about poll/select. It is
> a bit complicated, in particular because it has to do set_current_state()
> right  before schedule() and thus it plays games with pwq->triggered. But in
> essence this doesn't differ too much from the plain wait_event-like code
> (although you can also look at wait_woken/woken_wake_function).
>
> If remove_wait_queue() could happem before wake_up_all() (like in your pseudo-
> code above), then pidfd_poll() or any other ->poll() method could miss _both_
> the condition and wakeup. But sys_poll() doesn't do this, so it is fine to miss
> the condition and rely on wake_up_all() which ensures we won't block and the
> next iteration must see condition == T.

Oh, just in case... If it is not clear, of course I am talking about the case
when wake_up_call() was already called when we check the condition. Otherwise
everything is simple.

Oleg.
