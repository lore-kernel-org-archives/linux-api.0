From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v7 3/6] mm: Introduce VM_LOCKONFAULT
Date: Thu, 20 Aug 2015 09:53:50 +0200
Message-ID: <55D5878E.5030206@suse.cz>
References: <1439097776-27695-1-git-send-email-emunson@akamai.com>
 <1439097776-27695-4-git-send-email-emunson@akamai.com>
 <20150812115909.GA5182@dhcp22.suse.cz> <20150819213345.GB4536@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150819213345.GB4536-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/19/2015 11:33 PM, Eric B Munson wrote:
> On Wed, 12 Aug 2015, Michal Hocko wrote:
>
>> On Sun 09-08-15 01:22:53, Eric B Munson wrote:
>>
>> I do not like this very much to be honest. We have only few bits
>> left there and it seems this is not really necessary. I thought that
>> LOCKONFAULT acts as a modifier to the mlock call to tell whether to
>> poppulate or not. The only place we have to persist it is
>> mlockall(MCL_FUTURE) AFAICS. And this can be handled by an additional
>> field in the mm_struct. This could be handled at __mm_populate level.
>> So unless I am missing something this would be much more easier
>> in the end we no new bit in VM flags would be necessary.
>>
>> This would obviously mean that the LOCKONFAULT couldn't be exported to
>> the userspace but is this really necessary?
>
> Sorry for the latency here, I was on vacation and am now at plumbers.
>
> I am not sure that growing the mm_struct by another flags field instead
> of using available bits in the vm_flags is the right choice.

I was making the same objection on one of the earlier versions and since 
you sticked with a new vm flag, I thought it doesn't matter, as we could 
change it later if we run out of bits. But now I realize that since you 
export this difference to userspace (and below you say that it's by 
request), we won't be able to change it later. So it's a more difficult 
choice.

> After this
> patch, we still have 3 free bits on 32 bit architectures (2 after the
> userfaultfd set IIRC).  The group which asked for this feature here
> wants the ability to distinguish between LOCKED and LOCKONFAULT regions
> and without the VMA flag there isn't a way to do that.
>
> Do we know that these last two open flags are needed right now or is
> this speculation that they will be and that none of the other VMA flags
> can be reclaimed?

I think it's the latter, we can expect that flags will be added rather 
than removed, as removal is hard or impossible.
