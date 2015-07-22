From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH V4 2/6] mm: mlock: Add new mlock, munlock, and munlockall
 system calls
Date: Wed, 22 Jul 2015 11:16:10 +0200
Message-ID: <55AF5F5A.3000707@suse.cz>
References: <1437508781-28655-1-git-send-email-emunson@akamai.com> <1437508781-28655-3-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1437508781-28655-3-git-send-email-emunson@akamai.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Heiko Carstens <heiko.carstens@de.ibm.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Catalin Marinas <catalin.marinas@arm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Guenter Roeck <linux@roeck-us.net>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, adi-buildroot-devel@lists.sourceforge.net, linux-cris-kernel@axis.com, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@linux-mips.org, linux-am33-list@redhat.com, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On 07/21/2015 09:59 PM, Eric B Munson wrote:
> With the refactored mlock code, introduce new system calls for mlock,
> munlock, and munlockall.  The new calls will allow the user to specify
> what lock states are being added or cleared.  mlock2 and munlock2 are
> trivial at the moment, but a follow on patch will add a new mlock state
> making them useful.
>
> munlock2 addresses a limitation of the current implementation.  If a

   ^ munlockall2?

> user calls mlockall(MCL_CURRENT | MCL_FUTURE) and then later decides
> that MCL_FUTURE should be removed, they would have to call munlockall()
> followed by mlockall(MCL_CURRENT) which could potentially be very
> expensive.  The new munlockall2 system call allows a user to simply
> clear the MCL_FUTURE flag.
>
