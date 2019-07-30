From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 1/2] mm/page_idle: Add per-pid idle page tracking using
 virtual indexing
Date: Tue, 30 Jul 2019 09:06:36 -0400
Message-ID: <CAEXW_YQN+htU-LpYQ_jxepVdRhO0byw1pWFrsbU2XsH=8FDKLA@mail.gmail.com>
References: <20190726152319.134152-1-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190726152319.134152-1-joel@joelfernandes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Brendan Gregg <bgregg@netflix.com>, Christian Hansen <chansen3@cisco.com>, Daniel Colascione <dancol@google.com>, Florian Mayer <fmayer@google.com>, John Dias <joaodias@google.com>, Joel Fernandes <joelaf@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Namhyung Kim <namhyung@google.com>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 11:23 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> The page_idle tracking feature currently requires looking up the pagemap
> for a process followed by interacting with /sys/kernel/mm/page_idle.
> Looking up PFN from pagemap in Android devices is not supported by
> unprivileged process and requires SYS_ADMIN and gives 0 for the PFN.
>
> This patch adds support to directly interact with page_idle tracking at
> the PID level by introducing a /proc/<pid>/page_idle file.  It follows
> the exact same semantics as the global /sys/kernel/mm/page_idle, but now
> looking up PFN through pagemap is not needed since the interface uses
> virtual frame numbers, and at the same time also does not require
> SYS_ADMIN.
>
> In Android, we are using this for the heap profiler (heapprofd) which
> profiles and pin points code paths which allocates and leaves memory
> idle for long periods of time. This method solves the security issue
> with userspace learning the PFN, and while at it is also shown to yield
> better results than the pagemap lookup, the theory being that the window
> where the address space can change is reduced by eliminating the
> intermediate pagemap look up stage. In virtual address indexing, the
> process's mmap_sem is held for the duration of the access.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>
> ---
> v2->v3:
> Fixed a bug where I was doing a kfree that is not needed due to not
> needing to do GFP_ATOMIC allocations.
>
> v1->v2:
> Mark swap ptes as idle (Minchan)
> Avoid need for GFP_ATOMIC (Andrew)
> Get rid of idle_page_list lock by moving list to stack

I believe all suggestions have been addressed.  Do these look good now?

thanks,

 - Joel



> Internal review -> v1:
> Fixes from Suren.
> Corrections to change log, docs (Florian, Sandeep)
>
>  fs/proc/base.c            |   3 +
>  fs/proc/internal.h        |   1 +
>  fs/proc/task_mmu.c        |  57 +++++++
>  include/linux/page_idle.h |   4 +
>  mm/page_idle.c            | 340 +++++++++++++++++++++++++++++++++-----
>  5 files changed, 360 insertions(+), 45 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 77eb628ecc7f..a58dd74606e9 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3021,6 +3021,9 @@ static const struct pid_entry tgid_base_stuff[] = {
>         REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
>         REG("smaps_rollup", S_IRUGO, proc_pid_smaps_rollup_operations),
