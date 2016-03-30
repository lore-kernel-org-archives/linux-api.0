From: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH v3 7/7] crypto: AF_ALG - add support for key_id
Date: Wed, 30 Mar 2016 16:45:55 -0000
Message-ID: <43df2c05083399f050990dda6260c049.squirrel@twosheds.infradead.org>
References: <20160330005734.25410.28829.stgit@tstruk-mobl1>
    <20160330005649.25410.70508.stgit@tstruk-mobl1>
    <14284.1459355506@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14284.1459355506@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org


> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>
>> +	keyring = request_key(&key_type_asymmetric, key_name, NULL);
>> +
>> +	err = -ENOKEY;
>> +	if (IS_ERR(keyring))
>> +		goto out;
>> +
>> +	pkey = keyring->payload.data[asym_crypto];
>
> NAK.  This is liable to crash in future.  You may not assume that you know
> what keyring->payload.data[asym_crypto] points to.
>
> You may not use struct public_key outside of crypto/asymmetric_key/.  It's
> the
> internal data of the software subtype.  I'll move it out of the global
> header
> to remove the temptation;-).
>
> You must use accessor functions such as verify_signature().  Feel free to
> add
> further accessor functions such as query_asym_capabilities(),
> create_signature(), encrypt_blob() and decrypt_blob() or something like
> that.

Grr. This is not the first time this has been pointed out. And it
shouldn't have *needed* to be pointed out in the first place.

Please do not ignore review feedback.

Or common sense.


-- 
dwmw2
