From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] numa: Change get_mempolicy() to use nr_node_ids instead
 of MAX_NUMNODES
Date: Thu, 28 Feb 2019 21:43:56 +0100
Message-ID: <adaf3f9c-ac69-9a0d-962c-a21d6e003fbd@suse.cz>
References: <20190211180245.22295-1-rcampbell@nvidia.com>
 <20190211112759.a7441b3486ea0b26dec40786@linux-foundation.org>
 <32575d26-b141-6985-833a-12d48c0dce6a@suse.cz>
 <20190228111110.564d84f62a1b294ca5b1f9df@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190228111110.564d84f62a1b294ca5b1f9df@linux-foundation.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rcampbell@nvidia.com, linux-mm@kvack.org, Waiman Long <longman@redhat.com>, Linux API <linux-api@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, Andi Kleen <ak@linux.intel.com>, Florian Weimer <fweimer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2/28/19 8:11 PM, Andrew Morton wrote:
>>> Secondly, 4fb8e5b89bcbbb ("include/linux/nodemask.h: use nr_node_ids
>>> (not MAX_NUMNODES) in __nodemask_pr_numnodes()") introduced a
>>
>> There's no such commit, that sha was probably from linux-next. The patch is
>> still in mmotm [1]. Luckily, I would say. Maybe Linus or some automation could
>> run some script to check for bogus Fixes tags before accepting patches?
> 
> Ah, that's a relief.
> 
> How about we just drop "include/linux/nodemask.h: use nr_node_ids (not
> MAX_NUMNODES) in __nodemask_pr_numnodes()"
> (https://ozlabs.org/~akpm/mmotm/broken-out/include-linux-nodemaskh-use-nr_node_ids-not-max_numnodes-in-__nodemask_pr_numnodes.patch)?
> It's just a cosmetic thing, really.

Yeah the risk of breaking something is not worth it, IMHO.
