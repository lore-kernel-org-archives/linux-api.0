From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH V3 3/5] mm: mlock: Introduce VM_LOCKONFAULT and add mlock
 flags to enable it
Date: Tue, 21 Jul 2015 17:35:59 +0200
Message-ID: <55AE66DF.1060600@suse.cz>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com> <1436288623-13007-4-git-send-email-emunson@akamai.com> <20150708132351.61c13db6@lwn.net> <20150708203456.GC4669@akamai.com> <20150708151750.75e65859@lwn.net> <20150709184635.GE4669@akamai.com> <20150710101118.5d04d627@lwn.net> <20150710161948.GF4669@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20150710161948.GF4669@akamai.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/10/2015 06:19 PM, Eric B Munson wrote:
> On Fri, 10 Jul 2015, Jonathan Corbet wrote:
>
>> On Thu, 9 Jul 2015 14:46:35 -0400
>> Eric B Munson <emunson@akamai.com> wrote:
>>
>>>> One other question...if I call mlock2(MLOCK_ONFAULT) on a range that
>>>> already has resident pages, I believe that those pages will not be locked
>>>> until they are reclaimed and faulted back in again, right?  I suspect that
>>>> could be surprising to users.
>>>
>>> That is the case.  I am looking into what it would take to find only the
>>> present pages in a range and lock them, if that is the behavior that is
>>> preferred I can include it in the updated series.
>>
>> For whatever my $0.02 is worth, I think that should be done.  Otherwise
>> the mlock2() interface is essentially nondeterministic; you'll never
>> really know if a specific page is locked or not.
>>
>> Thanks,
>>
>> jon
>
> Okay, I likely won't have the new set out today then.  This change is
> more invasive.  IIUC, I need an equivalent to __get_user_page() skips
> pages which are not present instead of faulting in and the call chain to
> get to it.  Unless there is an easier way that I am missing.

IIRC having page PageMlocked and put on unevictable list isn't necessary 
to prevent it from being reclaimed. It's just to prevent it from being 
scanned for reclaim in the first place. When attempting to unmap the 
page, vma flags are still checked, see the code in try_to_unmap_one(). 
You should probably extend the checks to your new VM_ flag as it is done 
for VM_LOCKED and then you shouldn't need to walk the pages to mlock 
them (although it would probably still be better for the accounting 
accuracy).

> Eric
>

