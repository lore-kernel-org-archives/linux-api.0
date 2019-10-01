From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v4 3/4] sched_setattr: switch to copy_struct_from_user()
Date: Tue, 1 Oct 2019 04:33:01 +0200
Message-ID: <20191001023300.2melco5qvojypsup@wittgenstein>
References: <20191001011055.19283-1-cyphar@cyphar.com>
 <20191001011055.19283-4-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191001011055.19283-4-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 11:10:54AM +1000, Aleksa Sarai wrote:
> The change is very straightforward, and helps unify the syscall
> interface for struct-from-userspace syscalls. Ideally we could also
> unify sched_getattr(2)-style syscalls as well, but unfortunately the
> correct semantics for such syscalls are much less clear (see [1] for
> more detail). In future we could come up with a more sane idea for how
> the syscall interface should look.
> 
> [1]: commit 1251201c0d34 ("sched/core: Fix uclamp ABI bug, clean up and
>      robustify sched_read_attr() ABI logic and code")
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
