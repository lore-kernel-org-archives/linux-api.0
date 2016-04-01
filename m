From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v4 0/7] crypto: algif - add akcipher
Date: Thu, 31 Mar 2016 18:37:45 -0700
Message-ID: <20160401013745.16799.91093.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
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

Patches generated on top of 4.6-rc1

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

Tadeusz Struk (3):
      crypto: algif_akcipher - add ops_nokey
      crypto: KEYS - add generic handlers to symmetric key type
      crypto: AF_ALG - add support for key_id

 crypto/Kconfig                           |    9 
 crypto/Makefile                          |    1 
 crypto/af_alg.c                          |   28 +
 crypto/algif_akcipher.c                  |  821 ++++++++++++++++++++++++++++++
 crypto/asymmetric_keys/asymmetric_type.c |   88 +++
 include/crypto/if_alg.h                  |    2 
 include/keys/asymmetric-subtype.h        |   10 
 include/keys/asymmetric-type.h           |   15 -
 include/uapi/linux/if_alg.h              |    5 
 9 files changed, 971 insertions(+), 8 deletions(-)
 create mode 100644 crypto/algif_akcipher.c
--
