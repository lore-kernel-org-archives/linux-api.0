From: Michal Hocko <mhocko@kernel.org>
Subject: [RFC PATCH] mm, proc: report PR_SET_THP_DISABLE in proc
Date: Tue, 2 Oct 2018 13:28:51 +0200
Message-ID: <20181002112851.GP18290@dhcp22.suse.cz>
References: <alpine.DEB.2.21.1809241215170.239142@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1809241227370.241621@chino.kir.corp.google.com>
 <20180924195603.GJ18685@dhcp22.suse.cz>
 <20180924200258.GK18685@dhcp22.suse.cz>
 <0aa3eb55-82c0-eba3-b12c-2ba22e052a8e@suse.cz>
 <alpine.DEB.2.21.1809251248450.50347@chino.kir.corp.google.com>
 <20180925202959.GY18685@dhcp22.suse.cz>
 <alpine.DEB.2.21.1809251440001.94921@chino.kir.corp.google.com>
 <20180925150406.872aab9f4f945193e5915d69@linux-foundation.org>
 <20180926060624.GA18685@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180926060624.GA18685@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 26-09-18 08:06:24, Michal Hocko wrote:
> On Tue 25-09-18 15:04:06, Andrew Morton wrote:
> > On Tue, 25 Sep 2018 14:45:19 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> > 
> > > > > It is also used in 
> > > > > automated testing to ensure that vmas get disabled for thp appropriately 
> > > > > and we used "nh" since that is how PR_SET_THP_DISABLE previously enforced 
> > > > > this, and those tests now break.
> > > > 
> > > > This sounds like a bit of an abuse to me. It shows how an internal
> > > > implementation detail leaks out to the userspace which is something we
> > > > should try to avoid.
> > > > 
> > > 
> > > Well, it's already how this has worked for years before commit 
> > > 1860033237d4 broke it.  Changing the implementation in the kernel is fine 
> > > as long as you don't break userspace who relies on what is exported to it 
> > > and is the only way to determine if MADV_NOHUGEPAGE is preventing it from 
> > > being backed by hugepages.
> > 
> > 1860033237d4 was over a year ago so perhaps we don't need to be
> > too worried about restoring the old interface.  In which case
> > we have an opportunity to make improvements such as that suggested
> > by Michal?
> 
> Yeah, can we add a way to export PR_SET_THP_DISABLE to userspace
> somehow? E.g. /proc/<pid>/status. It is a process wide thing so
> reporting it per VMA sounds strange at best.

So how about this? (not tested yet but it should be pretty
straightforward)
--- 
>From 048b29102de326900b54cce78b614345cd77a230 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Tue, 2 Oct 2018 10:53:48 +0200
Subject: [PATCH] mm, proc: report PR_SET_THP_DISABLE in proc

David Rientjes has reported that 1860033237d4 ("mm: make
PR_SET_THP_DISABLE immediately active") has changed the way how
we report THPable VMAs to the userspace. Their monitoring tool is
triggering false alarms on PR_SET_THP_DISABLE tasks because it considers
an insufficient THP usage as a memory fragmentation resp. memory
pressure issue.

Before the said commit each newly created VMA inherited VM_NOHUGEPAGE
flag and that got exposed to the userspace via /proc/<pid>/smaps file.
This implementation had its downsides as explained in the commit message
but it is true that the userspace doesn't have any means to query for
the process wide THP enabled/disabled status.

PR_SET_THP_DISABLE is a process wide flag so it makes a lot of sense
to export in the process wide context rather than per-vma. Introduce
a new field to /proc/<pid>/status which export this status.  If
PR_SET_THP_DISABLE is used the it reports false same as when the THP is
not compiled in. It doesn't consider the global THP status because we
already export that information via sysfs

Fixes: 1860033237d4 ("mm: make PR_SET_THP_DISABLE immediately active")
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 Documentation/filesystems/proc.txt |  3 +++
 fs/proc/array.c                    | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 22b4b00dee31..bafa5cb1685a 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -182,6 +182,7 @@ For example, to get the status information of a process, all you have to do is
   VmSwap:        0 kB
   HugetlbPages:          0 kB
   CoreDumping:    0
+  THP_enabled:	  1
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -256,6 +257,8 @@ Table 1-2: Contents of the status files (as of 4.8)
  HugetlbPages                size of hugetlb memory portions
  CoreDumping                 process's memory is currently being dumped
                              (killing the process may lead to a corrupted core)
+ THP_enabled		     process is allowed to use THP (returns 0 when
+			     PR_SET_THP_DISABLE is set on the process
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 0ceb3b6b37e7..9d428d5a0ac8 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -392,6 +392,15 @@ static inline void task_core_dumping(struct seq_file *m, struct mm_struct *mm)
 	seq_putc(m, '\n');
 }
 
+static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
+{
+	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
+
+	if (thp_enabled)
+		thp_enabled = !test_bit(MMF_DISABLE_THP, &mm->flags);
+	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
+}
+
 int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
@@ -406,6 +415,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	if (mm) {
 		task_mem(m, mm);
 		task_core_dumping(m, mm);
+		task_thp_status(m, mm);
 		mmput(mm);
 	}
 	task_sig(m, task);
-- 
2.19.0

-- 
Michal Hocko
SUSE Labs
