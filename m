From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v6 0/6] crypto: algif - add akcipher
Date: Sat, 14 May 2016 21:16:45 -0700
Message-ID: <20160515041645.15888.94903.stgit@tstruk-mobl1>
References: <5123.1462976721@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5123.1462976721-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

First four patches are a resend of the v3 algif_akcipher from
Stephan Mueller, with minor changes after rebase on top of 4.6-rc1.

The next three patches add support for keys stored in system
keyring subsystem.

First patch adds algif_akcipher nokey hadlers.

Second patch adds generic sign, verify, encrypt, decrypt accessors
functions to the asymmetric key type. These will be defined by
asymmetric subtypes, similarly to how public_key currently defines
the verify_signature function.

Third patch adds support for ALG_SET_KEY_ID and ALG_SET_PUBKEY_ID
commands to AF_ALG and setkeyid operation to the af_alg_type struct.
If the keyid is used then the afalg layer acquires the key for the
keyring subsystem and uses the new asymmetric accessor functions
instead of akcipher api. The asymmetric subtypes can use akcipher
api internally.

This is the same v5 version as before rebased on top of
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl

v6 changes:
- update to reflect changes in kernel_pkey_params struct

v5 changes:
- drop public key changes and use new version provided by David

v4 changes:
- don't use internal public_key struct in af_alg.
- add generic accessor functions to asymmetric key type, which take
  the generic struct key type and resolve the specific subtype internally

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

Stephan Mueller (4):
      crypto: AF_ALG -- add sign/verify API
      crypto: AF_ALG -- add setpubkey setsockopt call
      crypto: AF_ALG -- add asymmetric cipher interface
      crypto: algif_akcipher - enable compilation

Tadeusz Struk (2):
      crypto: algif_akcipher - add ops_nokey
      crypto: AF_ALG - add support for key_id

 crypto/Kconfig              |    9 
 crypto/Makefile             |    1 
 crypto/af_alg.c             |   28 +
 crypto/algif_akcipher.c     |  884 +++++++++++++++++++++++++++++++++++++++++++
 include/crypto/if_alg.h     |    2 
 include/uapi/linux/if_alg.h |    5 
 6 files changed, 924 insertions(+), 5 deletions(-)
 create mode 100644 crypto/algif_akcipher.c

--
TS
