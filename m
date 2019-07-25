From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 4/5] pidfd: add CLONE_WAIT_PID
Date: Thu, 25 Jul 2019 18:56:57 +0200
Message-ID: <20190725165656.pbtmtm3hxxmj4aq6@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io>
 <20190724144651.28272-5-christian@brauner.io>
 <20190725103543.GF4707@redhat.com>
 <20190725104006.7myahvjtnbcgu3in@brauner.io>
 <20190725112503.GG4707@redhat.com>
 <20190725114359.GH4707@redhat.com>
 <20190725122650.4i3arct5rpchqmyt@brauner.io>
 <20190725161316.GI4707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190725161316.GI4707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, joel@joelfernandes.org, tglx@linutronix.de, tj@kernel.org, dhowells@redhat.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, cyphar@cyphar.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, kernel-team@android.com, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Jul 25, 2019 at 06:13:17PM +0200, Oleg Nesterov wrote:
> On 07/25, Christian Brauner wrote:
> >
> > The key is that you want to be able to create child processes in a
> > shared library without the main programing having to know about this so
> > that it can use P_ALL and never get stuff from the library.
> 
> OK, thanks...
> 
> in this case you should probablu pass 0 in CSIGNAL to ensure that the main
> program won't be notified when that child exits.

Yes, that's the idea. So you'd turn off SIGCHLD and rely on pidfd polling
only. That's similar to how pdfork() on FreeBSD works. It's just that we
need to do:
struct clone_args args = {
	.exit_signal = 0,
	.flags = CLONE_PIDFD | CLONE_WAIT_PID,
};
Now the shared library can guarantee that noone else in the mainloop
gets woken by a SIGCHLD from the pidfd-based helper process (because
exit_signal is 0) but afaict it also needs CLONE_WAIT_PID. Since the
latter allows it to guarantee that if someone in the mainloop gets
SIGCHLD from another regular process and calls waitid(P_ALL) it won't
accidently reap a pidfd-based process that has exited.

Fyi, I'm splitting CLONE_WAIT_PID out into a separate patchset and only
keep P_PIDFD for now. So we can discuss this independently. You think
that's better Oleg?

Christian
