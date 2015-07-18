From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH V3 4/5] mm: mmap: Add mmap flag to request VM_LOCKONFAULT
Date: Sat, 18 Jul 2015 15:11:23 -0400
Message-ID: <CAP=VYLq5=9DCfncJpQizcSbQt1O7VL2yEdzZNOFK+M3pqLpb3Q@mail.gmail.com>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com> <1436288623-13007-5-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1436288623-13007-5-git-send-email-emunson@akamai.com>
Sender: linux-next-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-arch <linux-arch@vger.kernel.org>, linux-api@vger.kernel.org, cmetcalf@ezchip.com, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 7, 2015 at 1:03 PM, Eric B Munson <emunson@akamai.com> wrot=
e:
> The cost of faulting in all memory to be locked can be very high when
> working with large mappings.  If only portions of the mapping will be
> used this can incur a high penalty for locking.
>
> Now that we have the new VMA flag for the locked but not present stat=
e,
> expose it  as an mmap option like MAP_LOCKED -> VM_LOCKED.

An automatic bisection on arch/tile leads to this commit:

5a5656f2c9b61c74c15f9ef3fa2e6513b6c237bb is the first bad commit
commit 5a5656f2c9b61c74c15f9ef3fa2e6513b6c237bb
Author: Eric B Munson <emunson@akamai.com>
Date:   Thu Jul 16 10:09:22 2015 +1000

    mm: mmap: add mmap flag to request VM_LOCKONFAULT

=46ails with:

In file included from arch/tile/mm/init.c:24:
include/linux/mman.h: In function =E2=80=98calc_vm_flag_bits=E2=80=99:
include/linux/mman.h:90: error: =E2=80=98MAP_LOCKONFAULT=E2=80=99 undec=
lared (first
use in this function)
include/linux/mman.h:90: error: (Each undeclared identifier is
reported only once
include/linux/mman.h:90: error: for each function it appears in.)
In file included from arch/tile/mm/mmap.c:21:
include/linux/mman.h: In function =E2=80=98calc_vm_flag_bits=E2=80=99:
include/linux/mman.h:90: error: =E2=80=98MAP_LOCKONFAULT=E2=80=99 undec=
lared (first
use in this function)
include/linux/mman.h:90: error: (Each undeclared identifier is
reported only once
include/linux/mman.h:90: error: for each function it appears in.)
In file included from arch/tile/mm/fault.c:24:
include/linux/mman.h: In function =E2=80=98calc_vm_flag_bits=E2=80=99:
include/linux/mman.h:90: error: =E2=80=98MAP_LOCKONFAULT=E2=80=99 undec=
lared (first
use in this function)
include/linux/mman.h:90: error: (Each undeclared identifier is
reported only once
include/linux/mman.h:90: error: for each function it appears in.)
In file included from arch/tile/mm/hugetlbpage.c:27:
include/linux/mman.h: In function =E2=80=98calc_vm_flag_bits=E2=80=99:
include/linux/mman.h:90: error: =E2=80=98MAP_LOCKONFAULT=E2=80=99 undec=
lared (first
use in this function)
include/linux/mman.h:90: error: (Each undeclared identifier is
reported only once
include/linux/mman.h:90: error: for each function it appears in.)
make[1]: *** [arch/tile/mm/hugetlbpage.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/12465365/

Paul.
--
