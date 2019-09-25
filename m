From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v1 0/4] lib: introduce copy_struct_from_user() helper
Date: Wed, 25 Sep 2019 19:09:04 +0200
Message-ID: <20190925170903.6ssligvk3gpbnwtq@wittgenstein>
References: <20190925165915.8135-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190925165915.8135-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 25, 2019 at 06:59:11PM +0200, Aleksa Sarai wrote:
> This series was split off from the openat2(2) syscall discussion[1].
> However, the copy_struct_to_user() helper has been dropped, because
> after some discussion it appears that there is no really obvious
> semantics for how copy_struct_to_user() should work on mixed-vintages
> (for instance, whether [2] is the correct semantics for all syscalls).
> 
> A common pattern for syscall extensions is increasing the size of a
> struct passed from userspace, such that the zero-value of the new fields
> result in the old kernel behaviour (allowing for a mix of userspace and
> kernel vintages to operate on one another in most cases).
> 
> Previously there was no common lib/ function that implemented
> the necessary extension-checking semantics (and different syscalls
> implemented them slightly differently or incompletely[3]). This series
> implements the helper and ports several syscalls to use it.
> 
> [1]: https://lore.kernel.org/lkml/20190904201933.10736-1-cyphar@cyphar.com/
> 
> [2]: commit 1251201c0d34 ("sched/core: Fix uclamp ABI bug, clean up and
>      robustify sched_read_attr() ABI logic and code")
> 
> [3]: For instance {sched_setattr,perf_event_open,clone3}(2) all do do
>      similar checks to copy_struct_from_user() while rt_sigprocmask(2)
>      always rejects differently-sized struct arguments.

Thank for splitting this out! :)
I should be able to review this tomorrow.

Christian
