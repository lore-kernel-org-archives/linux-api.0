From: robert.foss@collabora.com
Subject: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon,  5 Sep 2016 16:14:06 -0400
Message-ID: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, hughd@google.com, mhocko@suse.com, koct9i@gmail.com, n-horiguchi@ah.jp.nec.com, robert.foss@collabora.com, kirill.shutemov@linux.intel.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, keescook@chromium.org, oleg@redhat.com, viro@zeniv.linux.org.uk, mguzik@redhat.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, ebiederm@xmission.com, sonnyrao@chromium.org, seth.forshee@canonical.com, tixxdz@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Jann Horn <jann@thejh.net>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-api@vger.kernel.org

From: Robert Foss <robert.foss@collabora.com>

This series provides the /proc/PID/totmaps feature, which
summarizes the information provided by /proc/PID/smaps for
improved performance and usability reasons.

A use case is to speed up monitoring of memory consumption in
environments where RSS isn't precise.

For example Chrome tends to many processes which have hundreds of VMAs
with a substantial amount of shared memory, and the error of using
RSS rather than PSS tends to be very large when looking at overall
memory consumption.  PSS isn't kept as a single number that's exported
like RSS, so to calculate PSS means having to parse a very large smaps
file.

This process is slow and has to be repeated for many processes, and we
found that the just act of doing the parsing was taking up a
significant amount of CPU time, so this patch is an attempt to make
that process cheaper.

/proc/PID/totmaps provides roughly a 2x speedup compared to parsing
/proc/PID/smaps with awk.

$ ps aux | grep firefox
robertfoss   5025 24.3 13.7 3562820 2219616 ?     Rl   Aug15 277:44 /usr/lib/firefox/firefox https://allg.one/xpb
$ awk '/^[0-9a-f]/{print}' /proc/5025/smaps | wc -l
1503
$ /usr/bin/time -v -p zsh -c "(repeat 25 {cat /proc/5025/totmaps})"
[...]
	Command being timed: "zsh -c (repeat 25 {cat /proc/5025/totmaps})"
	User time (seconds): 0.00
	System time (seconds): 0.40
	Percent of CPU this job got: 90%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.45

$ /usr/bin/time -v -p zsh -c "repeat 25 { awk '/^Rss/{rss+=\$2} /^Pss/{pss+=\$2} END {printf \"rss:%d pss:%d\n\", rss, pss}\' /proc/5025/smaps }"
[...]
	Command being timed: "zsh -c repeat 25 { awk '/^Rss/{rss+=$2} /^Pss/{pss+=$2} END {printf "rss:%d pss:%d\n", rss, pss}\' /proc/5025/smaps }"
	User time (seconds): 0.37
	System time (seconds): 0.45
	Percent of CPU this job got: 92%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.89


Changes since v1:
- Removed IS_ERR check from get_task_mm() function
- Changed comment format
- Moved proc_totmaps_operations declaration inside internal.h
- Switched to using do_maps_open() in totmaps_open() function,
  which provides privilege checking
- Error handling reworked for totmaps_open() function
- Switched to stack allocated struct mem_size_stats mss_sum in
  totmaps_proc_show() function
- Removed get_task_mm() in totmaps_proc_show() since priv->mm
  already is available
- Added support to proc_map_release() fork priv==NULL, to allow
  function to be used for all failure cases
- Added proc_totmaps_op and for it helper functions
- Added documention in separate patch
- Removed totmaps_release() since it was just a wrapper for proc_map_release()

Changes since v2:
- Removed struct mem_size_stats *mss from struct proc_maps_private
- Removed priv->task assignment in totmaps_open() call
- Moved some assignements calls totmaps_open() around to increase code
  clarity
- Moved some function calls to unlock data structures before printing

Changes since v3:
- Fixed typo in totmaps documentation
- Fixed issue where proc_map_release wasn't called on error
- Fixed put_task_struct not being called during .release()

Changes since v4:
- Prevent access to invalid processes

Robert Foss (3):
  mm, proc: Implement /proc/<pid>/totmaps
  Documentation/filesystems: Fixed typo
  Documentation/filesystems: Added /proc/PID/totmaps documentation

 Documentation/filesystems/proc.txt |  23 +++++-
 fs/proc/base.c                     |   1 +
 fs/proc/internal.h                 |   2 +
 fs/proc/task_mmu.c                 | 148 +++++++++++++++++++++++++++++++++++++
 4 files changed, 173 insertions(+), 1 deletion(-)

-- 
2.7.4
