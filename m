From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task
	exit notification via fd
Date: Sat, 14 Mar 2015 21:30:29 +0100
Message-ID: <20150314203029.GA11656@redhat.com>
References: <cover.1426180120.git.josh@joshtriplett.org> <20150314141414.GA11062@redhat.com> <20150314143235.GA12086@redhat.com> <28025621.k7WkrfHd4d@tjmaciei-mobl4> <20150314190132.GB22130@thin> <20150314191836.GA8416@redhat.com> <20150314194721.GA9654@redhat.com> <20150314201402.GH22130@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150314201402.GH22130@thin>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 03/14, Josh Triplett wrote:
>
> What I was proposing was that a task that isn't yet dead, but that is
> going to be autoreaped, is not eligible for waiting either.  All the
> various wait* familiy of system calls should pretend it doesn't exist at
> all, because returning an autoreaped task from a wait* call introduces a
> race condition if the parent tries to *do* anything with the returned
> PID.  If you launch a process with CLONE_FD, you need to manage it
> exclusively with that fd, not with the wait* family of system calls.
>
> That also implies that the child-stop and child-continued mechanisms
> (do_notify_parent_cldstop, WSTOPPED, WCONTINUED) should ignore the task
> too.  In the future there could be a flag to clone4 that lets you get
> stop and continue notifications through the file descriptor.

So far I strongly disagree, and I think that "autoreap" feature should
not depend on CLONE_FD.

However, as I already said, perhaps something like W_IGNORE_AUTOREAP
for wait* makes sense.

Plus we should also discuss the reparenting. Ok, let me leave this
discussion until I read 0/4 at least.

Oleg.

