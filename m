From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm: make PR_SET_THP_DISABLE immediately active
Date: Fri, 2 Jun 2017 22:31:47 +0200
Message-ID: <8a810c81-6a72-2af0-a450-6f03c71d8cca@suse.cz>
References: <1496415802-30944-1-git-send-email-rppt@linux.vnet.ibm.com>
 <20170602125059.66209870607085b84c257593@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170602125059.66209870607085b84c257593@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Pavel Emelyanov <xemul@virtuozzo.com>, linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On 06/02/2017 09:50 PM, Andrew Morton wrote:
> On Fri,  2 Jun 2017 18:03:22 +0300 "Mike Rapoport" <rppt@linux.vnet.ibm.com> wrote:
> 
>> PR_SET_THP_DISABLE has a rather subtle semantic. It doesn't affect any
>> existing mapping because it only updated mm->def_flags which is a template
>> for new mappings. The mappings created after prctl(PR_SET_THP_DISABLE) have
>> VM_NOHUGEPAGE flag set.  This can be quite surprising for all those
>> applications which do not do prctl(); fork() & exec() and want to control
>> their own THP behavior.
>>
>> Another usecase when the immediate semantic of the prctl might be useful is
>> a combination of pre- and post-copy migration of containers with CRIU.  In
>> this case CRIU populates a part of a memory region with data that was saved
>> during the pre-copy stage. Afterwards, the region is registered with
>> userfaultfd and CRIU expects to get page faults for the parts of the region
>> that were not yet populated. However, khugepaged collapses the pages and
>> the expected page faults do not occur.
>>
>> In more general case, the prctl(PR_SET_THP_DISABLE) could be used as a
>> temporary mechanism for enabling/disabling THP process wide.
>>
>> Implementation wise, a new MMF_DISABLE_THP flag is added. This flag is
>> tested when decision whether to use huge pages is taken either during page
>> fault of at the time of THP collapse.
>>
>> It should be noted, that the new implementation makes PR_SET_THP_DISABLE
>> master override to any per-VMA setting, which was not the case previously.
>>
>> Fixes: a0715cc22601 ("mm, thp: add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE")
> 
> "Fixes" is a bit strong.  I'd say "alters".  And significantly altering
> the runtime behaviour of a three-year-old interface is rather a worry,
> no?
> 
> Perhaps we should be adding new prctl modes to select this new
> behaviour and leave the existing PR_SET_THP_DISABLE behaviour as-is?

I think we can reasonably assume that most users of the prctl do just
the fork() & exec() thing, so they will be unaffected. And as usual, if
somebody does complain in the end, we revert and try the other way?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
