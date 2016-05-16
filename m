From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v6 0/6] crypto: algif - add akcipher
Date: Mon, 16 May 2016 13:46:10 -0700
Message-ID: <eb4c6853-7493-2a3f-a669-21ef6a6f8768@intel.com>
References: <5123.1462976721@warthog.procyon.org.uk>
 <20160515041645.15888.94903.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20160515041645.15888.94903.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
To: dhowells@redhat.com
Cc: herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

On 05/14/2016 09:16 PM, Tadeusz Struk wrote:
> First four patches are a resend of the v3 algif_akcipher from
> Stephan Mueller, with minor changes after rebase on top of 4.6-rc1.
> 
> The next three patches add support for keys stored in system
> keyring subsystem.
> 
> First patch adds algif_akcipher nokey hadlers.
> 
> Second patch adds generic sign, verify, encrypt, decrypt accessors
> functions to the asymmetric key type. These will be defined by
> asymmetric subtypes, similarly to how public_key currently defines
> the verify_signature function.
> 
> Third patch adds support for ALG_SET_KEY_ID and ALG_SET_PUBKEY_ID
> commands to AF_ALG and setkeyid operation to the af_alg_type struct.
> If the keyid is used then the afalg layer acquires the key for the
> keyring subsystem and uses the new asymmetric accessor functions
> instead of akcipher api. The asymmetric subtypes can use akcipher
> api internally.
> 
> This is the same v5 version as before rebased on top of
> http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl
> 
> v6 changes:
> - update to reflect changes in kernel_pkey_params struct
> 
> v5 changes:
> - drop public key changes and use new version provided by David
> 
> v4 changes:
> - don't use internal public_key struct in af_alg.
> - add generic accessor functions to asymmetric key type, which take
>   the generic struct key type and resolve the specific subtype internally
> 
> v3 changes:
> - include Stephan's patches (rebased on 4.6-rc1)
> - add algif_akcipher nokey hadlers
> - add public_key info struct to public_key and helper query functions
> - add a check if a key is a software accessible key on af_alg, and
>   return -ENOKEY if it isn't
> 
> v2 changes:
> - pass the original skcipher request in ablkcipher.base.data instead of
>   casting it back from the ablkcipher request.
> - rename _req to base_req
> - dropped 3/3
> 
> ---
> 
> Stephan Mueller (4):
>       crypto: AF_ALG -- add sign/verify API
>       crypto: AF_ALG -- add setpubkey setsockopt call
>       crypto: AF_ALG -- add asymmetric cipher interface
>       crypto: algif_akcipher - enable compilation
> 
> Tadeusz Struk (2):
>       crypto: algif_akcipher - add ops_nokey
>       crypto: AF_ALG - add support for key_id
> 
>  crypto/Kconfig              |    9 
>  crypto/Makefile             |    1 
>  crypto/af_alg.c             |   28 +
>  crypto/algif_akcipher.c     |  884 +++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/if_alg.h     |    2 
>  include/uapi/linux/if_alg.h |    5 
>  6 files changed, 924 insertions(+), 5 deletions(-)
>  create mode 100644 crypto/algif_akcipher.c

Hi David,
Are you ok to take it into 4.7 via your linux-fs?
Thanks,
-- 
TS
