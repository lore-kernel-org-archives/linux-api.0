From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Wed, 13 Jan 2016 05:52:07 -0800
Message-ID: <56965687.1020809@intel.com>
References: <20151226155014.27615.14985.stgit@desktop.home>
 <1452688062.88154.32.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452688062.88154.32.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tadeusz Struk <tstruk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org
Cc: smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello David,
On 01/13/2016 04:27 AM, David Woodhouse wrote:
>> +static int alg_setkey_id(void *private, const u8 *key, unsigned int keylen,
>> > +                        int (*setkey)(void *private, const u8 *key,
>> > +                                      unsigned int keylen))
>> > +{
>> > +       struct key *keyring;
>> > +       struct public_key *pkey;
>> > +       char key_name[12];
>> > +       u32 keyid = *((u32 *)key);
>> > +       int err;
>> > +
>> > +       sprintf(key_name, "id:%08x", keyid);
>> > +       keyring = request_key(&key_type_asymmetric, key_name, NULL);
>> > +
>> > +       err = -ENOKEY;
>> > +       if (IS_ERR(keyring))
>> > +               goto out;
>> > +
>> > +       pkey = keyring->payload.data[asym_crypto];
>> > +       if (!pkey) {
>> > +               key_put(keyring);
>> > +               goto out;
>> > +       }
>> > +
>> > +       err = setkey(private, pkey->key, pkey->keylen);
>> > +       key_put(keyring);
>> > +
>> > +out:
>> > +       return err;
>> > +}
> This seems entirely wrong to me. You cannot just assume that the
> private key data are available in software form to the kernel and can
> be extracted.

Thanks for your feedback.
Yes, I'm aware that there might be something missing, and it might not
work in all the cases, but as far as the user interface is concerned
do you think having the ALG_SET_KEY, ALG_SET_PUBKEY along with
ALG_SET_PUBKEY_ID and ALG_SET_KEY_ID should be enough for all cases.
That's the main point of this patch - to get the user interface right.
The worst what can happen now if the keys need to be explicitly
extracted from a TPM HW is that the user will get ENOKEY error.
>From the other hand shouldn't that happen under the hood in request_key()
It doesn't look right to me that the pf_alg module has to directly
interact with the TPM.

> 
> Please ensure you test this with a key in a TPM, or in a SGX software
> enclave or something like that.

I don't have any HW for this. I only tested it with the keys instantiated
using the keyctl tool.

Thanks,
-- 
TS
