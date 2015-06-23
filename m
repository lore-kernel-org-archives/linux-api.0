From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RESEND PATCH V2 0/3] Allow user to request memory to be locked
 on page fault
Date: Tue, 23 Jun 2015 15:04:22 +0200
Message-ID: <55895956.5020707@suse.cz>
References: <1433942810-7852-1-git-send-email-emunson@akamai.com> <20150610145929.b22be8647887ea7091b09ae1@linux-foundation.org> <5579DFBA.80809@akamai.com> <20150611123424.4bb07cffd0e5bb146cc92231@linux-foundation.org> <557ACAFC.90608@suse.cz> <20150615144356.GB12300@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615144356.GB12300-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/15/2015 04:43 PM, Eric B Munson wrote:
>> Note that the semantic of MAP_LOCKED can be subtly surprising:
>>
>> "mlock(2) fails if the memory range cannot get populated to guarantee
>> that no future major faults will happen on the range.
>> mmap(MAP_LOCKED) on the other hand silently succeeds even if the
>> range was populated only
>> partially."
>>
>> ( from http://marc.info/?l=linux-mm&m=143152790412727&w=2 )
>>
>> So MAP_LOCKED can silently behave like MAP_LOCKONFAULT. While
>> MAP_LOCKONFAULT doesn't suffer from such problem, I wonder if that's
>> sufficient reason not to extend mmap by new mlock() flags that can
>> be instead applied to the VMA after mmapping, using the proposed
>> mlock2() with flags. So I think instead we could deprecate
>> MAP_LOCKED more prominently. I doubt the overhead of calling the
>> extra syscall matters here?
>
> We could talk about retiring the MAP_LOCKED flag but I suspect that
> would get significantly more pushback than adding a new mmap flag.

Oh no we can't "retire" as in remove the flag, ever. Just not continue 
the way of mmap() flags related to mlock().

> Likely that the overhead does not matter in most cases, but presumably
> there are cases where it does (as we have a MAP_LOCKED flag today).
> Even with the proposed new system calls I think we should have the
> MAP_LOCKONFAULT for parity with MAP_LOCKED.

I'm not convinced, but it's not a major issue.

>>
>>> - mlock() takes a `flags' argument.  Presently that's
>>>    MLOCK_LOCKED|MLOCK_LOCKONFAULT.
>>>
>>> - munlock() takes a `flags' arument.  MLOCK_LOCKED|MLOCK_LOCKONFAULT
>>>    to specify which flags are being cleared.
>>>
>>> - mlockall() and munlockall() ditto.
>>>
>>>
>>> IOW, LOCKED and LOCKEDONFAULT are treated identically and independently.
>>>
>>> Now, that's how we would have designed all this on day one.  And I
>>> think we can do this now, by adding new mlock2() and munlock2()
>>> syscalls.  And we may as well deprecate the old mlock() and munlock(),
>>> not that this matters much.
>>>
>>> *should* we do this?  I'm thinking "yes" - it's all pretty simple
>>> boilerplate and wrappers and such, and it gets the interface correct,
>>> and extensible.
>>
>> If the new LOCKONFAULT functionality is indeed desired (I haven't
>> still decided myself) then I agree that would be the cleanest way.
>
> Do you disagree with the use cases I have listed or do you think there
> is a better way of addressing those cases?

I'm somewhat sceptical about the security one. Are security sensitive 
buffers that large to matter? The performance one is more convincing and 
I don't see a better way, so OK.

>
>>
>>> What do others think?
