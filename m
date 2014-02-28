From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/4] mm, s390: Ignore MADV_HUGEPAGE on s390 to prevent
 SIGSEGV in qemu
Date: Fri, 28 Feb 2014 12:42:36 +0100
Message-ID: <5310762C.90108@redhat.com>
References: <cover.1393516106.git.athorlton@sgi.com> <c856e298ae180842638bdf85d74436ad8bbb84e4.1393516106.git.athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <c856e298ae180842638bdf85d74436ad8bbb84e4.1393516106.git.athorlton@sgi.com>
Sender: owner-linux-mm@kvack.org
To: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux390@de.ibm.com, linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Il 27/02/2014 18:23, Alex Thorlton ha scritto:
> As Christian pointed out, the recent 'Revert "thp: make MADV_HUGEPAGE
> check for mm->def_flags"' breaks qemu, it does QEMU_MADV_HUGEPAGE for
> all kvm pages but this doesn't work after s390_enable_sie/thp_split_mm.
>
> Paolo suggested that instead of failing on the call to madvise, we
> simply ignore the call (return 0).
>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-api@vger.kernel.org
>
> ---
>  mm/huge_memory.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index a4310a5..61d234d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1970,6 +1970,15 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  {
>  	switch (advice) {
>  	case MADV_HUGEPAGE:
> +#ifdef CONFIG_S390
> +		/*
> +		 * qemu blindly sets MADV_HUGEPAGE on all allocations, but s390
> +		 * can't handle this properly after s390_enable_sie, so we simply
> +		 * ignore the madvise to prevent qemu from causing a SIGSEGV.
> +		 */
> +		if (mm_has_pgste(vma->vm_mm))
> +			return 0;
> +#endif
>  		/*
>  		 * Be somewhat over-protective like KSM for now!
>  		 */
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
