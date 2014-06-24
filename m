From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v7 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 24 Jun 2014 19:27:53 +0200
Message-ID: <20140624172753.GA31435@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-8-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403560693-21809-8-git-send-email-keescook@chromium.org>
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
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/23, Kees Cook wrote:
>
> +static pid_t seccomp_can_sync_threads(void)
> +{
> +	struct task_struct *thread, *caller;
> +
> +	BUG_ON(write_can_lock(&tasklist_lock));
> +	BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +
> +	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
> +		return -EACCES;
> +
> +	/* Validate all threads being eligible for synchronization. */
> +	thread = caller = current;
> +	for_each_thread(caller, thread) {
> +		pid_t failed;
> +
> +		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
> +		    (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
> +		     is_ancestor(thread->seccomp.filter,
> +				 caller->seccomp.filter)))
> +			continue;
> +
> +		/* Return the first thread that cannot be synchronized. */
> +		failed = task_pid_vnr(thread);
> +		/* If the pid cannot be resolved, then return -ESRCH */
> +		if (failed == 0)
> +			failed = -ESRCH;

forgot to mention, task_pid_vnr() can't fail. sighand->siglock is held,
for_each_thread() can't see a thread which has passed unhash_process().

Oleg.
