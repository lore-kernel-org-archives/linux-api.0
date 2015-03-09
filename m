From: David Drysdale <drysdale@google.com>
Subject: [PATCHv3 0/3] fs: add O_BENEATH flag to openat(2)
Date: Mon,  9 Mar 2015 14:00:09 +0000
Message-ID: <1425909612-28034-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, fstests@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

This change adds a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EPERM) paths that are not beneath
the provided dfd.

This change was originally included as part of a larger patchset
(https://lkml.org/lkml/2014/7/25/426) for Capsicum support; however, it
is potentially useful as an independent change so I've pulled it out
separately here.

In particular, various folks from Chrome[OS] have indicated an interest
in having this functionality -- when combined with a seccomp filter it
allows a directory to be accessed by a sandboxed process.


Changes since v2:
 - Move tests into xfstests [Dave Chinner, with thanks for feedback
   on initial version]
 - Merge up to v4.0-rc3 & latest man-pages

Changes since v1:
 - Don't needlessly duplicate flags [Al Viro]
 - Use EPERM rather than EACCES as error code [Paolo Bonzini]
 - Disallow nd_jump_link for O_BENEATH [Al Viro/Andy Lutomirski]
 - Add test of a jumped symlink (/proc/self/root)

Changes since the version included in the Capsicum v2 patchset:
 - Add tests of normal symlinks
 - Fix man-page typo
 - Update patch to 3.17

Changes from v1 to v2 of Capsicum patchset:
 - renamed O_BENEATH_ONLY to O_BENEATH [Christoph Hellwig]


David Drysdale (1):
  fs: add O_BENEATH flag to openat(2)

 arch/alpha/include/uapi/asm/fcntl.h  |  1 +
 arch/parisc/include/uapi/asm/fcntl.h |  1 +
 arch/sparc/include/uapi/asm/fcntl.h  |  1 +
 fs/fcntl.c                           |  4 ++--
 fs/namei.c                           | 21 ++++++++++++++++++---
 fs/open.c                            |  4 +++-
 fs/proc/base.c                       |  4 +++-
 fs/proc/namespaces.c                 |  8 ++++++--
 include/linux/namei.h                |  3 ++-
 include/uapi/asm-generic/fcntl.h     |  4 ++++
 10 files changed, 41 insertions(+), 10 deletions(-)

--
2.2.0.rc0.207.ga3a616c
