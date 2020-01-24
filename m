From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Add prctl support for controlling mem reclaim V4
Date: Sat, 25 Jan 2020 08:16:42 +1100
Message-ID: <20200124211642.GB7216@dread.disaster.area>
References: <20191112001900.9206-1-mchristi@redhat.com>
 <CALvZod47XyD2x8TuZcb9PgeVY14JBwNhsUpN3RAeAt+RJJC=hg@mail.gmail.com>
 <5E2B19C9.6080907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5E2B19C9.6080907@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, idryomov@gmail.com, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, martin@urbackup.org, Damien.LeMoal@wdc.com, Michal Hocko <mhocko@suse.com>, Masato Suzuki <masato.suzuki@wdc.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 24, 2020 at 10:22:33AM -0600, Mike Christie wrote:
> On 12/05/2019 04:43 PM, Shakeel Butt wrote:
> > On Mon, Nov 11, 2019 at 4:19 PM Mike Christie <mchristi@redhat.com> wrote:
> >> This patch adds a new prctl command that daemons can use after they have
> >> done their initial setup, and before they start to do allocations that
> >> are in the IO path. It sets the PF_MEMALLOC_NOIO and PF_LESS_THROTTLE
> >> flags so both userspace block and FS threads can use it to avoid the
> >> allocation recursion and try to prevent from being throttled while
> >> writing out data to free up memory.
> >>
> >> Signed-off-by: Mike Christie <mchristi@redhat.com>
> >> Acked-by: Michal Hocko <mhocko@suse.com>
> >> Tested-by: Masato Suzuki <masato.suzuki@wdc.com>
> >> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> > 
> > I suppose this patch should be routed through MM tree, so, CCing Andrew.
> >
> 
> Andrew and other mm/storage developers,
> 
> Do I need to handle anything else for this patch, or are there any other
> concerns? Is this maybe something we want to talk about at a quick LSF
> session?
> 
> I have retested it with Linus's current tree. It still applies cleanly
> (just some offsets), and fixes the problem described above we have been
> hitting.

I must have missed this version being posted (just looked it up on
lore.kernel.org). As far as I'm concerned this is good to go and it
is absolutely necessary for userspace IO stacks to function
correctly.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

If no manintainer picks it up before the next merge window, then I
recommend resending the latest version to Linus asking him to merge
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
