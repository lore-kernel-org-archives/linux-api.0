From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 0/2] Move away from non-failing small allocations
Date: Mon, 16 Mar 2015 15:38:43 -0700
Message-ID: <20150316153843.af945a9e452404c22c4db999@linux-foundation.org>
References: <1426107294-21551-1-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426107294-21551-1-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 11 Mar 2015 16:54:52 -0400 Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> as per discussion at LSF/MM summit few days back it seems there is a
> general agreement on moving away from "small allocations do not fail"
> concept.

Such a change affects basically every part of the kernel and every
kernel developer.  I expect most developers will say "it works well
enough and I'm not getting any bug reports so why should I spend time
on this?".  It would help if we were to explain the justification very
clearly.  https://lwn.net/Articles/636017/ is Jon's writeup of the
conference discussion.

Realistically, I don't think this overall effort will be successful -
we'll add the knob, it won't get enough testing and any attempt to
alter the default will be us deliberately destabilizing the kernel
without knowing how badly :(


I wonder if we can alter the behaviour only for filesystem code, so we
constrain the new behaviour just to that code where we're having
problems.  Most/all fs code goes via vfs methods so there's a reasonably
small set of places where we can call

static inline void enter_fs_code(struct super_block *sb)
{
	if (sb->my_small_allocations_can_fail)
		current->small_allocations_can_fail++;
}

that way (or something similar) we can select the behaviour on a per-fs
basis and the rest of the kernel remains unaffected.  Other subsystems
can opt in as well.
