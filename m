From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v3 2/2] doc: Update documentation for page_idle virtual
 address indexing
Date: Wed, 31 Jul 2019 09:44:02 +0300
Message-ID: <20190731064400.GD21422@rapoport-lnx>
References: <20190726152319.134152-1-joel@joelfernandes.org>
 <20190726152319.134152-2-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190726152319.134152-2-joel@joelfernandes.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Brendan Gregg <bgregg@netflix.com>, Christian Hansen <chansen3@cisco.com>, dancol@google.com, fmayer@google.com, joaodias@google.com, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, minchan@kernel.org, namhyung@google.com, Roman Gushchin <guro@fb.com>, Stephen Rothwell <sfr@canb.auug.org.au>, surenb@google.com, tkjos@google.com, Vladimir Davydov <vdavydov.dev@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, wvw@google.com
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 11:23:19AM -0400, Joel Fernandes (Google) wrote:
> This patch updates the documentation with the new page_idle tracking
> feature which uses virtual address indexing.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

One nit below, otherwise

Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>

> ---
>  .../admin-guide/mm/idle_page_tracking.rst     | 43 ++++++++++++++++---
>  1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/idle_page_tracking.rst b/Documentation/admin-guide/mm/idle_page_tracking.rst
> index df9394fb39c2..1eeac78c94a7 100644
> --- a/Documentation/admin-guide/mm/idle_page_tracking.rst
> +++ b/Documentation/admin-guide/mm/idle_page_tracking.rst
> @@ -19,10 +19,14 @@ It is enabled by CONFIG_IDLE_PAGE_TRACKING=y.
>  
>  User API
>  ========
> +There are 2 ways to access the idle page tracking API. One uses physical
> +address indexing, another uses a simpler virtual address indexing scheme.
>  
> -The idle page tracking API is located at ``/sys/kernel/mm/page_idle``.
> -Currently, it consists of the only read-write file,
> -``/sys/kernel/mm/page_idle/bitmap``.
> +Physical address indexing
> +-------------------------
> +The idle page tracking API for physical address indexing using page frame
> +numbers (PFN) is located at ``/sys/kernel/mm/page_idle``.  Currently, it
> +consists of the only read-write file, ``/sys/kernel/mm/page_idle/bitmap``.
>  
>  The file implements a bitmap where each bit corresponds to a memory page. The
>  bitmap is represented by an array of 8-byte integers, and the page at PFN #i is
> @@ -74,6 +78,31 @@ See :ref:`Documentation/admin-guide/mm/pagemap.rst <pagemap>` for more
>  information about ``/proc/pid/pagemap``, ``/proc/kpageflags``, and
>  ``/proc/kpagecgroup``.
>  
> +Virtual address indexing
> +------------------------
> +The idle page tracking API for virtual address indexing using virtual page
> +frame numbers (VFN) is located at ``/proc/<pid>/page_idle``. It is a bitmap
> +that follows the same semantics as ``/sys/kernel/mm/page_idle/bitmap``
> +except that it uses virtual instead of physical frame numbers.

Can you please make it more explicit that VFNs are in the <pid>'s address
space?

> +
> +This idle page tracking API does not need deal with PFN so it does not require
> +prior lookups of ``pagemap`` in order to find if page is idle or not. This is
> +an advantage on some systems where looking up PFN is considered a security
> +issue.  Also in some cases, this interface could be slightly more reliable to
> +use than physical address indexing, since in physical address indexing, address
> +space changes can occur between reading the ``pagemap`` and reading the
> +``bitmap``, while in virtual address indexing, the process's ``mmap_sem`` is
> +held for the duration of the access.
> +
> +To estimate the amount of pages that are not used by a workload one should:
> +
> + 1. Mark all the workload's pages as idle by setting corresponding bits in
> +    ``/proc/<pid>/page_idle``.
> +
> + 2. Wait until the workload accesses its working set.
> +
> + 3. Read ``/proc/<pid>/page_idle`` and count the number of bits set.
> +
>  .. _impl_details:
>  
>  Implementation Details
> @@ -99,10 +128,10 @@ When a dirty page is written to swap or disk as a result of memory reclaim or
>  exceeding the dirty memory limit, it is not marked referenced.
>  
>  The idle memory tracking feature adds a new page flag, the Idle flag. This flag
> -is set manually, by writing to ``/sys/kernel/mm/page_idle/bitmap`` (see the
> -:ref:`User API <user_api>`
> -section), and cleared automatically whenever a page is referenced as defined
> -above.
> +is set manually, by writing to ``/sys/kernel/mm/page_idle/bitmap`` for physical
> +addressing or by writing to ``/proc/<pid>/page_idle`` for virtual
> +addressing (see the :ref:`User API <user_api>` section), and cleared
> +automatically whenever a page is referenced as defined above.
>  
>  When a page is marked idle, the Accessed bit must be cleared in all PTEs it is
>  mapped to, otherwise we will not be able to detect accesses to the page coming
> -- 
> 2.22.0.709.g102302147b-goog
> 

-- 
Sincerely yours,
Mike.
