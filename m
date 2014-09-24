From: Peter Feiner <pfeiner@google.com>
Subject: [PATCH v2 0/3] tools: selftests cleanup
Date: Wed, 24 Sep 2014 12:42:08 -0700
Message-ID: <1411587731-25088-1-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411499027-17801-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>, Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Feiner <pfeiner@google.com>
List-Id: linux-api@vger.kernel.org

A couple of small patches to make working with selftests easier.

v1 -> v2:
	Addressed Shuah's comments. 
v2 -> v3:
	Forgot Signed-off-by footer.

*** BLURB HERE ***

Peter Feiner (3):
  tools: add .gitignore entries for selftests
  tools: adding clean target to user selftest
  tools: parallel selftests building & running

 tools/testing/selftests/Makefile               | 49 +++++++++++---------------
 tools/testing/selftests/breakpoints/.gitignore |  1 +
 tools/testing/selftests/efivarfs/.gitignore    |  2 ++
 tools/testing/selftests/mount/.gitignore       |  1 +
 tools/testing/selftests/ptrace/.gitignore      |  1 +
 tools/testing/selftests/timers/.gitignore      |  1 +
 tools/testing/selftests/user/Makefile          |  2 ++
 tools/testing/selftests/vm/.gitignore          |  9 ++---
 8 files changed, 33 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/efivarfs/.gitignore
 create mode 100644 tools/testing/selftests/mount/.gitignore
 create mode 100644 tools/testing/selftests/ptrace/.gitignore
 create mode 100644 tools/testing/selftests/timers/.gitignore

-- 
2.1.0.rc2.206.gedb03e5
