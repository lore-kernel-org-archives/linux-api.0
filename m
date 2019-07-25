From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [v4 PATCH 2/2] mm: mempolicy: handle vma with unmovable pages
 mapped correctly in mbind
Date: Wed, 24 Jul 2019 17:44:23 -0700
Message-ID: <20190724174423.1826c92f72ce9c815ebc72d9@linux-foundation.org>
References: <1563556862-54056-1-git-send-email-yang.shi@linux.alibaba.com>
        <1563556862-54056-3-git-send-email-yang.shi@linux.alibaba.com>
        <6c948a96-7af1-c0d2-b3df-5fe613284d4f@suse.cz>
        <20190722180231.b7abbe8bdb046d725bdd9e6b@linux-foundation.org>
        <a9b8cae7-4bca-3c98-99f9-6b92de7e5909@linux.alibaba.com>
        <6aeca7cf-d9da-95cc-e6dc-a10c2978c523@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6aeca7cf-d9da-95cc-e6dc-a10c2978c523@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <yang.shi@linux.alibaba.com>, mhocko@kernel.org, mgorman@techsingularity.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 24 Jul 2019 10:19:34 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 7/23/19 7:35 AM, Yang Shi wrote:
> > 
> > 
> > On 7/22/19 6:02 PM, Andrew Morton wrote:
> >> On Mon, 22 Jul 2019 09:25:09 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
> >>
> >>>> since there may be pages off LRU temporarily.  We should migrate other
> >>>> pages if MPOL_MF_MOVE* is specified.  Set has_unmovable flag if some
> >>>> paged could not be not moved, then return -EIO for mbind() eventually.
> >>>>
> >>>> With this change the above test would return -EIO as expected.
> >>>>
> >>>> Cc: Vlastimil Babka <vbabka@suse.cz>
> >>>> Cc: Michal Hocko <mhocko@suse.com>
> >>>> Cc: Mel Gorman <mgorman@techsingularity.net>
> >>>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> >>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> >> Thanks.
> >>
> >> I'm a bit surprised that this doesn't have a cc:stable.  Did we
> >> consider that?
> > 
> > The VM_BUG just happens on 4.9, and it is enabled only by CONFIG_VM. For 
> > post-4.9 kernel, this fixes the semantics of mbind which should be not a 
> > regression IMHO.
> 
> 4.9 is a LTS kernel, so perhaps worth trying?
> 

OK, I'll add cc:stable to 

mm-mempolicy-make-the-behavior-consistent-when-mpol_mf_move-and-mpol_mf_strict-were-specified.patch

and

mm-mempolicy-handle-vma-with-unmovable-pages-mapped-correctly-in-mbind.patch

Do we have a Fixes: for these patches?
