From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] numa: Change get_mempolicy() to use nr_node_ids instead
 of MAX_NUMNODES
Date: Thu, 28 Feb 2019 11:11:10 -0800
Message-ID: <20190228111110.564d84f62a1b294ca5b1f9df@linux-foundation.org>
References: <20190211180245.22295-1-rcampbell@nvidia.com>
        <20190211112759.a7441b3486ea0b26dec40786@linux-foundation.org>
        <32575d26-b141-6985-833a-12d48c0dce6a@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <32575d26-b141-6985-833a-12d48c0dce6a@suse.cz>
Sender: stable-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: rcampbell@nvidia.com, linux-mm@kvack.org, Waiman Long <longman@redhat.com>, Linux API <linux-api@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, Andi Kleen <ak@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 27 Feb 2019 19:38:47 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 2/11/19 8:27 PM, Andrew Morton wrote:
> > On Mon, 11 Feb 2019 10:02:45 -0800 <rcampbell@nvidia.com> wrote:
> > 
> >> From: Ralph Campbell <rcampbell@nvidia.com>
> >> 
> >> The system call, get_mempolicy() [1], passes an unsigned long *nodemask
> >> pointer and an unsigned long maxnode argument which specifies the
> >> length of the user's nodemask array in bits (which is rounded up).
> >> The manual page says that if the maxnode value is too small,
> >> get_mempolicy will return EINVAL but there is no system call to return
> >> this minimum value. To determine this value, some programs search
> >> /proc/<pid>/status for a line starting with "Mems_allowed:" and use
> >> the number of digits in the mask to determine the minimum value.
> >> A recent change to the way this line is formatted [2] causes these
> >> programs to compute a value less than MAX_NUMNODES so get_mempolicy()
> >> returns EINVAL.
> >> 
> >> Change get_mempolicy(), the older compat version of get_mempolicy(), and
> >> the copy_nodes_to_user() function to use nr_node_ids instead of
> >> MAX_NUMNODES, thus preserving the defacto method of computing the
> >> minimum size for the nodemask array and the maxnode argument.
> >> 
> >> [1] http://man7.org/linux/man-pages/man2/get_mempolicy.2.html
> >> [2] https://lore.kernel.org/lkml/1545405631-6808-1-git-send-email-longman@redhat.com
> 
> Please, the next time include linux-api and people involved in the previous
> thread [1] into the CC list. Likely there should have been a Suggested-by: for
> Alexander as well.
> 
> >> 
> > 
> > Ugh, what a mess.
> 
> I'm afraid it's even somewhat worse mess now.
> 
> > For a start, that's a crazy interface.  I wish that had been brought to
> > our attention so we could have provided a sane way for userspace to
> > determine MAX_NUMNODES.
> > 
> > Secondly, 4fb8e5b89bcbbb ("include/linux/nodemask.h: use nr_node_ids
> > (not MAX_NUMNODES) in __nodemask_pr_numnodes()") introduced a
> 
> There's no such commit, that sha was probably from linux-next. The patch is
> still in mmotm [1]. Luckily, I would say. Maybe Linus or some automation could
> run some script to check for bogus Fixes tags before accepting patches?

Ah, that's a relief.

How about we just drop "include/linux/nodemask.h: use nr_node_ids (not
MAX_NUMNODES) in __nodemask_pr_numnodes()"
(https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-nodemaskh-use-nr_node_ids-not-max_numnodes-in-__nodemask_pr_numnodes.patch)?
It's just a cosmetic thing, really.
