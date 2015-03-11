From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 0/2] Move away from non-failing small allocations
Date: Wed, 11 Mar 2015 16:54:52 -0400
Message-ID: <1426107294-21551-1-git-send-email-mhocko@suse.cz>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,
as per discussion at LSF/MM summit few days back it seems there is a
general agreement on moving away from "small allocations do not fail"
concept.

There are two patches in this series. The first one exports a sysctl
knob which controls how hard small allocation (!__GFP_NOFAIL ones of
course) retry when we get completely out of memory before the allocation
fails. The default is still retry infinitely because we cannot simply
change the 14+ years behavior right away. It will take years before all
the potential fallouts are discovered and fixed and we can change the
default value.

The second patch is the first step in the transition plan. It changes
the default but it is NOT an upstream material. It is aimed for brave
testers who can cope with failures. I have talked to Andrew and he
was willing to keep that patch in mmotm tree. It would be even better
to have this in linux-next because the testing coverage would be even
bigger. Dave Chinner has also shown an interest to integrate this into
his xfstest farm. It would be great if Fenguang could add it into the
zero testing project too (if the pushing the patch into linux-next
would be too controversial).
