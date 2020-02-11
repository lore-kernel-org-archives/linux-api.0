From: Daniel Colascione <dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/6] Harden userfaultfd
Date: Tue, 11 Feb 2020 14:55:41 -0800
Message-ID: <20200211225547.235083-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nosh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, nnk-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lokeshgidra-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Userfaultfd in unprivileged contexts could be potentially very
useful. We'd like to harden userfaultfd to make such unprivileged use
less risky. This patch series allows SELinux to manage userfaultfd
file descriptors and allows administrators to limit userfaultfd to
servicing user-mode faults, increasing the difficulty of using
userfaultfd in exploit chains invoking delaying kernel faults.

A new anon_inodes interface allows callers to opt into SELinux
management of anonymous file objects. In this mode, anon_inodes
creates new ephemeral inodes for anonymous file objects instead of
reusing a singleton dummy inode. A new LSM hook gives security modules
an opportunity to configure and veto these ephemeral inodes.

Existing anon_inodes users must opt into the new functionality.

Daniel Colascione (6):
  Add a new flags-accepting interface for anonymous inodes
  Add a concept of a "secure" anonymous file
  Teach SELinux about a new userfaultfd class
  Wire UFFD up to SELinux
  Let userfaultfd opt out of handling kernel-mode faults
  Add a new sysctl for limiting userfaultfd to user mode faults

 Documentation/admin-guide/sysctl/vm.rst | 13 ++++
 fs/anon_inodes.c                        | 89 +++++++++++++++++--------
 fs/userfaultfd.c                        | 29 ++++++--
 include/linux/anon_inodes.h             | 27 ++++++--
 include/linux/lsm_hooks.h               |  8 +++
 include/linux/security.h                |  2 +
 include/linux/userfaultfd_k.h           |  3 +
 include/uapi/linux/userfaultfd.h        |  9 +++
 kernel/sysctl.c                         |  9 +++
 security/security.c                     |  8 +++
 security/selinux/hooks.c                | 68 +++++++++++++++++++
 security/selinux/include/classmap.h     |  2 +
 12 files changed, 229 insertions(+), 38 deletions(-)

-- 
2.25.0.225.g125e21ebc7-goog
