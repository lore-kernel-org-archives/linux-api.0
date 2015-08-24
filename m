From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Mon, 24 Aug 2015 16:27:55 +0200
Message-ID: <55DB29EB.1000308@suse.cz>
References: <1439097776-27695-1-git-send-email-emunson@akamai.com>
 <1439097776-27695-4-git-send-email-emunson@akamai.com>
 <20150812115909.GA5182@dhcp22.suse.cz> <20150819213345.GB4536@akamai.com>
 <20150820075611.GD4780@dhcp22.suse.cz> <20150820170309.GA11557@akamai.com>
 <20150821072552.GF23723@dhcp22.suse.cz> <20150821183132.GA12835@akamai.com>
 <CALYGNiPcruTM+2KKNZr7ebCVCPsqytSrW8rSzSmj+1Qp4OqXEw@mail.gmail.com>
 <55DB1C77.8070705@suse.cz>
 <CALYGNiNuZgQFzZ+_dQsPOvSJAX7QfZ38zbabn4wRc=oC5Lb9wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALYGNiNuZgQFzZ+_dQsPOvSJAX7QfZ38zbabn4wRc=oC5Lb9wA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 08/24/2015 03:50 PM, Konstantin Khlebnikov wrote:
> On Mon, Aug 24, 2015 at 4:30 PM, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org> wrote:
>> On 08/24/2015 12:17 PM, Konstantin Khlebnikov wrote:
>>>>
>>>>
>>>> I am in the middle of implementing lock on fault this way, but I cannot
>>>> see how we will hanlde mremap of a lock on fault region.  Say we have
>>>> the following:
>>>>
>>>>       addr = mmap(len, MAP_ANONYMOUS, ...);
>>>>       mlock(addr, len, MLOCK_ONFAULT);
>>>>       ...
>>>>       mremap(addr, len, 2 * len, ...)
>>>>
>>>> There is no way for mremap to know that the area being remapped was lock
>>>> on fault so it will be locked and prefaulted by remap.  How can we avoid
>>>> this without tracking per vma if it was locked with lock or lock on
>>>> fault?
>>>
>>>
>>> remap can count filled ptes and prefault only completely populated areas.
>>
>>
>> Does (and should) mremap really prefault non-present pages? Shouldn't it
>> just prepare the page tables and that's it?
>
> As I see mremap prefaults pages when it extends mlocked area.
>
> Also quote from manpage
> : If  the memory segment specified by old_address and old_size is locked
> : (using mlock(2) or similar), then this lock is maintained when the segment is
> : resized and/or relocated.  As a  consequence, the amount of memory locked
> : by the process may change.

Oh, right... Well that looks like a convincing argument for having a 
sticky VM_LOCKONFAULT after all. Having mremap guess by scanning 
existing pte's would slow it down, and be unreliable (was the area 
completely populated because MLOCK_ONFAULT was not used or because the 
process aulted it already? Was it not populated because MLOCK_ONFAULT 
was used, or because mmap(MAP_LOCKED) failed to populate it all?).

The only sane alternative is to populate always for mremap() of 
VM_LOCKED areas, and document this loss of MLOCK_ONFAULT information as 
a limitation of mlock2(MLOCK_ONFAULT). Which might or might not be 
enough for Eric's usecase, but it's somewhat ugly.

>>
>>> There might be a problem after failed populate: remap will handle them
>>> as lock on fault. In this case we can fill ptes with swap-like non-present
>>> entries to remember that fact and count them as should-be-locked pages.
>>
>>
>> I don't think we should strive to have mremap try to fix the inherent
>> unreliability of mmap (MAP_POPULATE)?
>
> I don't think so. MAP_POPULATE works only when mmap happens.
> Flag MREMAP_POPULATE might be a good idea. Just for symmetry.

Maybe, but please do it as a separate series.
