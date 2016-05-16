From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RESEND v5 6/6] crypto: AF_ALG - add support for key_id
Date: Mon, 16 May 2016 07:23:48 -0700
Message-ID: <b1ce2519-df59-58c5-a1e4-c795afce3551@intel.com>
References: <20160505195048.1843.7817.stgit@tstruk-mobl1>
 <20160505195120.1843.35821.stgit@tstruk-mobl1>
 <alpine.OSX.2.20.1605131616200.29074@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1605131616200.29074@mjmartin-mac01.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Hi Mat,
On 05/13/2016 04:32 PM, Mat Martineau wrote:
> 
>> +    params.data_len = req->src_len;
>> +    params.enc_len = req->dst_len;

Thanks for info. I have sent an update for this.

> 
> The params member names have changed (now in_len and out_len).
>> +    ret = encrypt_blob(&params, in, out);
> 
> The encrypt function for the key can now be called with params.key->type->asym_eds_op(). This also allows you to factor out the duplication in asym_key_encrypt, asym_key_decrypt, and asym_key_sign. See keyctl_pkey_e_d_s() in keyctl_pkey.c
> 
>> +static int asym_key_verify(const struct key *key, struct akcipher_request *req)
> ...
>> +    ret = verify_signature(key, NULL, &sig);
> 
> key->type->asym_verify_signature() is available as well.

Since these operation will be triggered from userspace I think it's better to use the
official interface as defined in crypto/public_key.h instead of direct calls.
Some operation may not be implemented for a given key type and the official interface
performs necessary checks.
Thanks,
-- 
TS
