From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Mon, 21 Dec 2015 14:29:21 -0800
Message-ID: <56787D41.8070109@intel.com>
References: <20151221205107.28935.59696.stgit@desktop.home>
 <1668437.RHtfyqeg0Q@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1668437.RHtfyqeg0Q-Veo+UhszpQh6vwJ5+F2VIg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>, Tadeusz Struk <tstruk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Stephan,
On 12/21/2015 01:27 PM, Stephan Mueller wrote:
>> @@ -192,7 +194,30 @@ static int alg_setkey(struct sock *sk, char __user
>> > *ukey, if (copy_from_user(key, ukey, keylen))
>> >  		goto out;
>> > 
>> > -	err = setkey(ask->private, key, keylen);
>> > +	if (key_id) {
> Wouldn't it make sense to rather have a complete separate function for setting 
> the key based on the ID? I.e. we have one function for setting the key based 
> on a user-given buffer. A second function handles your additional code. As 
> both are unrelated, I would not suggest to clutter one function with the logic 
> of the other.

Either way is fine with me. I just didn't want to have too many indentation
levels in the alg_setsockopt function.

> 
>> -		err = alg_setkey(sk, optval, optlen, type->setkey);
>> > +		/* ALG_SET_KEY_ID is only for akcipher */
>> > +		if (!strcmp(type->name, "akcipher") && key_id)
> Why do you want to limit it to akcipher? I would think it can apply to all 
> types of keys. You mention that you want to restrict it to akcipher, but where 
> do you see the limitation for HMAC / skcipher?
> 
I pass key_type_asymmetric to request_key(), which only works with asymmetric.
To enable symmetric we would need to have a new key type, which would handle
both. 
Thanks,
-- 
TS
