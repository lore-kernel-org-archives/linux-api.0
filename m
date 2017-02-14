From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v3 0/4] Improved seccomp logging
Date: Tue, 14 Feb 2017 03:45:24 +0000
Message-ID: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, John Crispin <john@phrozen.org>, linux-api@ver.kernel.org
List-Id: linux-api@vger.kernel.org

This patch set is the third revision of the following two previously
submitted patch sets:

v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyhicks@canonical.com
v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyhicks@canonical.com

v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyhicks@canonical.com

The patch set aims to address some known deficiencies in seccomp's current
logging capabilities:

  1. Inability to log all filter actions.
  2. Inability to selectively enable filtering; e.g. devs want noisy logging,
     users want relative quiet.
  3. Consistent behavior with audit enabled and disabled.
  4. Inability to easily develop a filter due to the lack of a
     permissive/complain mode.

Changes since v2 to address feedback from Kees:
- Patch 1
  + Log a warning when sysctl registration fails
  + Move comment describing SECCOMP_RET_*_NAME from PATCH 2
  + Document the actions_avail sysctl
- Patch 2
  + Inline seccomp_log()
  + Optimize logging for RET_ALLOW hot path
  + Use "{ }" for name buffer initialization
  + Make a copy of the ctl_table and only modify the copy
  + Rename max_action_to_log sysctl to log_max_action
  + Document the log_max_action sysctl
- Patch 3
  + Put some space between RET_LOG and RET_ALLOW for future actions
  + Separate the RET_ALLOW and RET_LOG cases in __seccomp_filter()
- Patch 4
  + Adjust the selftests for the updated RET_LOG value

Tyler


Tyler Hicks (4):
  seccomp: Add sysctl to display available actions
  seccomp: Add sysctl to configure actions that should be logged
  seccomp: Create an action to log before allowing
  seccomp: Add tests for SECCOMP_RET_LOG

 Documentation/prctl/seccomp_filter.txt        |  43 ++++++
 Documentation/sysctl/kernel.txt               |   1 +
 include/linux/audit.h                         |   6 +-
 include/uapi/linux/seccomp.h                  |   1 +
 kernel/seccomp.c                              | 185 +++++++++++++++++++++++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c |  94 +++++++++++++
 6 files changed, 322 insertions(+), 8 deletions(-)

-- 
2.7.4
