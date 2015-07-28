From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH V5 0/7] Allow user to request memory to be locked on page
 fault
Date: Tue, 28 Jul 2015 17:10:55 +0200
Message-ID: <55B79B7F.9010604@suse.cz>
References: <1437773325-8623-1-git-send-email-emunson@akamai.com>
 <55B5F4FF.9070604@suse.cz> <20150727133555.GA17133@akamai.com>
 <55B63D37.20303@suse.cz> <20150727145409.GB21664@akamai.com>
 <20150728111725.GG24972@dhcp22.suse.cz> <20150728134942.GB2407@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20150728134942.GB2407@akamai.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>, Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuahkh@osg.samsung.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Ralf Baechle <ralf@linux-mips.org>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 07/28/2015 03:49 PM, Eric B Munson wrote:
> On Tue, 28 Jul 2015, Michal Hocko wrote:
>

[...]

> The only
> remaining question I have is should we have 2 new mlockall flags so that
> the caller can explicitly set VM_LOCKONFAULT in the mm->def_flags vs
> locking all current VMAs on fault.  I ask because if the user wants to
> lock all current VMAs the old way, but all future VMAs on fault they
> have to call mlockall() twice:
>
> 	mlockall(MCL_CURRENT);
> 	mlockall(MCL_CURRENT | MCL_FUTURE | MCL_ONFAULT);
>
> This has the side effect of converting all the current VMAs to
> VM_LOCKONFAULT, but because they were all made present and locked in the
> first call, this should not matter in most cases.

Shouldn't the user be able to do this?

mlockall(MCL_CURRENT)
mlockall(MCL_FUTURE | MCL_ONFAULT);

Note that the second call shouldn't change (i.e. munlock) existing vma's 
just because MCL_CURRENT is not present. The current implementation 
doesn't do that thanks to the following in do_mlockall():

         if (flags == MCL_FUTURE)
                 goto out;

before current vma's are processed and MCL_CURRENT is checked. This is 
probably so that do_mlockall() can also handle the munlockall() syscall.
So we should be careful not to break this, but otherwise there are no 
limitations by not having two MCL_ONFAULT flags. Having to do invoke 
syscalls instead of one is not an issue as this shouldn't be frequent 
syscall.

> The catch is that,
> like mmap(MAP_LOCKED), mlockall() does not communicate if mm_populate()
> fails.  This has been true of mlockall() from the beginning so I don't
> know if it needs more than an entry in the man page to clarify (which I
> will add when I add documentation for MCL_ONFAULT).

Good point.

> In a much less
> likely corner case, it is not possible in the current setup to request
> all current VMAs be VM_LOCKONFAULT and all future be VM_LOCKED.

So again this should work:

mlockall(MCL_CURRENT | MCL_ONFAULT)
mlockall(MCL_FUTURE);

But the order matters here, as current implementation of do_mlockall() 
will clear VM_LOCKED from def_flags if MCL_FUTURE is not passed. So 
*it's different* from how it handles MCL_CURRENT (as explained above). 
And not documented in manpage. Oh crap, this API is a closet full of 
skeletons. Maybe it was an unnoticed regression and we can restore some 
sanity?
