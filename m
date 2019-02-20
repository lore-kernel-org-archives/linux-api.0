From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: mremap vs sysctl_max_map_count
Date: Wed, 20 Feb 2019 11:30:41 +0100
Message-ID: <5358bb76-be75-953d-8268-a2b889a44c72@suse.cz>
References: <20190218083326.xsnx7cx2lxurbmux@d104.suse.de>
 <a11a10b5-4a31-2537-7b14-83f4b22e5f6c@suse.cz>
 <20190218111535.dxkm7w7c2edgl2lh@kshutemo-mobl1>
 <20190219155320.tkfkwvqk53tfdojt@d104.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219155320.tkfkwvqk53tfdojt@d104.suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Oscar Salvador <osalvador@suse.de>, "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, hughd@google.com, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org
List-Id: linux-api@vger.kernel.org

On 2/19/19 4:53 PM, Oscar Salvador wrote:
> On Mon, Feb 18, 2019 at 02:15:35PM +0300, Kirill A. Shutemov wrote:
>> On Mon, Feb 18, 2019 at 10:57:18AM +0100, Vlastimil Babka wrote:
>>> IMHO it makes sense to do all such resource limit checks upfront. It
>>> should all be protected by mmap_sem and thus stable, right? Even if it
>>> was racy, I'd think it's better to breach the limit a bit due to a race
>>> than bail out in the middle of operation. Being also resilient against
>>> "real" ENOMEM's due to e.g. failure to alocate a vma would be much
>>> harder perhaps (but maybe it's already mostly covered by the
>>> too-small-to-fail in page allocator), but I'd try with the artificial
>>> limits at least.
>>
>> There's slight chance of false-postive -ENOMEM with upfront approach:
>> unmapping can reduce number of VMAs so in some cases upfront check would
>> fail something that could succeed otherwise.
>>
>> We could check also what number of VMA unmap would free (if any). But it
>> complicates the picture and I don't think worth it in the end.
> 
> I came up with an approach which tries to check how many vma's are we going
> to split and the number of vma's that we are going to free.
> I did several tests and it worked for me, but I am not sure if I overlooked
> something due to false assumptions.
> I am also not sure either if the extra code is worth, but from my POV
> it could avoid such cases where we unmap regions but move_vma()
> is not going to succeed at all.
> 
> 
> It is not yet complete (sanity checks are missing), but I wanted to show it
> to see whether it is something that is worth spending time with:

Since move_vma() seems to consider only the worst case with the
hardcoded slack value of 3, I think we can afford to do that here as
well. And IIRC also nothing considers the possibility that the moved
area might merge with neighbours at the new address?

What worries me more is the amount of checks in vma_to_resize() that can
make things fail after the munmap was already done. Could it be also
called upfront? (And shouldn't it only be called when newsize > oldsize?)

Vlastimil
