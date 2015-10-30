From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 0/3] TPM2: select hash algorithm for a trusted key
Date: Fri, 30 Oct 2015 13:35:06 +0200
Message-ID: <1446204910-29948-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, chris.j.arges@canonical.com, seth.forshee@canonical.com, colin.king@canonical.com, josh@joshtriplett.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, "open list:CRYPTO API" <linux-crypto@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Jarkko Sakkinen (3):
  keys, trusted: select the hash algorithm
  crypto: add entry for sm3-256
  tpm: choose hash algorithm for sealing when using TPM 2.0

 Documentation/security/keys-trusted-encrypted.txt |  3 ++
 crypto/hash_info.c                                |  2 ++
 drivers/char/tpm/tpm.h                            | 10 ++++--
 drivers/char/tpm/tpm2-cmd.c                       | 42 +++++++++++++++++++++--
 include/crypto/hash_info.h                        |  3 ++
 include/keys/trusted-type.h                       |  1 +
 include/uapi/linux/hash_info.h                    |  1 +
 security/keys/Kconfig                             |  1 +
 security/keys/trusted.c                           | 20 ++++++++++-
 9 files changed, 76 insertions(+), 7 deletions(-)

-- 
2.5.0
