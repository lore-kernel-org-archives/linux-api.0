From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
Date: Wed, 25 Jun 2014 15:51:22 +0200
Message-ID: <20140625135121.GB7892@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-6-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <1403642893-23107-6-git-send-email-keescook@chromium.org>
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
> +static inline void seccomp_assign_mode(struct task_struct *task,
> +				       unsigned long seccomp_mode)
> +{
> +	BUG_ON(!spin_is_locked(&task->sighand->siglock));
> +
> +	task->seccomp.mode = seccomp_mode;
> +	set_tsk_thread_flag(task, TIF_SECCOMP);
> +}

OK, but unless task == current this can race with secure_computing().
I think this needs smp_mb__before_atomic() and secure_computing() needs
rmb() after test_bit(TIF_SECCOMP).

Otherwise, can't __secure_computing() hit BUG() if it sees the old
mode == SECCOMP_MODE_DISABLED ?

Or seccomp_run_filters() can see ->filters == NULL and WARN(),
smp_load_acquire() only serializes that LOAD with the subsequent memory
operations.

Oleg.
