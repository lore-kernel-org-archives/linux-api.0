From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v7 3/9] seccomp: introduce writer locking
Date: Tue, 24 Jun 2014 20:30:24 +0200
Message-ID: <20140624183024.GA1258@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-4-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403560693-21809-4-git-send-email-keescook@chromium.org>
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

I am puzzled by the usage of smp_load_acquire(),

On 06/23, Kees Cook wrote:
>
>  static u32 seccomp_run_filters(int syscall)
>  {
> -	struct seccomp_filter *f;
> +	struct seccomp_filter *f = smp_load_acquire(&current->seccomp.filter);
>  	struct seccomp_data sd;
>  	u32 ret = SECCOMP_RET_ALLOW;
>  
>  	/* Ensure unexpected behavior doesn't result in failing open. */
> -	if (WARN_ON(current->seccomp.filter == NULL))
> +	if (WARN_ON(f == NULL))
>  		return SECCOMP_RET_KILL;
>  
>  	populate_seccomp_data(&sd);
> @@ -186,9 +186,8 @@ static u32 seccomp_run_filters(int syscall)
>  	 * All filters in the list are evaluated and the lowest BPF return
>  	 * value always takes priority (ignoring the DATA).
>  	 */
> -	for (f = current->seccomp.filter; f; f = f->prev) {
> +	for (; f; f = smp_load_acquire(&f->prev)) {
>  		u32 cur_ret = SK_RUN_FILTER(f->prog, (void *)&sd);
> -
>  		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
>  			ret = cur_ret;

OK, in this case the 1st one is probably fine, altgough it is not
clear to me why it is better than read_barrier_depends().

But why do we need a 2nd one inside the loop? And if we actually need
it (I don't think so) then why it is safe to use f->prog without
load_acquire ?

>  void get_seccomp_filter(struct task_struct *tsk)
>  {
> -	struct seccomp_filter *orig = tsk->seccomp.filter;
> +	struct seccomp_filter *orig = smp_load_acquire(&tsk->seccomp.filter);
>  	if (!orig)
>  		return;

This one looks unneeded.

First of all, afaics atomic_inc() should work correctly without any barriers,
otherwise it is buggy. But even this doesn't matter.

With this changes get_seccomp_filter() must be called under ->siglock, it can't
race with add-filter and thus tsk->seccomp.filter should be stable.

>  	/* Reference count is bounded by the number of total processes. */
> @@ -361,7 +364,7 @@ void put_seccomp_filter(struct task_struct *tsk)
>  	/* Clean up single-reference branches iteratively. */
>  	while (orig && atomic_dec_and_test(&orig->usage)) {
>  		struct seccomp_filter *freeme = orig;
> -		orig = orig->prev;
> +		orig = smp_load_acquire(&orig->prev);
>  		seccomp_filter_free(freeme);
>  	}

This one looks unneeded too. And note that this patch does not add
smp_load_acquire() to read tsk->seccomp.filter.

atomic_dec_and_test() adds mb(), we do not need more barriers to access
->prev ?

Oleg.
