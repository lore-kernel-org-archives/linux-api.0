From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v9 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 9 Jul 2014 20:05:20 +0200
Message-ID: <20140709180520.GA2560@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org> <1403911380-27787-12-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403911380-27787-12-git-send-email-keescook@chromium.org>
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

First of all, sorry for delay ;)

So far I quickly glanced at this series and everything look fine, but
I am confused by the signal_group_exit() check,

On 06/27, Kees Cook wrote:
>
> To make sure that de_thread() is actually able
> to kill other threads during an exec, any sighand holders need to check
> if they've been scheduled to be killed, and to give up on their work.

Probably this connects to that check below? I can't understand this...

> +	/*
> +	 * Make sure we cannot change seccomp or nnp state via TSYNC
> +	 * while another thread is in the middle of calling exec.
> +	 */
> +	if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
> +	    mutex_lock_killable(&current->signal->cred_guard_mutex))
> +		goto out_free;

-EINVAL looks a bit confusing in this case, but this is cosemtic because
userspace won't see this error-code anyway.

>  	spin_lock_irq(&current->sighand->siglock);
> +	if (unlikely(signal_group_exit(current->signal))) {
> +		/* If thread is dying, return to process the signal. */

OK, this doesn't hurt, but why?

You could check __fatal_signal_pending() with the same effect. And since
we hold this mutex, exec (de_thread) can be the source of that SIGKILL.
We take this mutex specially to avoid the race with exec.

So why do we need to abort if we race with kill() or exit_grouo() ?

Oleg.
