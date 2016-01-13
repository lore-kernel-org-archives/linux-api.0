From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] crypto: AF_ALG - add support for keys/asymmetric-type
Date: Wed, 13 Jan 2016 08:14:14 -0800
Message-ID: <569677D6.7070704@intel.com>
References: <20151226155014.27615.14985.stgit@desktop.home>
 <10464.1452691882@warthog.procyon.org.uk> <569659AC.9070506@intel.com>
 <1452697593.88154.49.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452697593.88154.49.camel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tadeusz Struk <tstruk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/13/2016 07:06 AM, David Woodhouse wrote:
> On Wed, 2016-01-13 at 06:05 -0800, Tadeusz Struk wrote:
>>
>> I agree, ideally keyctl should do the job for all the cases and
>> request_key() should just return a key data.
> 
> No, you can NOT RELY ON HAVING THE KEY DATA. It might be in hardware.

Ok, I get it now.

> You might have something which will perform sign/verify/encrypt/decrypt
> operations *with* the key at your request, but which can never just
> *give* you the key.
> 
> Any crypto API which relies on *having* the key is fundamentally wrong.
> 

All the crypto APIs out there rely on this.

I think the coupling of an algorithm to its key is the problem here.
Usually an algorithm should be able to work with any (valid) key.

The solution to this can be implemented on the crypto API. 
If the TMP driver would register its supported algorithms on the crypto API
and in the setkey function it would check if a key is a real key or this
"something" (probably a ptr to TMP dev instance?) then in the first
case it would fallback to an implementation that takes a key data.
In the second case it can do its thing whatever it is.

This will make it transparent to the users of both the request_key()
and the crypto API.
Thanks,
-- 
TS
