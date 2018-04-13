From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mmap.2: MAP_FIXED is okay if the address range has been
 reserved
Date: Fri, 13 Apr 2018 08:49:17 +0200
Message-ID: <20180413064917.GC17484@dhcp22.suse.cz>
References: <20180412153941.170849-1-jannh@google.com>
 <b617740b-fd07-e248-2ba0-9e99b0240594@nvidia.com>
 <CAKgNAkgcJ2kCTff0=7=D3zPFwpJt-9EM8yis6-4qDjfvvb8ukw@mail.gmail.com>
 <CAG48ez2NtCr8+HqnKJTFBcLW+kCKUa=2pz=7HD9p9u1p-MfJqw@mail.gmail.com>
 <13801e2a-c44d-e940-f872-890a0612a483@nvidia.com>
 <CAG48ez085cASur3kZTRkdJY20dFZ4Yqc1KVOHxnCAn58_NtW8w@mail.gmail.com>
 <cfbbbe06-5e63-e43c-fb28-c5afef9e1e1d@nvidia.com>
 <9c714917-fc29-4d12-b5e8-cff28761a2c1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9c714917-fc29-4d12-b5e8-cff28761a2c1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Jann Horn <jannh@google.com>, linux-man <linux-man@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri 13-04-18 08:43:27, Michael Kerrisk wrote:
[...]
> So, you mean remove this entire paragraph:
> 
>               For cases in which the specified memory region has not been
>               reserved using an existing mapping,  newer  kernels  (Linux
>               4.17  and later) provide an option MAP_FIXED_NOREPLACE that
>               should be used instead; older kernels require the caller to
>               use addr as a hint (without MAP_FIXED) and take appropriate
>               action if the kernel places the new mapping at a  different
>               address.
> 
> It seems like some version of the first half of the paragraph is worth 
> keeping, though, so as to point the reader in the direction of a remedy.
> How about replacing that text with the following:
> 
>               Since  Linux 4.17, the MAP_FIXED_NOREPLACE flag can be used
>               in a multithreaded program to avoid  the  hazard  described
>               above.

Yes, that sounds reasonable to me.

-- 
Michal Hocko
SUSE Labs
