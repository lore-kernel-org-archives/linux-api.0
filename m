From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 3/8] mm: validate mm in do_madvise
Date: Wed, 12 Feb 2020 15:39:41 -0800
Message-ID: <20200212233946.246210-4-minchan@kernel.org>
References: <20200212233946.246210-1-minchan@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200212233946.246210-1-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, Joel Fernandes <joel@joelfernandes.org>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Minchan Kim <minchan@kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

Oleg pointed out mm could be nulllified right after mm_access succeeds.
This patch validates it before the using.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/madvise.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 8611f1d39289..bb04c7897eb9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1073,7 +1073,11 @@ int do_madvise(struct task_struct *task, unsigned long start,
 	int write;
 	size_t len;
 	struct blk_plug plug;
-	struct mm_struct *mm = task->mm;
+	struct mm_struct *mm = READ_ONCE(task->mm);
+
+	/* task can exit and nullify its ->mm right after mm_access() */
+	if (!mm)
+		return -ESRCH;
 
 	start = untagged_addr(start);
 
-- 
2.25.0.225.g125e21ebc7-goog
