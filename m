From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/7] crypto: algif - add akcipher
Date: Tue, 29 Mar 2016 17:56:49 -0700
Message-ID: <20160330005649.25410.70508.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Cc: tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

First four patches are a resend of the v3 algif_akcipher from
Stephan Mueller, with minor changes after rebase on top of 4.6-rc1.

The next three patches add support for keys stored in system
keyring subsystem.

First patch adds a public_key info struct that is used to query
information about the public key.
For now it only contains information about where the key is stored.
This is to prevent other modules, like AF_ALG using a key that
can not be directly accessed by software. Later, when keyctl
will allow to reference hardware based public keys this can be
extended to describe other characteristic of the key, like
information on what operations a public key supports, size of data
is supported, whether a password is required to unlock it, etc.

Second patch adds support for ALG_SET_KEY_ID and ALG_SET_PUBKEY_ID
commands to AF_ALG, which can be used to reference sw key stored
in the system keyrings.

Third patch adds algif_akcipher nokey hadlers.

Patches generated on top of 4.6-rc1

v3 changes:
- include Stephan's patches (rebased on 4.6-rc1)
- add algif_akcipher nokey hadlers
- add public_key info struct to public_key and helper query functions
- add a check if a key is a software accessible key on af_alg, and
  return -ENOKEY if it isn't

v2 changes:
- pass the original skcipher request in ablkcipher.base.data instead of
  casting it back from the ablkcipher request.
- rename _req to base_req
- dropped 3/3

---
Stephan Mueller (4)
      crypto: AF_ALG -- add sign/verify API
      crypto: AF_ALG -- add setpubkey setsockopt call
      crypto: AF_ALG -- add asymmetric cipher interface
      crypto: algif_akcipher - enable compilation

Tadeusz Struk (3):
      crypto: algif_akcipher - add ops_nokey
      crypto: KEYS - add public_key info query
      crypto: AF_ALG - add support for key_id

 crypto/Kconfig                            |    9 
 crypto/Makefile                           |    1 
 crypto/af_alg.c                           |   60 ++-
 crypto/algif_akcipher.c                   |  685 +++++++++++++++++++++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c |    1 
 include/crypto/if_alg.h                   |    1 
 include/crypto/public_key.h               |   31 +
 include/uapi/linux/if_alg.h               |    5 
 8 files changed, 788 insertions(+), 5 deletions(-)
 create mode 100644 crypto/algif_akcipher.c
--
