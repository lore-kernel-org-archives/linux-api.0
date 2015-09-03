From: David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 0/3] Introduce inotify_update_watch(2)
Date: Thu,  3 Sep 2015 17:10:24 +0200
Message-ID: <1441293027-3363-1-git-send-email-dh.herrmann@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>, David Herrmann <dh.herrmann@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi

The current inotify API suffers from a nasty race-condition if you try to
update watch descriptors (where the update _changes_ flags, not only adds new
flags). The problem is, that an explicit update of a watch-descriptor might
result in updating an unrelated, existing watch descriptor that just happens to
be moved at the file-system path we do the inotify update on. inotify lacks a
way to operate on explicit watch-descriptors, but always required the caller to
provide a file-system path. This is inherently racy, as the real objects that
are modified are tied to *inodes*, not paths.

Imagine the case where an application monitors two independent files A
and B with two independent watch descriptors. If you now want to *change*
the watch-mask of A, you have to use inotify_add_watch(fd, "A", new_mask).
However, this might race with a file-system operation that links B over A,
thus this call to inotify_add_watch() will affect the watch-descriptor of
B. However, this is usually not what the caller wants, as the watch-masks
of A and B can be disjoint, and as such an unwanted update of B might
cause event loss. Hence, a call like inotify_update_watch() is needed,
which explicitly takes the watch-descriptor to modify. In this case, it
would still only update the watch-descriptor of A, even though the path
to A changed.

The underlying issue here is the automatism of inotify_add_watch(), which
does not allow the caller to distinguish an update operation from an ADD
operation. This race could be solved with a simple IN_EXCL (or IN_CREATE)
flag, which would cause inotify_add_watch() to *never* update existing
watch-descriptors, but fail with EEXIST instead. However, this still
prevents the caller from *updating* the flags of an explicitly passed
watch-descriptor. Furthermore, the fact that inotify objects identify
*INODES*, but the API takes *PATHS* calls for races. Therefore, we really
need an explicit update operation to allow user-space to modify watch
descriptors without having to re-create them and thus invalidating their
cache.

This series implements inotify_update_watch() to extend the inotify API
with a way to explicity modify watch-descriptors, instead of going via
the file-system path-API of inotify_add_watch().

Thanks
David

David Herrmann (3):
  inotify: move wd lookup out of update_existing_watch()
  inotify: add inotify_update_watch() syscall
  kselftest/inotify: add inotify_update_watch(2) test-cases

 arch/x86/entry/syscalls/syscall_32.tbl         |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl         |   1 +
 fs/notify/inotify/inotify_user.c               |  69 +++++++++++-----
 include/linux/syscalls.h                       |   1 +
 kernel/sys_ni.c                                |   1 +
 tools/testing/selftests/Makefile               |   1 +
 tools/testing/selftests/inotify/.gitignore     |   2 +
 tools/testing/selftests/inotify/Makefile       |  14 ++++
 tools/testing/selftests/inotify/test_inotify.c | 105 +++++++++++++++++++++++++
 9 files changed, 175 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/inotify/.gitignore
 create mode 100644 tools/testing/selftests/inotify/Makefile
 create mode 100644 tools/testing/selftests/inotify/test_inotify.c

-- 
2.5.1
