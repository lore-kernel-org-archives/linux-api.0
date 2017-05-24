From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 24 May 2017 13:31:12 +0200
Message-ID: <aec1376e-34b3-56ce-448e-7fbddcda448b@suse.cz>
References: <1495433562-26625-1-git-send-email-rppt@linux.vnet.ibm.com>
 <20170522114243.2wrdbncilozygbpl@node.shutemov.name>
 <20170522133559.GE27382@rapoport-lnx> <20170522135548.GA8514@dhcp22.suse.cz>
 <20170522142927.GG27382@rapoport-lnx>
 <a9e74c22-1a07-f49a-42b5-497fee85e9c9@suse.cz>
 <20170524075043.GB3063@rapoport-lnx>
 <c59a0893-d370-130b-5c33-d567a4621903@suse.cz>
 <20170524103947.GC3063@rapoport-lnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170524103947.GC3063@rapoport-lnx>
Sender: owner-linux-mm@kvack.org
To: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 05/24/2017 12:39 PM, Mike Rapoport wrote:
>> Hm so the prctl does:
>>
>>                 if (arg2)
>>                         me->mm->def_flags |= VM_NOHUGEPAGE;
>>                 else
>>                         me->mm->def_flags &= ~VM_NOHUGEPAGE;
>>
>> That's rather lazy implementation IMHO. Could we change it so the flag
>> is stored elsewhere in the mm, and the code that decides to (not) use
>> THP will check both the per-vma flag and the per-mm flag?
> 
> I afraid I don't understand how that can help.
> What we need is an ability to temporarily disable collapse of the pages in
> VMAs that do not have VM_*HUGEPAGE flags set and that after we re-enable
> THP, the vma->vm_flags for those VMAs will remain intact.

That's what I'm saying - instead of implementing the prctl flag via
mm->def_flags (which gets permanently propagated to newly created vma's
but e.g. doesn't affect already existing ones), it would be setting a
flag somewhere in mm, which khugepaged (and page faults) would check in
addition to the per-vma flags.


> --
> Sincerely yours,
> Mike.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
