From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit
 notification via fd
Date: Sat, 14 Mar 2015 15:09:05 -0700
Message-ID: <20150314220905.GJ22130@thin>
References: <cover.1426180120.git.josh@joshtriplett.org>
 <9c39c576e1d9a9912b4aec54d833a73a84d2f592.1426180120.git.josh@joshtriplett.org>
 <20150313162113.GA25966@redhat.com>
 <20150313195707.GA10487@cloud>
 <20150314141414.GA11062@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150314141414.GA11062@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 03:14:14PM +0100, Oleg Nesterov wrote:
> Again, again, I didn't read this series yet. But the proper solution (afaics)
> should move this "autoreap" check in release_task/__ptrace_detach(). If the
> task is traced. Debugger should check ->autoreap and skip another
> do_notify_parent().

As mentioned in the mail I just sent, I think I can just move the
autoreap handling *into* do_notify_parent, and treat it as though the
parent had SA_NOCLDWAIT set.

> Speaking of autoreap... If ->exit_signal is zero, then the exiting child
> doesn't send the notification to its parent, still it doesn't autoreap
> itself. To me this looks strange, and in fact it seems to me that this
> is only by mistake. I am wondering if we can treat ->exit_signal == 0
> as "autoreap" too. As usual, most probably the answer is "no, because it
> is too late to change the historical behaviour". But this is off-topic.

Historical behavior, and potentially sensible behavior; you might not
want notification, but you might still want to get the child's exit
status by calling wait, which means you need the process to stick around
as a zombie until you wait on it.

That'd be the main advantage of adding a CLONE_AUTOREAP flag: it allows
you to get the same autoreaping behavior you'd get if you had SIGCHLD
ignored, but without actually sending a signal and without caring how
the process-wide signal handling is set up.  So you'd pass a 0 signal,
and CLONE_AUTOREAP.  And then if you *want* the exit notification, you
can get it via the file descriptor.

- Josh Triplett
