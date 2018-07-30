From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 2/4] mm: proc/pid/smaps: factor out mem stats gathering
Date: Mon, 30 Jul 2018 10:45:20 +0200
Message-ID: <b45f319f-cd04-337b-37f8-77f99786aa8a@suse.cz>
References: <20180723111933.15443-1-vbabka@suse.cz>
 <20180723111933.15443-3-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180723111933.15443-3-vbabka@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Colascione <dancol@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

(moved thread here)

On 07/26/2018 06:21 PM, Alexey Dobriyan wrote:
> On Wed, Jul 25, 2018 at 08:55:17AM +0200, Vlastimil Babka wrote:
>> On 07/24/2018 08:24 PM, Alexey Dobriyan wrote:
>>> On Mon, Jul 23, 2018 at 04:55:46PM -0700, akpm@linux-foundation.org wrote:
>>>> The patch titled
>>>>      Subject: mm: /proc/pid/smaps: factor out common stats printing
>>>> has been added to the -mm tree.  Its filename is
>>>>      mm-proc-pid-smaps-factor-out-common-stats-printing.patch
>>>> +/* Show the contents common for smaps and smaps_rollup */
>>>> +static void __show_smap(struct seq_file *m, struct mem_size_stats *mss)
>>> This can be "const".
>> What exactly, mss?
> Yes, of course.
> seq_file is changed by virtue of priting to it.

----8<----
>From 71a7c912496db1847e3b265cd30922c4e687b7c2 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 27 Jul 2018 13:56:00 +0200
Subject: [PATCH] mm: proc/pid/smaps: factor out common stats printing-fix

Add const, per Alexey.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1d6d315fd31b..c47f3cab70a1 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -749,7 +749,7 @@ static void smap_gather_stats(struct vm_area_struct *vma,
 		seq_put_decimal_ull_width(m, str, (val) >> 10, 8)
 
 /* Show the contents common for smaps and smaps_rollup */
-static void __show_smap(struct seq_file *m, struct mem_size_stats *mss)
+static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss)
 {
 	SEQ_PUT_DEC("Rss:            ", mss->resident);
 	SEQ_PUT_DEC(" kB\nPss:            ", mss->pss >> PSS_SHIFT);
-- 
2.18.0
