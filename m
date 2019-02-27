From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] numa: Change get_mempolicy() to use nr_node_ids instead
 of MAX_NUMNODES
Date: Wed, 27 Feb 2019 19:38:47 +0100
Message-ID: <32575d26-b141-6985-833a-12d48c0dce6a@suse.cz>
References: <20190211180245.22295-1-rcampbell@nvidia.com>
 <20190211112759.a7441b3486ea0b26dec40786@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190211112759.a7441b3486ea0b26dec40786@linux-foundation.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, rcampbell@nvidia.com
Cc: linux-mm@kvack.org, Waiman Long <longman@redhat.com>, Linux API <linux-api@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, Andi Kleen <ak@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2/11/19 8:27 PM, Andrew Morton wrote:
> On Mon, 11 Feb 2019 10:02:45 -0800 <rcampbell@nvidia.com> wrote:
> 
>> From: Ralph Campbell <rcampbell@nvidia.com>
>> 
>> The system call, get_mempolicy() [1], passes an unsigned long *nodemask
>> pointer and an unsigned long maxnode argument which specifies the
>> length of the user's nodemask array in bits (which is rounded up).
>> The manual page says that if the maxnode value is too small,
>> get_mempolicy will return EINVAL but there is no system call to return
>> this minimum value. To determine this value, some programs search
>> /proc/<pid>/status for a line starting with "Mems_allowed:" and use
>> the number of digits in the mask to determine the minimum value.
>> A recent change to the way this line is formatted [2] causes these
>> programs to compute a value less than MAX_NUMNODES so get_mempolicy()
>> returns EINVAL.
>> 
>> Change get_mempolicy(), the older compat version of get_mempolicy(), and
>> the copy_nodes_to_user() function to use nr_node_ids instead of
>> MAX_NUMNODES, thus preserving the defacto method of computing the
>> minimum size for the nodemask array and the maxnode argument.
>> 
>> [1] http://man7.org/linux/man-pages/man2/get_mempolicy.2.html
>> [2] https://lore.kernel.org/lkml/1545405631-6808-1-git-send-email-longman@redhat.com

Please, the next time include linux-api and people involved in the previous
thread [1] into the CC list. Likely there should have been a Suggested-by: for
Alexander as well.

>> 
> 
> Ugh, what a mess.

I'm afraid it's even somewhat worse mess now.

> For a start, that's a crazy interface.  I wish that had been brought to
> our attention so we could have provided a sane way for userspace to
> determine MAX_NUMNODES.
> 
> Secondly, 4fb8e5b89bcbbb ("include/linux/nodemask.h: use nr_node_ids
> (not MAX_NUMNODES) in __nodemask_pr_numnodes()") introduced a

There's no such commit, that sha was probably from linux-next. The patch is
still in mmotm [1]. Luckily, I would say. Maybe Linus or some automation could
run some script to check for bogus Fixes tags before accepting patches?

> regession.  The proposed get_mempolicy() change appears to be a good
> one, but is a strange way of addressing the regression.  I suppose it's
> acceptable, as long as this change is backported into kernels which
> have 4fb8e5b89bcbbb.

Based on the non-existing sha, hopefully it wasn't backported anywhere, but
maybe some AI did anyway. Ah, seems like it indeed made it as far as 4.9, as a
fix for non-existing commit and without proper linux-api consideration :(
I guess it's too late to revert it for 5.0. Hopefully the change is really safe
and won't break anything, i.e. hopefully nobody was determining MAX_NUMNODES by
increasing buffer size until get_mempolicy() stopped returning EINVAL. Or other
problem in e.g. CRIU context.

What about the manpage? It says "The  value specified by maxnode is less than
the number of node IDs supported by the system." which could be perhaps applied
both to nr_node_ids or MAX_NUMNODES. Or should we update it?

[1]
https://lore.kernel.org/linux-mm/631c44cc-df2d-40d4-a537-d24864df0679@nvidia.com/T/#u
[2]
https://www.ozlabs.org/~akpm/mmotm/broken-out/include-linux-nodemaskh-use-nr_node_ids-not-max_numnodes-in-__nodemask_pr_numnodes.patch
