From: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC 0/3] kdbus: extend selftests
Date: Thu, 24 Sep 2015 14:07:33 +0200
Message-ID: <1443096456-1527-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Paul Osmialowski <p.osmialowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This serie extends kdbus selftests with following new features:

- ability to specify TEST_CREATE_CONN without TEST_CREATE_BUS
- the 'test-send' test case (by Karol Lewandowski)
- ability to run kdbus test by executable binary name

Paul Osmialowski (3):
  kdbus: TEST_CREATE_CONN now does no depend on TEST_CREATE_BUS
  kdbus: selftests extended
  kdbus: Ability to run kdbus test by executable binary name

 tools/testing/selftests/kdbus/Makefile           |  1 +
 tools/testing/selftests/kdbus/kdbus-test.c       | 37 ++++++++++-
 tools/testing/selftests/kdbus/kdbus-test.h       |  1 +
 tools/testing/selftests/kdbus/kdbus-util.c       | 38 +++++++----
 tools/testing/selftests/kdbus/kdbus-util.h       |  2 +-
 tools/testing/selftests/kdbus/test-activator.c   | 20 +++---
 tools/testing/selftests/kdbus/test-chat.c        |  6 +-
 tools/testing/selftests/kdbus/test-connection.c  |  8 ++-
 tools/testing/selftests/kdbus/test-fd.c          |  2 +-
 tools/testing/selftests/kdbus/test-message.c     | 69 ++++++++++++--------
 tools/testing/selftests/kdbus/test-metadata-ns.c | 10 +--
 tools/testing/selftests/kdbus/test-monitor.c     |  9 +--
 tools/testing/selftests/kdbus/test-policy-ns.c   |  8 +--
 tools/testing/selftests/kdbus/test-policy-priv.c | 48 ++++++++------
 tools/testing/selftests/kdbus/test-send.c        | 82 ++++++++++++++++++++++++
 tools/testing/selftests/kdbus/test-sync.c        |  2 +-
 tools/testing/selftests/kdbus/test-timeout.c     |  2 +-
 17 files changed, 253 insertions(+), 92 deletions(-)
 create mode 100644 tools/testing/selftests/kdbus/test-send.c

-- 
1.9.1
