From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v3 0/2] capabilities: Ambient capability patchset
Date: Wed, 27 May 2015 16:47:57 -0700
Message-ID: <cover.1432770087.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Andrew Lutomirski <luto@kernel.org>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

This adds ambient capabilities.  See the individual patch changelogs
for details.

Preliminary userspace code is here:

https://git.kernel.org/cgit/linux/kernel/git/luto/util-linux-playground.git/commit/?h=cap_ambient&id=7f5afbd175d2

James or akpm, I think this is ready for 4.2.  Can one of you queue it up?

Thanks,
Andy

Changes from v2:
 - Improve the patch 1 changelog a bit.
 - Add acks.
 - Add comment clarifying the pE' rule.
 - s/except/expect

Changes from v1:
 - Lots of cleanups to the ambient cap code.
 - The securebit is new.

Andy Lutomirski (2):
  capabilities: Ambient capabilities
  capabilities: Add a securebit to disable PR_CAP_AMBIENT_RAISE

 fs/proc/array.c                 |  5 ++-
 include/linux/cred.h            |  8 ++++
 include/uapi/linux/prctl.h      |  6 +++
 include/uapi/linux/securebits.h | 11 ++++-
 kernel/user_namespace.c         |  1 +
 security/commoncap.c            | 92 ++++++++++++++++++++++++++++++++++++-----
 security/keys/process_keys.c    |  1 +
 7 files changed, 112 insertions(+), 12 deletions(-)

-- 
2.1.0
