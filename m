From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH V5 4/7] mm: mlock: Add mlock flags to enable
 VM_LOCKONFAULT usage
Date: Mon, 27 Jul 2015 10:15:18 +0300
Message-ID: <20150727071518.GD11657@node.dhcp.inet.fi>
References: <1437773325-8623-1-git-send-email-emunson@akamai.com>
 <1437773325-8623-5-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1437773325-8623-5-git-send-email-emunson@akamai.com>
Sender: owner-linux-mm@kvack.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 24, 2015 at 05:28:42PM -0400, Eric B Munson wrote:
> The previous patch introduced a flag that specified pages in a VMA
> should be placed on the unevictable LRU, but they should not be made
> present when the area is created.  This patch adds the ability to set
> this state via the new mlock system calls.
> 
> We add MLOCK_ONFAULT for mlock2 and MCL_ONFAULT for mlockall.
> MLOCK_ONFAULT will set the VM_LOCKONFAULT flag as well as the VM_LOCKED
> flag for the target region.  MCL_CURRENT and MCL_ONFAULT are used to
> lock current mappings.  With MCL_CURRENT all pages are made present and
> with MCL_ONFAULT they are locked when faulted in.  When specified with
> MCL_FUTURE all new mappings will be marked with VM_LOCKONFAULT.
> 
> Currently, mlockall() clears all VMA lock flags and then sets the
> requested flags.  For instance, if a process has MCL_FUTURE and
> MCL_CURRENT set, but they want to clear MCL_FUTURE this would be
> accomplished by calling mlockall(MCL_CURRENT).  This still holds with
> the introduction of MCL_ONFAULT.  Each call to mlockall() resets all
> VMA flags to the values specified in the current call.  The new mlock2
> system call behaves in the same way.  If a region is locked with
> MLOCK_ONFAULT and a user wants to force it to be populated now, a second
> call to mlock2(MLOCK_LOCKED) will accomplish this.
> 
> munlock() will unconditionally clear both vma flags.  munlockall()
> unconditionally clears for VMA flags on all VMAs and in the
> mm->def_flags field.
> 
> Signed-off-by: Eric B Munson <emunson@akamai.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
> Cc: linux-alpha@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: sparclinux@vger.kernel.org
> Cc: linux-xtensa@linux-xtensa.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
> Changes from V4:
> * Split addition of VMA flag
> 
> Changes from V3:
> * Do extensive search for VM_LOCKED and ensure that VM_LOCKONFAULT is also handled
>  where appropriate
>  arch/alpha/include/uapi/asm/mman.h   |  2 ++
>  arch/mips/include/uapi/asm/mman.h    |  2 ++
>  arch/parisc/include/uapi/asm/mman.h  |  2 ++
>  arch/powerpc/include/uapi/asm/mman.h |  2 ++
>  arch/sparc/include/uapi/asm/mman.h   |  2 ++
>  arch/tile/include/uapi/asm/mman.h    |  3 +++
>  arch/xtensa/include/uapi/asm/mman.h  |  2 ++

Again, you can save few lines by moving some code into mman-common.h.

Otherwise looks good.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
