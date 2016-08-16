From: robert.foss@collabora.com
Subject: [PACTH v3 0/3] Implement /proc/<pid>/totmaps
Date: Tue, 16 Aug 2016 13:34:13 -0400
Message-ID: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, robert.foss@collabora.com, n-horiguchi@ah.jp.nec.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, sonnyrao@chromium.org, plaguedbypenguins@gmail.com, eric.engestrom@imgtec.com, rientjes@google.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, jann@thejh.net, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
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

$ /usr/bin/time -v -p zsh -c "(repeat 25 {cat /proc/5025/totmaps})"
[...]
        Command being timed: "zsh -c (repeat 25 {cat /proc/5025/totmaps})"
        User time (seconds): 0.00
        System time (seconds): 0.40
        Percent of CPU this job got: 90%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.45


$ /usr/bin/time -v -p zsh -c "repeat 25 { awk '/^Rss/{rss+=\$2} /^Pss/{pss+=\$2} END {printf \"rss:%d pss:%d\n\", rss, pss}\' /proc/5025/smaps}"
[...]
        Command being timed: "zsh -c repeat 25 { awk '/^Rss/{rss+=$2}
/^Pss/{pss+=$2} END {printf "rss:%d pss:%d\n", rss, pss}\' /proc/5025/smaps }"
        User time (seconds): 0.37
        System time (seconds): 0.45
        Percent of CPU this job got: 92%
        Elapsed (wall clock) time (h:mm:ss or m:ss): 0:00.89

Robert Foss (3):
  mm, proc: Implement /proc/<pid>/totmaps
  Documentation/filesystems: Fixed typo
  Documentation/filesystems: Added /proc/PID/totmaps documentation

 Documentation/filesystems/proc.txt |  23 ++++++-
 fs/proc/base.c                     |   1 +
 fs/proc/internal.h                 |   2 +
 fs/proc/task_mmu.c                 | 129 +++++++++++++++++++++++++++++++++++++
 4 files changed, 154 insertions(+), 1 deletion(-)

-- 
2.7.4

