From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher
 interface
Date: Wed, 22 Jun 2016 15:45:38 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1606221515040.16377@mjmartin-mac01.local>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <1499283.NSekfIF0FQ@tauon.atsec.com> <alpine.OSX.2.20.1606091126420.21471@mjmartin-mac01.local> <3072103.TY3EQcF1Bz@tauon.atsec.com> <dbcb97e0-35c0-7e6e-9351-d90a0d945bab@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <dbcb97e0-35c0-7e6e-9351-d90a0d945bab@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>, Stephan Mueller <smueller@chronox.de>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org


Stephan and Tadeusz,

On Fri, 10 Jun 2016, Tadeusz Struk wrote:

> On 06/09/2016 11:36 AM, Stephan Mueller wrote:
>> Am Donnerstag, 9. Juni 2016, 11:27:13 schrieb Mat Martineau:
>>
>> Hi Mat, Tadeusz,
>>
>> Ok, after checking the code again, I think that dropping that sanity check
>> should be ok given that this length is part of the akcipher API.
>>
>> Tadeusz, as you are currently managing that patch set, would you re-spin it
>> with the following check removed?
>>
>> +     if (usedpages < akcipher_calcsize(ctx)) {
>> +             err = -EMSGSIZE;
>> +             goto unlock;
>> +     }
>>
>
> Ok, I'll update the patch.

Thanks, that helps (especially with pkcs1pad).

This brings me to another proposal for read buffer sizing: AF_ALG akcipher 
can guarantee that partial reads (where the read buffer is shorter than 
the output of the crypto op) will work using the same semantics as 
SOCK_DGRAM/SOCK_SEQPACKET. With those sockets, as much data as will fit is 
copied in to the read buffer and the remainder is discarded.

I realize there's a performance and memory tradeoff, since the crypto 
algorithm needs a sufficiently large output buffer that would have to be 
created by AF_ALG akcipher. The user could manage that tradeoff by 
providing a larger buffer (typically key_size?) if it wants to avoid 
allocating and copying intermediate buffers inside the kernel.


--
Mat Martineau
Intel OTC
