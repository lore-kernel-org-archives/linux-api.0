From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH 7/8] crypto: AF_ALG: add random number generator support
Date: Wed, 12 Nov 2014 18:23:27 +0100
Message-ID: <5463978F.7020508@redhat.com>
References: <4738444.A2vZX1nNCo@tachyon.chronox.de> <1914037.Wy7EiDNG7B@tachyon.chronox.de> <546387B8.9050601@redhat.com> <9137675.ZTbqvCU5Bi@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <9137675.ZTbqvCU5Bi@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, ABI/API <linux-api@vger.kernel.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/12/2014 05:54 PM, Stephan Mueller wrote:
> Am Mittwoch, 12. November 2014, 17:15:52 schrieb Daniel Borkmann:
>> On 11/12/2014 08:05 AM, Stephan Mueller wrote:
>>> This patch adds the random number generator support for AF_ALG.
>>>
>>> A random number generator's purpose is to generate data without
>>> requiring the caller to provide any data. Therefore, the AF_ALG
>>> interface handler for RNGs only implements a callback handler for
>>> recvmsg.
>>
>> ...
>>
>>> +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
>>> +		       struct msghdr *msg, size_t len, int flags)
>>> +{
>>> +	struct sock *sk = sock->sk;
>>> +	struct alg_sock *ask = alg_sk(sk);
>>> +	struct rng_ctx *ctx = ask->private;
>>> +	int err = -EFAULT;
>>> +
>>> +	if (0 == len)
>>
>> if (len == 0)
>> 	...
>>
>> [And also other places.]
>>
>> We don't use Yoda condition style in the kernel.
>
> Well, there is a very good reason for using the approach I have: we all have
> done the error of forgetting the second = sign.
>
> In my case, the compiler will complain and we fix the error right away.
>
> In your case, nobody is complaining but we introduced a nasty, potentially
> hard to debug error. Thus, I very much like to keep my version just to be on
> the safe side.
>
> Note, there was even a backdoor I have seen where the missing 2nd equal sign
> introduced a privilege escalation.
>
> Therefore, my standard coding practice is to have a fixed value on the left
> side and the variable on the right side of any comparison.

I understand, but then please add this proposal first into ...

   Documentation/CodingStyle

The problem is that while the rest of the kernel does not follow
this coding style, it's also much harder to read and/or program
this way for people not being used to. So the danger of bugs
slipping in this way is at least equally high. Besides that, this
argument would also only account for '==' checks.

>>> +		return 0;
>>> +	if (MAXSIZE < len)
>>> +		len = MAXSIZE;
>>> +
>>> +	lock_sock(sk);
>>> +	len = crypto_rng_get_bytes(ctx->drng, ctx->result, len);
>>> +	if (0 > len)
>>> +		goto unlock;
>>> +
>>> +	err = memcpy_toiovec(msg->msg_iov, ctx->result, len);
>>> +	memset(ctx->result, 0, err);
>>> +
>>
>> This looks buggy.
>>
>> If copy_to_user() fails from within memcpy_toiovec(), we call memset()
>> with a negative return value which is interpreted as size_t and thus
>> causes a buffer overflow writing beyond ctx->result, no?
>>
>> If it succeeds, we call memset(ctx->result, 0, 0) .....
>
> Right, good catch, I have to add a catch for negative error here.

Hm? Don't you rather mean to say to unconditionally do something like ...

   memzero_explicit(ctx->result, len);

...
>>> +	memset(ctx->result, 0, MAXSIZE);
>>
>> memset(ctx->result, 0, sizeof(ctx->result));
>
> Ok, if this is desired, fine with me.

Yes, please.
