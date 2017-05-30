From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] mm: introduce MADV_RESET_HUGEPAGE
Date: Mon, 29 May 2017 21:26:12 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1705292125210.9353@chino.kir.corp.google.com>
References: <1496035924-27251-1-git-send-email-rppt@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1496035924-27251-1-git-send-email-rppt@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 29 May 2017, Mike Rapoport wrote:

> Currently applications can explicitly enable or disable THP for a memory
> region using MADV_HUGEPAGE or MADV_NOHUGEPAGE. However, once either of
> these advises is used, the region will always have
> VM_HUGEPAGE/VM_NOHUGEPAGE flag set in vma->vm_flags.
> The MADV_RESET_HUGEPAGE resets both these flags and allows managing THP in
> the region according to system-wide settings.
> 
> Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

I feel like we may be losing some information from the v1 thread regarding 
the usecase.  Would it be possible to add something to the changelog to 
describe what will use this?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
