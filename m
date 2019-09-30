From: Aleksa Sarai <asarai@suse.de>
Subject: [PATCH RESEND v3 0/4] lib: introduce copy_struct_from_user() helper
Date: Tue,  1 Oct 2019 05:15:22 +1000
Message-ID: <20190930191526.19544-1-asarai@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-105507-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Aleksa Sarai <cyphar@cyphar.com>

Patch changelog:
 v3: [<https://lore.kernel.org/lkml/20190930182810.6090-1-cyphar@cyphar.com/>]
  * Rename is_zeroed_user() to check_zeroed_user(). [Christian Brauner]
  * Various minor cleanups. [Christian Brauner]
  * Add copy_struct_from_user() tests.
 v2: <https://lore.kernel.org/lkml/20190925230332.18690-1-cyphar@cyphar.com/>
 v1: <https://lore.kernel.org/lkml/20190925165915.8135-1-cyphar@cyphar.com/>

This series was split off from the openat2(2) syscall discussion[1].
However, the copy_struct_to_user() helper has been dropped, because
after some discussion it appears that there is no really obvious
semantics for how copy_struct_to_user() should work on mixed-vintages
(for instance, whether [2] is the correct semantics for all syscalls).

A common pattern for syscall extensions is increasing the size of a
struct passed from userspace, such that the zero-value of the new fields
result in the old kernel behaviour (allowing for a mix of userspace and
kernel vintages to operate on one another in most cases).

Previously there was no common lib/ function that implemented
the necessary extension-checking semantics (and different syscalls
implemented them slightly differently or incompletely[3]). This series
implements the helper and ports several syscalls to use it.

Some in-kernel selftests are included in this patch. More complete
self-tests for copy_struct_from_user() are included in the openat2()
patchset.

[1]: https://lore.kernel.org/lkml/20190904201933.10736-1-cyphar@cyphar.com/

[2]: commit 1251201c0d34 ("sched/core: Fix uclamp ABI bug, clean up and
     robustify sched_read_attr() ABI logic and code")

[3]: For instance {sched_setattr,perf_event_open,clone3}(2) all do do
     similar checks to copy_struct_from_user() while rt_sigprocmask(2)
     always rejects differently-sized struct arguments.

Aleksa Sarai (4):
  lib: introduce copy_struct_from_user() helper
  clone3: switch to copy_struct_from_user()
  sched_setattr: switch to copy_struct_from_user()
  perf_event_open: switch to copy_struct_from_user()

 include/linux/bitops.h     |   7 ++
 include/linux/uaccess.h    |   4 ++
 include/uapi/linux/sched.h |   2 +
 kernel/events/core.c       |  47 +++----------
 kernel/fork.c              |  34 ++--------
 kernel/sched/core.c        |  43 ++----------
 lib/strnlen_user.c         |   8 +--
 lib/test_user_copy.c       | 133 +++++++++++++++++++++++++++++++++++--
 lib/usercopy.c             | 123 ++++++++++++++++++++++++++++++++++
 9 files changed, 287 insertions(+), 114 deletions(-)

-- 
2.23.0
