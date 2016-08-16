From: robert.foss@collabora.com
Subject: [PACTH v3 2/3] Documentation/filesystems: Fixed typo
Date: Tue, 16 Aug 2016 13:34:15 -0400
Message-ID: <1471368856-11455-3-git-send-email-robert.foss@collabora.com>
References: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471368856-11455-1-git-send-email-robert.foss@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, mhocko@suse.com, koct9i@gmail.com, hughd@google.com, robert.foss@collabora.com, n-horiguchi@ah.jp.nec.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, mingo@kernel.org, keescook@chromium.org, viro@zeniv.linux.org.uk, gorcunov@openvz.org, sonnyrao@chromium.org, plaguedbypenguins@gmail.com, eric.engestrom@imgtec.com, rientjes@google.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, jann@thejh.net, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Mateusz Guzik <mguzik@redhat.com>, Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Robert Foss <robert.foss@collabora.com>

Fixed a -> an typo.

Signed-off-by: Robert Foss <robert.foss@collabora.com>
---
 Documentation/filesystems/proc.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index e8d0075..7d001be 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -145,7 +145,7 @@ Table 1-1: Process specific entries in /proc
 		symbol the task is blocked in - or "0" if not blocked.
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
- smaps		a extension based on maps, showing the memory consumption of
+ smaps		an extension based on maps, showing the memory consumption of
 		each mapping and flags associated with it
  numa_maps	an extension based on maps, showing the memory locality and
 		binding policy as well as mem usage (in pages) of each mapping.
-- 
2.7.4
