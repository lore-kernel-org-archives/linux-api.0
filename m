From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RESEND PATCH V2 0/3] Allow user to request memory to be locked
 on page fault
Date: Fri, 12 Jun 2015 14:05:16 +0200
Message-ID: <557ACAFC.90608@suse.cz>
References: <1433942810-7852-1-git-send-email-emunson@akamai.com>	<20150610145929.b22be8647887ea7091b09ae1@linux-foundation.org>	<5579DFBA.80809@akamai.com> <20150611123424.4bb07cffd0e5bb146cc92231@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <20150611123424.4bb07cffd0e5bb146cc92231@linux-foundation.org>
Sender: linux-alpha-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Eric B Munson <emunson@akamai.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, Michal Hocko <mhocko@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 06/11/2015 09:34 PM, Andrew Morton wrote:
> On Thu, 11 Jun 2015 15:21:30 -0400 Eric B Munson <emunson@akamai.com> wrote:
>
>>> Ditto mlockall(MCL_ONFAULT) followed by munlock().  I'm not sure
>>> that even makes sense but the behaviour should be understood and
>>> tested.
>>
>> I have extended the kselftest for lock-on-fault to try both of these
>> scenarios and they work as expected.  The VMA is split and the VM
>> flags are set appropriately for the resulting VMAs.
>
> munlock() should do vma merging as well.  I *think* we implemented
> that.  More tests for you to add ;)
>
> How are you testing the vma merging and splitting, btw?  Parsing
> the profcs files?
>
>>> What's missing here is a syscall to set VM_LOCKONFAULT on an
>>> arbitrary range of memory - mlock() for lock-on-fault.  It's a
>>> shame that mlock() didn't take a `mode' argument.  Perhaps we
>>> should add such a syscall - that would make the mmap flag unneeded
>>> but I suppose it should be kept for symmetry.
>>
>> Do you want such a system call as part of this set?  I would need some
>> time to make sure I had thought through all the possible corners one
>> could get into with such a call, so it would delay a V3 quite a bit.
>> Otherwise I can send a V3 out immediately.
>
> I think the way to look at this is to pretend that mm/mlock.c doesn't
> exist and ask "how should we design these features".
>
> And that would be:
>
> - mmap() takes a `flags' argument: MAP_LOCKED|MAP_LOCKONFAULT.

Note that the semantic of MAP_LOCKED can be subtly surprising:

"mlock(2) fails if the memory range cannot get populated to guarantee
that no future major faults will happen on the range. mmap(MAP_LOCKED) 
on the other hand silently succeeds even if the range was populated only
partially."

( from http://marc.info/?l=linux-mm&m=143152790412727&w=2 )

So MAP_LOCKED can silently behave like MAP_LOCKONFAULT. While 
MAP_LOCKONFAULT doesn't suffer from such problem, I wonder if that's 
sufficient reason not to extend mmap by new mlock() flags that can be 
instead applied to the VMA after mmapping, using the proposed mlock2() 
with flags. So I think instead we could deprecate MAP_LOCKED more 
prominently. I doubt the overhead of calling the extra syscall matters here?

> - mlock() takes a `flags' argument.  Presently that's
>    MLOCK_LOCKED|MLOCK_LOCKONFAULT.
>
> - munlock() takes a `flags' arument.  MLOCK_LOCKED|MLOCK_LOCKONFAULT
>    to specify which flags are being cleared.
>
> - mlockall() and munlockall() ditto.
>
>
> IOW, LOCKED and LOCKEDONFAULT are treated identically and independently.
>
> Now, that's how we would have designed all this on day one.  And I
> think we can do this now, by adding new mlock2() and munlock2()
> syscalls.  And we may as well deprecate the old mlock() and munlock(),
> not that this matters much.
>
> *should* we do this?  I'm thinking "yes" - it's all pretty simple
> boilerplate and wrappers and such, and it gets the interface correct,
> and extensible.

If the new LOCKONFAULT functionality is indeed desired (I haven't still 
decided myself) then I agree that would be the cleanest way.

> What do others think?
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

