From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v3 0/8] Rework random blocking
Date: Mon, 23 Dec 2019 00:20:43 -0800
Message-ID: <cover.1577088521.git.luto@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Stephan Mueller <smueller@chronox.de>, Andy Lutomirski <luto@kernel.org>
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

There are some open questions and future work here:

Should the kernel provide an interface to get software-generated
"true random" numbers?  I can think of only one legitimate reason to
use such an interface: compliance with government standards.  If the
kernel provides such an interface going forward, I think it should
be a brand new character device, and it should have a default mode
0440 or similar.  Software-generated "true random numbers" are a
very limited resource, and resource exhaustion is a big deal.  Ask
anyone who has twiddled their thumbs while waiting for gnupg to
generate a key.  If we think the kernel might do such a thing, then
patches 5-8 could be tabled for now.

Alternatively, perhaps the kernel should instead provide a
privileged interface to read out raw samples from the various
entropy sources, and users who care could have a user daemon that
does something intelligent with them.  This would push the mess of
trying to comply with whatever standards are involved to userspace.
Userspace could then export "true randomness" via CUSE if it is so
inclined, or could have a socket with a well-known name, or whatever
else seems appropriate.

I think that each available hwrng device should have its own
character device, which will make it much easier to use sensibly
from user mode.  But I don't think this series needs to block on
this.

Changes from v2:
 - Fix some bugs in the conditions that cause warnings.  Patch 2 is new.
 - Rebase to Linus' tree today.  This didn't change anything.

Changes from v1:
 - Rebased to v5.3.  No other changes.

Andy Lutomirski (8):
  random: Don't wake crng_init_wait when crng_init == 1
  random: Add a urandom_read_nowait() for random APIs that don't warn
  random: Add GRND_INSECURE to return best-effort non-cryptographic
    bytes
  random: Ignore GRND_RANDOM in getentropy(2)
  random: Make /dev/random be almost like /dev/urandom
  random: Remove the blocking pool
  random: Delete code to pull data into pools
  random: Remove kernel.random.read_wakeup_threshold

 drivers/char/random.c       | 245 +++++-------------------------------
 include/uapi/linux/random.h |   4 +-
 2 files changed, 37 insertions(+), 212 deletions(-)

-- 
2.23.0
