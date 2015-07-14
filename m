From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v4 0/2] capabilities: Ambient capability patchset
Date: Tue, 14 Jul 2015 12:46:14 -0700
Message-ID: <cover.1436903028.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linuxfoundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, James Morris <james.l.morris@oracle.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Christoph Lameter <cl@linux.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

This adds ambient capabilities.  See the individual patch changelogs
for details.

Preliminary userspace code is here, but it needs updating:

https://git.kernel.org/cgit/linux/kernel/git/luto/util-linux-playground.git/commit/?h=cap_ambient&id=7f5afbd175d2

Changes from v3:
 - Rename PR_CAP_AMBIENT_READ to PR_CAP_AMBIENT_IS_SET (Michael Kerrisk)
 - Add PR_CAP_AMBIENT_CLEAR_ALL (Michael Kerrisk)
 - Add acks from v2

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

 fs/proc/array.c                 |   5 +-
 include/linux/cred.h            |   8 ++++
 include/uapi/linux/prctl.h      |   7 +++
 include/uapi/linux/securebits.h |  11 ++++-
 kernel/user_namespace.c         |   1 +
 security/commoncap.c            | 103 ++++++++++++++++++++++++++++++++++++----
 security/keys/process_keys.c    |   1 +
 7 files changed, 124 insertions(+), 12 deletions(-)

-- 
2.4.3
