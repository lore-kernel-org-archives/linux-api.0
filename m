From: Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 5/8] mm/madvise: employ mmget_still_valid for write lock
Date: Wed, 12 Feb 2020 15:39:43 -0800
Message-ID: <20200212233946.246210-6-minchan@kernel.org>
References: <20200212233946.246210-1-minchan@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200212233946.246210-1-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-api@vger.kernel.org, oleksandr@redhat.com, Suren Baghdasaryan <surenb@google.com>, Tim Murray <timmurray@google.com>, Daniel Colascione <dancol@google.com>, Sandeep Patil <sspatil@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, John Dias <joaodias@google.com>, Joel Fernandes <joel@joelfernandes.org>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Minchan Kim <minchan@kernel.org>
List-Id: linux-api@vger.kernel.org

From: Oleksandr Natalenko <oleksandr@redhat.com>

Do the very same trick as we already do since 04f5866e41fb. KSM hints
will require locking mmap_sem for write since they modify vm_flags, so
for remote KSM hinting this additional check is needed.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 276b9d81c1dd..71f0ba199ae8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1120,6 +1120,8 @@ int do_madvise(struct task_struct *task, unsigned long start,
 	if (write) {
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
+		if (current->mm != mm && !mmget_still_valid(mm))
+			goto skip_mm;
 	} else {
 		down_read(&mm->mmap_sem);
 	}
@@ -1170,6 +1172,7 @@ int do_madvise(struct task_struct *task, unsigned long start,
 	}
 out:
 	blk_finish_plug(&plug);
+skip_mm:
 	if (write)
 		up_write(&mm->mmap_sem);
 	else
-- 
2.25.0.225.g125e21ebc7-goog
