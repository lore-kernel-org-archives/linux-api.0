From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] mmap.2: MAP_FIXED updated documentation
Date: Mon, 4 Dec 2017 18:14:18 -0800
Message-ID: <efb6eae4-7f30-42c3-0efe-0ab5fbf0fdb4@nvidia.com>
References: <20171204021411.4786-1-jhubbard@nvidia.com>
 <20171204105549.GA31332@rei>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171204105549.GA31332@rei>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-man <linux-man@vger.kernel.org>, linux-api@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>
List-Id: linux-api@vger.kernel.org

On 12/04/2017 02:55 AM, Cyril Hrubis wrote:
> Hi!
> I know that we are not touching the rest of the existing description for
> MAP_FIXED however the second sentence in the manual page says that "addr
> must be a multiple of the page size." Which however is misleading as
> this is not enough on some architectures. Code in the wild seems to
> (mis)use SHMLBA for aligment purposes but I'm not sure that we should
> advise something like that in the manpages.
> 
> So what about something as:
> 
> "addr must be suitably aligned, for most architectures multiple of page
> size is sufficient, however some may impose additional restrictions for
> page mapping addresses."
> 

Hi Cyril,

Right, so I've been looking into this today, and I think we can go a bit
further than that, even. The kernel, as far back as the *original* git
commit in 2005, implements mmap on ARM by requiring that the address is
aligned to SHMLBA:

arch/arm/mm/mmap.c:50:

	if (flags & MAP_FIXED) {
		if (aliasing && flags & MAP_SHARED &&
		    (addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1))
			return -EINVAL;
		return addr;
	}

So, given that this has been the implementation for the last 12+ years (and
probably the whole time, in fact), I think we can be bold enough to use this
wording for the second sentence of MAP_FIXED:

"addr must be a multiple of SHMLBA (<sys/shm.h>), which in turn is either
the system page size (on many architectures) or a multiple of the system
page size (on some architectures)."

What do you think?

thanks,
John Hubbard
NVIDIA

> Which should at least hint the reader that this is architecture specific.
> 
