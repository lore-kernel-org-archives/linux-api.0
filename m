From: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 0/8] Introduce LSM to KDBUS
Date: Wed, 08 Jul 2015 12:25:02 +0200
Message-ID: <1436351110-5902-1-git-send-email-p.osmialowsk@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <pmoore@redhat.com>, James Morris <james.l.morris@oracle.com>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Stephen Smalley <sds@tycho.nsa.gov>, Neil Brown <neilb@suse.de>, Mark Rustad <mark.d.rustad@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@googlemail.com>, Djalal Harouni <tixxdz@opendz.org>, Shuah Khan <shuahkh@osg.samsung.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, Paul Osmialowski <p.osmialowsk@samsung.com>, Lukasz Skalski <l.skalski@samsung.com>
List-Id: linux-api@vger.kernel.org

This patchset partially summarizes effects of collective work by
Karol Lewandowski and Paul Moore towards introduction of LSM into KDBUS.

These patches originate from following git repositories:

git://git.infradead.org/users/pcmoore/selinux (branch: working-kdbus)

https://github.com/lmctl/linux.git (branch: kdbus-lsm-v4.for-systemd-v212)

https://github.com/lmctl/kdbus.git (branch: kdbus-lsm-v4.for-systemd-v212)

Since kdbus made its way to linux-next tree, I was kindly asked by
Karol Lewandowski to fit his work into the current kdbus code existing
there.

As both kdbus and security related code changed a bit, so are my changes
quite substantial in places.

Note that SELinux kdbus access control patches are absent - only SMACK part
of original work is included.

I've also made some changes to kdbus test suite. In order to see LSM hooks
in action we need to be able to run tests from different executable
binaries holding different security labels.

Therefore I added ability to select execution of particular test by
executed binary name. This is essential for running newly added 'send' test
which should communicate with 'daemon' test running in another process.

Karol Lewandowski (1):
  lsm: make security_file_receive available for external modules

Paul Osmialowski (7):
  lsm: smack: Make ipc/kdbus includes visible so smack callbacks could
    see them
  lsm: kdbus security hooks
  lsm: smack: smack callbacks for kdbus security hooks
  kdbus: use LSM hooks in kdbus code
  kdbus: TEST_CREATE_CONN now does no depend on TEST_CREATE_BUS
  kdbus: selftests extended
  kdbus: Ability to run kdbus test by executable binary name

 include/linux/lsm_hooks.h                        |  67 +++++++++++++
 include/linux/security.h                         |  99 +++++++++++++++++++
 ipc/kdbus/bus.c                                  |  12 ++-
 ipc/kdbus/bus.h                                  |   3 +
 ipc/kdbus/connection.c                           |  54 +++++++++++
 ipc/kdbus/connection.h                           |   4 +
 ipc/kdbus/domain.c                               |   9 +-
 ipc/kdbus/domain.h                               |   2 +
 ipc/kdbus/endpoint.c                             |  11 +++
 ipc/kdbus/names.c                                |  11 +++
 ipc/kdbus/queue.c                                |  30 ++++--
 security/security.c                              | 118 +++++++++++++++++++++++
 security/smack/Makefile                          |   2 +
 security/smack/smack_lsm.c                       |  68 +++++++++++++
 tools/testing/selftests/kdbus/Makefile           |   1 +
 tools/testing/selftests/kdbus/kdbus-test.c       |  37 ++++++-
 tools/testing/selftests/kdbus/kdbus-test.h       |   1 +
 tools/testing/selftests/kdbus/kdbus-util.c       |  37 ++++---
 tools/testing/selftests/kdbus/kdbus-util.h       |   2 +-
 tools/testing/selftests/kdbus/test-activator.c   |  20 ++--
 tools/testing/selftests/kdbus/test-chat.c        |   6 +-
 tools/testing/selftests/kdbus/test-connection.c  |   8 +-
 tools/testing/selftests/kdbus/test-fd.c          |   2 +-
 tools/testing/selftests/kdbus/test-message.c     |  69 ++++++++-----
 tools/testing/selftests/kdbus/test-metadata-ns.c |  10 +-
 tools/testing/selftests/kdbus/test-monitor.c     |   9 +-
 tools/testing/selftests/kdbus/test-policy-ns.c   |   8 +-
 tools/testing/selftests/kdbus/test-policy-priv.c |  48 +++++----
 tools/testing/selftests/kdbus/test-send.c        |  84 ++++++++++++++++
 tools/testing/selftests/kdbus/test-sync.c        |   2 +-
 tools/testing/selftests/kdbus/test-timeout.c     |   2 +-
 31 files changed, 732 insertions(+), 104 deletions(-)
 create mode 100644 tools/testing/selftests/kdbus/test-send.c

-- 
1.9.1
