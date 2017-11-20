From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH 1/2] mm: introduce MAP_FIXED_SAFE
Date: Mon, 20 Nov 2017 10:45:56 +0100
Message-ID: <dc021363-bc42-dbf3-7712-2f71a500eb77@redhat.com>
References: <20171116101900.13621-1-mhocko@kernel.org>
 <20171116101900.13621-2-mhocko@kernel.org>
 <a3f7aed9-0df2-2fd6-cebb-ba569ad66781@redhat.com>
 <20171120085524.y4onsl5dpd3qbh7y@dhcp22.suse.cz>
 <37a6e9ba-e0df-b65f-d5ef-871c25b5cb87@redhat.com>
 <20171120093309.wobvu6mixbk75m3v@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171120093309.wobvu6mixbk75m3v@dhcp22.suse.cz>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 11/20/2017 10:33 AM, Michal Hocko wrote:
> On Mon 20-11-17 10:10:32, Florian Weimer wrote:
>> On 11/20/2017 09:55 AM, Michal Hocko wrote:
>>> On Fri 17-11-17 08:30:48, Florian Weimer wrote:
>>>> On 11/16/2017 11:18 AM, Michal Hocko wrote:
>>>>> +	if (flags & MAP_FIXED_SAFE) {
>>>>> +		struct vm_area_struct *vma = find_vma(mm, addr);
>>>>> +
>>>>> +		if (vma && vma->vm_start <= addr)
>>>>> +			return -ENOMEM;
>>>>> +	}
>>>>
>>>> Could you pick a different error code which cannot also be caused by a an
>>>> unrelated, possibly temporary condition?  Maybe EBUSY or EEXIST?
>>>
>>> Hmm, none of those are described in the man page. I am usually very
>>> careful to not add new and potentially unexpected error codes but it is
>>
>> I think this is a bad idea.  It leads to bizarre behavior, like open failing
>> with EOVERFLOW with certain namespace configurations (which have nothing to
>> do with file sizes).
> 
> Ohh, I agree but breaking userspace is, you know, no-no. And an
> unexpected error codes can break things terribly.

On the glibc side, we see a lot of changes in error codes depending on 
kernel version, build and run-time configuration.  It never occurred to 
me that you guys think the precise error code is part of the userspace 
ABI.  Personally, I even assume that failure itself can disappear at any 
time (evidence: the f* functions which accept O_PATH in their non-*at 
variants).

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
