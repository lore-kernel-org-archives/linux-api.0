From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mmap.2: document new MAP_FIXED_NOREPLACE flag
Date: Thu, 12 Apr 2018 10:21:18 +0200
Message-ID: <20180412082118.GT23400@dhcp22.suse.cz>
References: <20180411120452.1736-1-mhocko@kernel.org>
 <97504dda-4252-a150-e7b5-43fe587aa055@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97504dda-4252-a150-e7b5-43fe587aa055@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu 12-04-18 10:04:06, Michael Kerrisk wrote:
> Hello Michal,
> 
> On 04/11/2018 02:04 PM, mhocko@kernel.org wrote:
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > 4.17+ kernels offer a new MAP_FIXED_NOREPLACE flag which allows the caller to
> > atomicaly probe for a given address range.
> > 
> > [wording heavily updated by John Hubbard <jhubbard@nvidia.com>]
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> 
> Thanks! I've applied your patch, and done a little tweaking. The results
> have already been pushed.

Thanks!
-- 
Michal Hocko
SUSE Labs
