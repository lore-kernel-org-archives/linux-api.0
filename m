From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH V3 4/5] mm: mmap: Add mmap flag to request VM_LOCKONFAULT
Date: Wed, 22 Jul 2015 10:10:20 -0400
Message-ID: <55AFA44C.2060906@windriver.com>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com> <1436288623-13007-5-git-send-email-emunson@akamai.com> <CAP=VYLq5=9DCfncJpQizcSbQt1O7VL2yEdzZNOFK+M3pqLpb3Q@mail.gmail.com> <55AD5CB9.4090400@ezchip.com> <20150721153722.GB5411@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150721153722.GB5411@akamai.com>
Sender: owner-linux-mm@kvack.org
To: Eric B Munson <emunson@akamai.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-arch <linux-arch@vger.kernel.org>, linux-api@vger.kernel.org, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2015-07-21 11:37 AM, Eric B Munson wrote:
> On Mon, 20 Jul 2015, Chris Metcalf wrote:
> 
>> On 07/18/2015 03:11 PM, Paul Gortmaker wrote:
>>> On Tue, Jul 7, 2015 at 1:03 PM, Eric B Munson<emunson@akamai.com>  wrote:
>>>>> The cost of faulting in all memory to be locked can be very high when
>>>>> working with large mappings.  If only portions of the mapping will be
>>>>> used this can incur a high penalty for locking.
>>>>>
>>>>> Now that we have the new VMA flag for the locked but not present state,
>>>>> expose it  as an mmap option like MAP_LOCKED -> VM_LOCKED.
>>> An automatic bisection on arch/tile leads to this commit:
>>>
>>> 5a5656f2c9b61c74c15f9ef3fa2e6513b6c237bb is the first bad commit
>>> commit 5a5656f2c9b61c74c15f9ef3fa2e6513b6c237bb
>>> Author: Eric B Munson<emunson@akamai.com>
>>> Date:   Thu Jul 16 10:09:22 2015 +1000
>>>
>>>     mm: mmap: add mmap flag to request VM_LOCKONFAULT
>>
>> Eric, I'm happy to help with figuring out the tile issues.
> 
> Thanks for the offer, I think I have is sorted in V4 (which I am
> checking one last time before I post).

Not quite sorted yet.  Seems parisc fails on v4.  It updated the
number of syscalls but did not update syscall_table.S causing:

arch/parisc/kernel/syscall_table.S:444: Error: size of syscall table does not fit value of __NR_Linux_syscalls

http://kisskb.ellerman.id.au/kisskb/buildresult/12468884/

Paul.
--

> Eric
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
