From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC PATCH] mm,mremap: Bail out earlier in mremap_to under map
 pressure
Date: Mon, 25 Feb 2019 12:46:46 +0100
Message-ID: <cfc53e5a-a403-a732-69d2-1f96b8416f6d@suse.cz>
References: <20190221085406.10852-1-osalvador@suse.de>
 <20190222130125.apa2ysnahgfuj2vx@kshutemo-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222130125.apa2ysnahgfuj2vx@kshutemo-mobl1>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>, Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, joel@joelfernandes.org, jglisse@redhat.com, yang.shi@linux.alibaba.com, mgorman@techsingularity.net
List-Id: linux-api@vger.kernel.org

On 2/22/19 2:01 PM, Kirill A. Shutemov wrote:
> On Thu, Feb 21, 2019 at 09:54:06AM +0100, Oscar Salvador wrote:
>> When using mremap() syscall in addition to MREMAP_FIXED flag,
>> mremap() calls mremap_to() which does the following:
>>
>> 1) unmaps the destination region where we are going to move the map
>> 2) If the new region is going to be smaller, we unmap the last part
>>    of the old region
>>
>> Then, we will eventually call move_vma() to do the actual move.
>>
>> move_vma() checks whether we are at least 4 maps below max_map_count
>> before going further, otherwise it bails out with -ENOMEM.
>> The problem is that we might have already unmapped the vma's in steps
>> 1) and 2), so it is not possible for userspace to figure out the state
>> of the vma's after it gets -ENOMEM, and it gets tricky for userspace
>> to clean up properly on error path.
>>
>> While it is true that we can return -ENOMEM for more reasons
>> (e.g: see may_expand_vm() or move_page_tables()), I think that we can
>> avoid this scenario in concret if we check early in mremap_to() if the
>> operation has high chances to succeed map-wise.
>>
>> Should not be that the case, we can bail out before we even try to unmap
>> anything, so we make sure the vma's are left untouched in case we are likely
>> to be short of maps.
>>
>> The thumb-rule now is to rely on the worst-scenario case we can have.
>> That is when both vma's (old region and new region) are going to be split
>> in 3, so we get two more maps to the ones we already hold (one per each).
>> If current map count + 2 maps still leads us to 4 maps below the threshold,
>> we are going to pass the check in move_vma().
>>
>> Of course, this is not free, as it might generate false positives when it is
>> true that we are tight map-wise, but the unmap operation can release several
>> vma's leading us to a good state.
>>
>> Because of that I am sending this as a RFC.
>> Another approach was also investigated [1], but it may be too much hassle
>> for what it brings.
> 
> I believe we don't need the check in move_vma() with this patch. Or do we?

move_vma() can be also called directly from SYSCALL_DEFINE5(mremap) for
the non-MMAP_FIXED case. So unless there's further refactoring, the
check is still needed.

>>
>> [1] https://lore.kernel.org/lkml/20190219155320.tkfkwvqk53tfdojt@d104.suse.de/
>>
>> Signed-off-by: Oscar Salvador <osalvador@suse.de>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
