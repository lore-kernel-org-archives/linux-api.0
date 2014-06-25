From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 9/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 25 Jun 2014 16:21:21 +0200
Message-ID: <20140625142121.GD7892@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-10-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403642893-23107-10-git-send-email-keescook@chromium.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/24, Kees Cook wrote:
>
> +static void seccomp_sync_threads(void)
> +{
> +	struct task_struct *thread, *caller;
> +
> +	BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +
> +	/* Synchronize all threads. */
> +	caller = current;
> +	for_each_thread(caller, thread) {
> +		/* Get a task reference for the new leaf node. */
> +		get_seccomp_filter(caller);
> +		/*
> +		 * Drop the task reference to the shared ancestor since
> +		 * current's path will hold a reference.  (This also
> +		 * allows a put before the assignment.)
> +		 */
> +		put_seccomp_filter(thread);
> +		thread->seccomp.filter = caller->seccomp.filter;
> +		/* Opt the other thread into seccomp if needed.
> +		 * As threads are considered to be trust-realm
> +		 * equivalent (see ptrace_may_access), it is safe to
> +		 * allow one thread to transition the other.
> +		 */
> +		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
> +			/*
> +			 * Don't let an unprivileged task work around
> +			 * the no_new_privs restriction by creating
> +			 * a thread that sets it up, enters seccomp,
> +			 * then dies.
> +			 */
> +			if (task_no_new_privs(caller))
> +				task_set_no_new_privs(thread);
> +
> +			seccomp_assign_mode(thread, SECCOMP_MODE_FILTER);
> +		}
> +	}
> +}

OK, personally I think this all make sense. I even think that perhaps
SECCOMP_FILTER_FLAG_TSYNC should allow filter == NULL, a thread might
want to "sync" without adding the new filter, but this is minor/offtopic.

But. Doesn't this change add the new security hole?

Obviously, we should not allow to install a filter and then (say) exec
a suid binary, that is why we have no_new_privs/LSM_UNSAFE_NO_NEW_PRIVS.

But what if "thread->seccomp.filter = caller->seccomp.filter" races with
any user of task_no_new_privs() ? Say, suppose this thread has already
passed check_unsafe_exec/etc and it is going to exec the suid binary?

Oleg.
