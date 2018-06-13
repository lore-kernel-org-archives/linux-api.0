From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/madvise: allow MADV_DONTNEED to free memory that is
 MLOCK_ONFAULT
Date: Wed, 13 Jun 2018 08:32:19 +0200
Message-ID: <0daccb7c-f642-c5ce-ca7a-3b3e69025a1e@suse.cz>
References: <1528484212-7199-1-git-send-email-jbaron@akamai.com>
 <20180611072005.GC13364@dhcp22.suse.cz>
 <4c4de46d-c55a-99a8-469f-e1e634fb8525@akamai.com>
 <20180611150330.GQ13364@dhcp22.suse.cz>
 <775adf2d-140c-1460-857f-2de7b24bafe7@akamai.com>
 <20180612074646.GS13364@dhcp22.suse.cz>
 <5a9398f4-453c-5cb5-6bbc-f20c3affc96a@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5a9398f4-453c-5cb5-6bbc-f20c3affc96a@akamai.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>, Michal Hocko <mhocko@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-api@vger.kernel.org, emunson@mgebm.net
List-Id: linux-api@vger.kernel.org

On 06/12/2018 04:11 PM, Jason Baron wrote:
> 
> 
> On 06/12/2018 03:46 AM, Michal Hocko wrote:
>> On Mon 11-06-18 12:23:58, Jason Baron wrote:
>>> On 06/11/2018 11:03 AM, Michal Hocko wrote:
>>>> So can we start discussing whether we want to allow MADV_DONTNEED on
>>>> mlocked areas and what downsides it might have? Sure it would turn the
>>>> strong mlock guarantee to have the whole vma resident but is this
>>>> acceptable for something that is an explicit request from the owner of
>>>> the memory?
>>>>
>>>
>>> If its being explicity requested by the owner it makes sense to me. I
>>> guess there could be a concern about this breaking some userspace that
>>> relied on MADV_DONTNEED not freeing locked memory?
>>
>> Yes, this is always the fear when changing user visible behavior.  I can
>> imagine that a userspace allocator calling MADV_DONTNEED on free could
>> break. The same would apply to MLOCK_ONFAULT/MCL_ONFAULT though. We
>> have the new flag much shorter so the probability is smaller but the
>> problem is very same. So I _think_ we should treat both the same because
>> semantically they are indistinguishable from the MADV_DONTNEED POV. Both
>> remove faulted and mlocked pages. Mlock, once applied, should guarantee
>> no later major fault and MADV_DONTNEED breaks that obviously.

I think more concerning than guaranteeing no later major fault is
possible data loss, e.g. replacing data with zero-filled pages.

The madvise manpage is also quite specific about not allowing
MADV_DONTNEED and MADV_FREE for locked pages.

So I don't think we should risk changing that for all mlocked pages.
Maybe we can risk MCL_ONFAULT, since it's relatively new and has few users?

>> So the more I think about it the more I am worried about this but I am
>> more and more convinced that making ONFAULT special is just a wrong way
>> around this.
>>
> 
> Ok, I share the concern that there is a chance that userspace is relying
> on MADV_DONTNEED not free'ing locked memory. In that case, what if we
> introduce a MADV_DONTNEED_FORCE, which does everything that
> MADV_DONTNEED currently does but in addition will also free mlock areas.
> That way there is no concern about breaking something.

A new niche case flag? Sad :(

BTW I didn't get why we should allow this for MADV_DONTNEED but not
MADV_FREE. Can you expand on that?

> Thanks,
> 
> -Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
