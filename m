From: Daniel Colascione <dancol@google.com>
Subject: [PATCH 0/7] Harden userfaultfd
Date: Sat, 12 Oct 2019 12:15:55 -0700
Message-ID: <20191012191602.45649-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, lokeshgidra@google.com, dancol@google.com, nnk@google.com
Cc: nosh@google.com, timmurray@google.com
List-Id: linux-api@vger.kernel.org

Userfaultfd in unprivileged contexts could be potentially very
useful. We'd like to harden userfaultfd to make such unprivileged use
less risky. This patch series allows SELinux to manage userfaultfd
file descriptors (via a new flag, for compatibility with existing
code) and allows administrators to limit userfaultfd to servicing
user-mode faults, increasing the difficulty of using userfaultfd in
exploit chains invoking delaying kernel faults.

A new anon_inodes interface allows callers to opt into SELinux
management of anonymous file objects. In this mode, anon_inodes
creates new ephemeral inodes for anonymous file objects instead of
reusing a singleton dummy inode. A new LSM hook gives security modules
an opportunity to configure and veto these ephemeral inodes.

Existing anon_inodes users must opt into the new functionality.

Daniel Colascione (7):
  Add a new flags-accepting interface for anonymous inodes
  Add a concept of a "secure" anonymous file
  Add a UFFD_SECURE flag to the userfaultfd API.
  Teach SELinux about a new userfaultfd class
  Let userfaultfd opt out of handling kernel-mode faults
  Allow users to require UFFD_SECURE
  Add a new sysctl for limiting userfaultfd to user mode faults

 Documentation/admin-guide/sysctl/vm.rst | 19 +++++-
 fs/anon_inodes.c                        | 89 +++++++++++++++++--------
 fs/userfaultfd.c                        | 47 +++++++++++--
 include/linux/anon_inodes.h             | 27 ++++++--
 include/linux/lsm_hooks.h               |  8 +++
 include/linux/security.h                |  2 +
 include/linux/userfaultfd_k.h           |  3 +
 include/uapi/linux/userfaultfd.h        | 14 ++++
 kernel/sysctl.c                         |  9 +++
 security/security.c                     |  8 +++
 security/selinux/hooks.c                | 68 +++++++++++++++++++
 security/selinux/include/classmap.h     |  2 +
 12 files changed, 256 insertions(+), 40 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog
