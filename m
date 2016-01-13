From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Wed, 13 Jan 2016 06:05:32 -0800
Message-ID: <569659AC.9070506@intel.com>
References: <20151226155014.27615.14985.stgit@desktop.home>
 <10464.1452691882@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <10464.1452691882-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tadeusz Struk <tstruk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi David,
On 01/13/2016 05:31 AM, David Howells wrote:
>> > +	pkey = keyring->payload.data[asym_crypto];
>> > +	if (!pkey) {
>> > +		key_put(keyring);
>> > +		goto out;
>> > +	}
>> > +
>> > +	err = setkey(private, pkey->key, pkey->keylen);
>> > +	key_put(keyring);
> Note that you may not assume that there's data there that you can use in this
> manner.  The key might be a pointer to some hardware device such as a TPM.  I
> have a TPM asymmetric subtype in progress.

So is there anything in place that can be used to tell what the key actually is?
The security/integrity/digsig_asymmetric.c is using this api in a similar way, so
if it is incorrect digsig_asymmetric shouldn't work neither.

> 
> I think this really needs to be driven from a keyctl() because you need to let
> the asymmetric subtype decide how it wants to handle this.  I would suggest
> adding KEYCTL_{ASYM_GETINFO,SIGN,VERIFY,ENCRYPT,DECRYPT} - the problem is how
> to pass sufficient arguments, how to decrypt the private key and what metadata
> needs to be passed vs what is inline with the data.

I agree, ideally keyctl should do the job for all the cases and request_key()
should just return a key data.
Thanks,
-- 
TS
