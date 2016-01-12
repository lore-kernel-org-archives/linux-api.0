From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Mon, 11 Jan 2016 21:56:13 -0800
Message-ID: <5694957D.7080904@intel.com>
References: <20151226155014.27615.14985.stgit@desktop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151226155014.27615.14985.stgit-r49W/1Cwd2f9zxVx7UNMDg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tadeusz Struk <tstruk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi David, David and Marcel,
On 12/26/2015 07:50 AM, Tadeusz Struk wrote:
> From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Created on top of patchset from Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
> https://patchwork.kernel.org/patch/7877921/
> https://patchwork.kernel.org/patch/7877971/
> https://patchwork.kernel.org/patch/7877961/
> 
> This patch adds support for asymmetric key type to AF_ALG.
> It will work as follows: A new PF_ALG socket options will be
> added on top of existing ALG_SET_KEY and ALG_SET_PUBKEY, namely
> ALG_SET_PUBKEY_ID and ALG_SET_KEY_ID for setting public and
> private keys respectively. When these new options will be used
> the user instead of providing the key material, will provide a
> key id and the key itself will be obtained from kernel keyring
> subsystem. The user will use the standard tools (keyctl tool
> or the keyctl syscall) for key instantiation and to obtain the
> key id. The key id can also be obtained by reading the
> /proc/keys file.
> 
> When a key will be found, the request_key() function will
> return a requested key. Next the asymmetric key subtype will be
> used to obtain the public_key, which can be either a public key
> or a private key from the cryptographic point of view, and the
> key payload will be passed to the akcipher pf_alg subtype.
> Pf_alg code will then call crypto API functions, either the
> crypto_akcipher_set_priv_key or the crypto_akcipher_set_pub_key,
> depending on the used option. Subsequently the asymmetric key
> will be freed and return code returned back to the user.
> 
> Currently the interface will be restricted only to asymmetric
> ciphers, but it can be extended later to work with symmetric
> ciphers if required.
> 
> The assumption is that access rights for a given user will be
> verified by the key subsystem so the pf_alg interface can call
> the request_key() without checking if the user has appropriate
> rights (Please verify this assumption).
> 
> Changes in v2:
> Separate logic for setkey and setkey_id into two separate
> functions as proposed by Stephan.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  crypto/af_alg.c             |   49 +++++++++++++++++++++++++++++++++++++++----
>  include/uapi/linux/if_alg.h |    2 ++
>  2 files changed, 47 insertions(+), 4 deletions(-)

Do you have any comments on this?
Based on your feedback after Stephan sent the v2 algif_akcipher patches
the conclusion was that having both setkey and setkey_id will be acceptable.
This is exactly what this patch does, so will the algif_akcipher patches
with this one on top work for you?
Thanks,
-- 
TS
