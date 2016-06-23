From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v8 0/6] crypto: algif - add akcipher
Date: Thu, 23 Jun 2016 15:55:26 -0700
Message-ID: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, mathew.j.martineau@linux.intel.com, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

First four patches are a resend algif_akcipher from
Stephan Mueller, with minor changes after rebase on top of 4.7-rc1.

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

Patches are generate against:
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next

v8 hanges:
- copy the result to user for verify after the signature_verify
  operation. Before only the return code was checked, but not the
  actual data. Reported by Mat Martineau
- remove the constrain on the output buffer size as requested by
  Mat Martineau
- ifx uninitialize variable issue, reported by Mat Martineau

v7 changes:
- update to reflect changes in kernel_pkey_params struct

v6 changes:
- rabased on top of
http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl

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
 crypto/algif_akcipher.c     |  878 +++++++++++++++++++++++++++++++++++++++++++
 include/crypto/if_alg.h     |    2 
 include/uapi/linux/if_alg.h |    5 
 6 files changed, 918 insertions(+), 5 deletions(-)
 create mode 100644 crypto/algif_akcipher.c

--
TS
