From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 0/7] Rework random blocking
Date: Fri, 20 Sep 2019 07:36:22 -0700
Message-ID: <cover.1568990048.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

This makes two major semantic changes to Linux's random APIs:

It adds getentropy(..., GRND_INSECURE).  This causes getentropy to
always return *something*.  There is no guarantee whatsoever that
the result will be cryptographically random or even unique, but the
kernel will give the best quality random output it can.  The name is
a big hint: the resulting output is INSECURE.

The purpose of this is to allow programs that genuinely want
best-effort entropy to get it without resorting to /dev/urandom.
Plenty of programs do this because they need to do *something*
during boot and they can't afford to wait.  Calling it "INSECURE" is
probably the best we can do to discourage using this API for things
that need security.

This series also removes the blocking pool and makes /dev/random
work just like getentropy(..., 0) and makes GRND_RANDOM a no-op.  I
believe that Linux's blocking pool has outlived its usefulness.
Linux's CRNG generates output that is good enough to use even for
key generation.  The blocking pool is not stronger in any material
way, and keeping it around requires a lot of infrastructure of
dubious value.

This series should not break any existing programs.  /dev/urandom is
unchanged.  /dev/random will still block just after booting, but it
will block less than it used to.  getentropy() with existing flags
will return output that is, for practical purposes, just as strong
as before.

Changes from v1:
 - Rebased to v5.3.  No other changes.

Andy Lutomirski (7):
  random: Don't wake crng_init_wait when crng_init == 1
  random: Add GRND_INSECURE to return best-effort non-cryptographic
    bytes
  random: Ignore GRND_RANDOM in getentropy(2)
  random: Make /dev/random be almost like /dev/urandom
  random: Remove the blocking pool
  random: Delete code to pull data into pools
  random: Remove kernel.random.read_wakeup_threshold

 drivers/char/random.c       | 234 ++++--------------------------------
 include/uapi/linux/random.h |   4 +-
 2 files changed, 27 insertions(+), 211 deletions(-)

-- 
2.21.0
