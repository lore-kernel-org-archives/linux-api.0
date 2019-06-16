From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: [PATCH NOTFORMERGE 4/5] mm/madvise: employ mmget_still_valid for write lock
Date: Sun, 16 Jun 2019 10:58:34 +0200
Message-ID: <20190616085835.953-5-oleksandr@redhat.com>
References: <20190616085835.953-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190616085835.953-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Do the very same trick as we already do since 04f5866e41fb. KSM hints
will require locking mmap_sem for write since they modify vm_flags, so
for remote KSM hinting this additional check is needed.

Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9755340da157..84f899b1b6da 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1049,6 +1049,8 @@ static int madvise_common(struct task_struct *task, struct mm_struct *mm,
 	if (write) {
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
+		if (current->mm != mm && !mmget_still_valid(mm))
+			goto skip_mm;
 	} else {
 		down_read(&mm->mmap_sem);
 	}
@@ -1099,6 +1101,7 @@ static int madvise_common(struct task_struct *task, struct mm_struct *mm,
 	}
 out:
 	blk_finish_plug(&plug);
+skip_mm:
 	if (write)
 		up_write(&mm->mmap_sem);
 	else
-- 
2.22.0
