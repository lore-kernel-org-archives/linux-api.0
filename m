From: Roman Gushchin <guro@fb.com>
Subject: [PATCH] mm: don't show nr_indirectly_reclaimable in /proc/vmstat
Date: Wed, 25 Apr 2018 20:14:22 +0100
Message-ID: <20180425191422.9159-1-guro@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>
List-Id: linux-api@vger.kernel.org

Don't show nr_indirectly_reclaimable in /proc/vmstat,
because there is no need in exporting this vm counter
to the userspace, and some changes are expected
in reclaimable object accounting, which can alter
this counter.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmstat.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 536332e988b8..a2b9518980ce 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1161,7 +1161,7 @@ const char * const vmstat_text[] = {
 	"nr_vmscan_immediate_reclaim",
 	"nr_dirtied",
 	"nr_written",
-	"nr_indirectly_reclaimable",
+	"", /* nr_indirectly_reclaimable */
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
@@ -1740,6 +1740,10 @@ static int vmstat_show(struct seq_file *m, void *arg)
 	unsigned long *l = arg;
 	unsigned long off = l - (unsigned long *)m->private;
 
+	/* Skip hidden vmstat items. */
+	if (*vmstat_text[off] == '\0')
+		return 0;
+
 	seq_puts(m, vmstat_text[off]);
 	seq_put_decimal_ull(m, " ", *l);
 	seq_putc(m, '\n');
-- 
2.14.3
