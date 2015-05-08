From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [GIT PULL v2] selftest: Add futex functional tests
Date: Fri,  8 May 2015 15:09:38 -0700
Message-ID: <cover.1431121818.git.dvhart@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Shuah,

This series begins the process of migrating my futextest tests into kselftest.
I've started with only the functional tests, as the performance and stress may
not be appropriate for kselftest as they stand.

I cleaned up various complaints from checkpatch, but I ignored others that would
require significant rework of the testcases, such as not using volatile and not
creating new typedefs.

Since v1:
Avoid checkpatch errors on 1/5 by:
 - combining a later patch which did substantial cleanup.
 - removing file-local typedefs and replacing with structs
 - correcting all >80 char lines, except for quoted strings and header boiler
   plate due to long email addresses

I did *not* make changes for the following:
 - Use of new typdefs for types futex_t and atomic_t as they are used throughout
   the test suite and I consider them to be worth while.
 - Use of volatile as the warning is about use of volatile in kernel code. The
   usage in futextest is correct, as an indicator that other threads may modify
   the value.
 - Adding parentheses around complex defines as it would break one use case and
   change the behavior of another.

The patches will follow, but I'm providing a pull request for your convenience
as well.

The following changes since commit b787f68c36d49bb1d9236f403813641efa74a031:

  Linux 4.1-rc1 (2015-04-26 17:59:10 -0700)

are available in the git repository at:

  git://git.infradead.org/users/dvhart/linux.git futextest-v2

Darren Hart (5):
  selftests: Add futex functional tests
  selftest/futex: Update Makefile to use lib.mk
  selftest/futex: Increment ksft pass and fail counters
  selftest: Add futex tests to the top-level Makefile
  kselftest: Add exit code defines

 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/futex/Makefile             |  29 ++
 tools/testing/selftests/futex/README               |  62 ++++
 tools/testing/selftests/futex/functional/Makefile  |  25 ++
 .../selftests/futex/functional/futex_requeue_pi.c  | 409 +++++++++++++++++++++
 .../functional/futex_requeue_pi_mismatched_ops.c   | 135 +++++++
 .../functional/futex_requeue_pi_signal_restart.c   | 223 +++++++++++
 .../functional/futex_wait_private_mapped_file.c    | 125 +++++++
 .../futex/functional/futex_wait_timeout.c          |  86 +++++
 .../functional/futex_wait_uninitialized_heap.c     | 124 +++++++
 .../futex/functional/futex_wait_wouldblock.c       |  79 ++++
 tools/testing/selftests/futex/functional/run.sh    |  80 ++++
 tools/testing/selftests/futex/include/atomic.h     |  83 +++++
 tools/testing/selftests/futex/include/futextest.h  | 266 ++++++++++++++
 tools/testing/selftests/futex/include/logging.h    | 153 ++++++++
 tools/testing/selftests/futex/run.sh               |  33 ++
 tools/testing/selftests/kselftest.h                |  17 +-
 17 files changed, 1925 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/futex/Makefile
 create mode 100644 tools/testing/selftests/futex/README
 create mode 100644 tools/testing/selftests/futex/functional/Makefile
 create mode 100644 tools/testing/selftests/futex/functional/futex_requeue_pi.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_requeue_pi_mismatched_ops.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait_private_mapped_file.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait_timeout.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait_uninitialized_heap.c
 create mode 100644 tools/testing/selftests/futex/functional/futex_wait_wouldblock.c
 create mode 100755 tools/testing/selftests/futex/functional/run.sh
 create mode 100644 tools/testing/selftests/futex/include/atomic.h
 create mode 100644 tools/testing/selftests/futex/include/futextest.h
 create mode 100644 tools/testing/selftests/futex/include/logging.h
 create mode 100755 tools/testing/selftests/futex/run.sh

-- 
2.1.4
