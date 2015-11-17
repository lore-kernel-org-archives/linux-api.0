From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 0/2] TPM 2.0 trusted key features for v4.5
Date: Tue, 17 Nov 2015 18:27:20 +0200
Message-ID: <1447777643-10777-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, James Morris <james.l.morris@oracle.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "open list:KEYS-ENCRYPTED" <keyrings@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, "open list:CRYPTO API" <linux-crypto@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:KEYS-ENCRYPTED" <linux-security-module@vger.kernel.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>
List-Id: linux-api@vger.kernel.org

These are the remaining features to enable trusted keys for TPM 2.0 that very
not finished by the v4.4 merge window. These patches enable authorization
policy based sealing (like using PCRs together with a password for example or
something more complicated) with a user selected hash algorithm.

Jarkko Sakkinen (2):
  keys, trusted: select hash algorithm for TPM2 chips
  keys, trusted: seal with a policy

 Documentation/security/keys-trusted-encrypted.txt | 31 ++++++----
 crypto/hash_info.c                                |  2 +
 drivers/char/tpm/tpm.h                            | 10 +++-
 drivers/char/tpm/tpm2-cmd.c                       | 60 ++++++++++++++++---
 include/crypto/hash_info.h                        |  3 +
 include/keys/trusted-type.h                       |  4 ++
 include/uapi/linux/hash_info.h                    |  1 +
 security/keys/Kconfig                             |  1 +
 security/keys/trusted.c                           | 73 ++++++++++++++++++++++-
 9 files changed, 161 insertions(+), 24 deletions(-)

-- 
2.5.0
