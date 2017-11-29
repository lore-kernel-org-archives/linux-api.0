From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH 2/2] fs, elf: drop MAP_FIXED usage from elf_map
Date: Wed, 29 Nov 2017 10:45:43 -0700
Message-ID: <93ce964b-e352-1905-c2b6-deedf2ea06f8@oracle.com>
References: <20171129144219.22867-1-mhocko@kernel.org>
 <20171129144219.22867-3-mhocko@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171129144219.22867-3-mhocko@kernel.org>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On 11/29/2017 07:42 AM, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> Both load_elf_interp and load_elf_binary rely on elf_map to map segments
> on a controlled address and they use MAP_FIXED to enforce that. This is
> however dangerous thing prone to silent data corruption which can be
> even exploitable. Let's take CVE-2017-1000253 as an example. At the time
> (before eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE"))
> ELF_ET_DYN_BASE was at TASK_SIZE / 3 * 2 which is not that far away from
> the stack top on 32b (legacy) memory layout (only 1GB away). Therefore
> we could end up mapping over the existing stack with some luck.
> 
> The issue has been fixed since then (a87938b2e246 ("fs/binfmt_elf.c:
> fix bug in loading of PIE binaries")), ELF_ET_DYN_BASE moved moved much
> further from the stack (eab09532d400 and later by c715b72c1ba4 ("mm:
> revert x86_64 and arm64 ELF_ET_DYN_BASE base changes")) and excessive
> stack consumption early during execve fully stopped by da029c11e6b1
> ("exec: Limit arg stack to at most 75% of _STK_LIM"). So we should be
> safe and any attack should be impractical. On the other hand this is
> just too subtle assumption so it can break quite easily and hard to
> spot.
> 
> I believe that the MAP_FIXED usage in load_elf_binary (et. al) is still
> fundamentally dangerous. Moreover it shouldn't be even needed. We are
> at the early process stage and so there shouldn't be unrelated mappings
> (except for stack and loader) existing so mmap for a given address
> should succeed even without MAP_FIXED. Something is terribly wrong if
> this is not the case and we should rather fail than silently corrupt the
> underlying mapping.
> 
> Address this issue by changing MAP_FIXED to the newly added
> MAP_FIXED_SAFE. This will mean that mmap will fail if there is an
> existing mapping clashing with the requested one without clobbering it.
> 
> Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Cc: Joel Stanley <joel@jms.id.au>
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
