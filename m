From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 0/2] mm: introduce MAP_FIXED_SAFE
Date: Thu, 14 Dec 2017 14:15:26 +0100
Message-ID: <20171214131526.GM16951@dhcp22.suse.cz>
References: <20171213092550.2774-1-mhocko@kernel.org>
 <20171213163210.6a16ccf8753b74a6982ef5b6@linux-foundation.org>
 <CAFLM3-oANXKEU=tuurSJx9rdzfWGfym-0FUEWnfBq8mOaVMzOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAFLM3-oANXKEU=tuurSJx9rdzfWGfym-0FUEWnfBq8mOaVMzOA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Edward Napierala <trasz@freebsd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Kees Cook <keescook@chromium.org>, jasone@google.com, davidtgoldblatt@gmail.com
List-Id: linux-api@vger.kernel.org

On Thu 14-12-17 12:44:17, Edward Napierala wrote:
> Regarding the name - how about adopting MAP_EXCL?  It was introduced in
> FreeBSD,
> and seems to do exactly this; quoting mmap(2):
> 
> MAP_FIXED    Do not permit the system to select a different address
>                         than the one specified.  If the specified address
>                         cannot be used, mmap() will fail.  If MAP_FIXED is
>                         specified, addr must be a multiple of the page size.
>                         If MAP_EXCL is not specified, a successful MAP_FIXED
>                         request replaces any previous mappings for the
>                         process' pages in the range from addr to addr + len.
>                         In contrast, if MAP_EXCL is specified, the request
>                         will fail if a mapping already exists within the
>                         range.

I am not familiar with the FreeBSD implementation but from the above it
looks like MAP_EXCL is a MAP_FIXED mofifier which is not how we are
going to implement it in linux due to reasons mentioned in this cover
letter. Using the same name would be more confusing than helpful I am
afraid.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
