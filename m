From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 0/3] TPM 2.0 trusted key features for v4.5
Date: Sun, 13 Dec 2015 17:42:28 +0200
Message-ID: <1450021353-8775-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "open list:KEYS-ENCRYPTED" <keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CRYPTO API" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:KEYS-ENCRYPTED" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-api@vger.kernel.org

These are the remaining features to enable trusted keys for TPM 2.0 that were
not finished by the v4.4 merge window. These patches enable authorization
policy based sealing (like using PCRs together with a password for example or
something more complicated) with a user selected hash algorithm.

Jarkko Sakkinen (3):
  keys, trusted: fix: *do not* allow duplicate key options
  keys, trusted: select hash algorithm for TPM2 chips
  keys, trusted: seal with a TPM2 authorization policy

 Documentation/security/keys-trusted-encrypted.txt | 31 +++++++-----
 crypto/hash_info.c                                |  2 +
 drivers/char/tpm/tpm.h                            | 10 ++--
 drivers/char/tpm/tpm2-cmd.c                       | 60 ++++++++++++++++++++---
 include/crypto/hash_info.h                        |  3 ++
 include/keys/trusted-type.h                       |  5 ++
 include/uapi/linux/hash_info.h                    |  1 +
 security/keys/Kconfig                             |  1 +
 security/keys/trusted.c                           | 56 ++++++++++++++++++++-
 9 files changed, 147 insertions(+), 22 deletions(-)

-- 
2.5.0
