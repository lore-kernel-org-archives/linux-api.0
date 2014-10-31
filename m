From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [RFC PATCH 0/5] kdbus: add support for lsm
Date: Fri, 31 Oct 2014 17:36:32 +0100
Message-ID: <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
References: <54539AF3.6060302@samsung.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-reply-to: <54539AF3.6060302@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: pmoore@redhat.com, jkosina@suse.cz, linux-api@vger.kernel.org, inux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk, daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com, marcel@holtmann.org, tixxdz@opendz.org, javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk, linux-security-module@vger.kernel.org, lmctlx@gmail.com, r.krypa@samsung.com, Karol Lewandowski <k.lewandowsk@samsung.com>
List-Id: linux-api@vger.kernel.org

This is set of EXPERIMENTAL patches adding lsm support to kdbus.
(Rebased on top of v3.17.)

>From least to most invasive:

 - (1) kdbus: extend structures with security pointer for lsm

   Trivial.  Applicable as-is.

 - (2) security: export security_file_receive for modules
   (3) kdbus: check if lsm permits installing received fds

   fd_install doesn't seem to consult LSM, these patches
   ensure that receiving process has the right to sent fds. 

   Compile-tested only.

 - (4) security: introduce lsm hooks for kdbus
   (5) kdbus: make use of new lsm hooks

   Set of proof-of-concept hooks discussed previously with Paul Moore.

   kdbus integration patch (5) for review, but unlikely for integration
   at this stage.

   Likewise, compile-tested only.


Karol Lewandowski (5):
  kdbus: extend structures with security pointer for lsm
  security: export security_file_receive for modules
  kdbus: check if lsm permits installing received fds
  security: introduce lsm hooks for kdbus
  kdbus: make use of new lsm hooks

 drivers/misc/kdbus/bus.c        |  10 +++-
 drivers/misc/kdbus/bus.h        |   2 +
 drivers/misc/kdbus/connection.c |  34 +++++++++++-
 drivers/misc/kdbus/connection.h |   2 +
 drivers/misc/kdbus/domain.c     |   7 +++
 drivers/misc/kdbus/domain.h     |   2 +
 drivers/misc/kdbus/endpoint.c   |  11 ++++
 drivers/misc/kdbus/names.c      |   9 ++++
 drivers/misc/kdbus/queue.c      |  13 +++++
 include/linux/security.h        | 114 ++++++++++++++++++++++++++++++++++++++++
 security/capability.c           |  84 +++++++++++++++++++++++++++++
 security/security.c             |  85 ++++++++++++++++++++++++++++++
 12 files changed, 371 insertions(+), 2 deletions(-)

-- 
2.1.1

