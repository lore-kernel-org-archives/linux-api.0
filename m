From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: [PATCH 0/2] Changes to timers Maefile to use shared logic for run_tests and install
Date: Fri, 13 Mar 2015 16:57:49 -0600
Message-ID: <cover.1426286799.git.shuahkh@osg.samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch set:

adds ability to run and emit script for tests args to lib.mk.
lib.mk provides a way to override the default RUN_TESTS and
EMIT_TESTS, however in the cases where a test has several
executables that don't require any special args and/or handling
and some that do, overrding will be cumbersome. Add variables
RUN_TESTS_WITH_ARGS, and EMIT_TESTS_WITH_ARGS to enable a test to
run and exmit script for such special executables.

Timers test Makefile is changed to use the shared logic for running
and installing tests.

Shuah Khan (2):
  selftests: add ability to run and emit script for tests args to lib.mk
  selftests/timers: change to use shared logic to run and install tests

 tools/testing/selftests/lib.mk          |  6 ++++++
 tools/testing/selftests/timers/Makefile | 20 +++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.1.0
