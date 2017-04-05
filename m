From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][PATCH v2 1/5] ptrace: Don't wait in PTRACE_O_TRACEEXIT
        for exec or coredump
Date: Wed, 5 Apr 2017 18:19:32 +0200
Message-ID: <20170405161932.GE14536@redhat.com>
References: <20170303173326.GA17899@redhat.com> <87tw7axlr0.fsf@xmission.com> <87d1dyw5iw.fsf@xmission.com> <87tw7aunuh.fsf@xmission.com> <87lgsmunmj.fsf_-_@xmission.com> <20170304170312.GB13131@redhat.com> <8760ir192p.fsf@xmission.com> <878tnkpv8h.fsf_-_@xmission.com> <874ly6a0h1.fsf_-_@xmission.com> <87wpb28luj.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wpb28luj.fsf_-_@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <asarai@suse.com>, Andy Lutomirski <luto@amacapital.net>, Attila Fazekas <afazekas@redhat.com>, Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Ulrich Obergfell <uobergfe@redhat.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 04/02, Eric W. Biederman wrote:
>
> In the case of exec and coredump which have many interesting deadlock
> opportunities

So this patch is very close to my 2/2 one-liner, except

	- you removed the current->mm == current->parent->mm check

	  I didn't do this on purpose, because even the->core_state
	  is not really needed if we check ->group_exit_task, this
	  need more changes anyway, but I won't argue.

	- With your patch we send the notification to debugger even
	  if we are not going to stop.

	  This is not wrong, but why? This is pointless, nobody rely
	  on SIGCHLD, if nothing else it doesn't queue.

	  Again, I won't argue, but this complicates both the patch
	  and the code for no reason. Unless I missed something.

> Keep sending the signal to the tracer so that this appears like
> the worst case where someone else sent the process a SIGKILL before
> the tracer could react.  So all non-buggy tracers must support
> this case.

Well, I can't understand the changelog. Sure, debugger must support
this case, but obviously this can break things anyway.

For example. The coredumping thread must stop in PTRACE_EVENT_EXIT.
There is a tool (I don't remember its name) which does
ptrace_attach(PTRACE_SEIZE, PTRACE_O_TRACEEXIT) after the coredump
was already started, closes the pipe, and reads the registers when
this thread actually exits.

This patch or my 2/2 should not break it, ->group_exit_task will be
cleared after do_coredump(), but unfortunately something else can be
broken.

So I think the changelog should mention that yes, this is the user
visible change which _can_ break something anyway.

In short. I will be really happy if this patch comes from you, not me ;)

Oleg.
