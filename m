From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Fri, 10 Jun 2016 07:42:00 -0700
Message-ID: <dbcb97e0-35c0-7e6e-9351-d90a0d945bab@intel.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
 <1499283.NSekfIF0FQ@tauon.atsec.com>
 <alpine.OSX.2.20.1606091126420.21471@mjmartin-mac01.local>
 <3072103.TY3EQcF1Bz@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3072103.TY3EQcF1Bz@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>, Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

On 06/09/2016 11:36 AM, Stephan Mueller wrote:
> Am Donnerstag, 9. Juni 2016, 11:27:13 schrieb Mat Martineau:
> 
> Hi Mat, Tadeusz,
> 
>> On Thu, 9 Jun 2016, Stephan Mueller wrote:
>>> Am Donnerstag, 9. Juni 2016, 11:18:04 schrieb Mat Martineau:
>>>
>>> Hi Mat,
>>>
>>>>> Or is your concern that the user space interface restricts things too
>>>>> much
>>>>> and thus prevents a valid use case?
>>>>
>>>> The latter - my primary concern is the constraint this places on
>>>> userspace
>>>> by forcing larger buffer sizes than might be necessary for the operation.
>>>> struct akcipher_request has separate members for src_len and dst_len, and
>>>> dst_len is documented as needing "to be at least as big as the expected
>>>> result depending on the operation". Not the maximum result, the expected
>>>> result. It's also documented that the cipher will generate an error if
>>>> dst_len is insufficient and update the value with the required size.
>>>>
>>>> I'm updating some userspace TLS code that worked with an earlier,
>>>> unmerged
>>>> patch set for AF_ALG akcipher (from last year). The read calls with
>>>> shorter buffers were the main porting problem.
>>>
>>> I see -- are you proposing to drop that check entirely?
>>
>> Yes.
> 
> Ok, after checking the code again, I think that dropping that sanity check 
> should be ok given that this length is part of the akcipher API.
> 
> Tadeusz, as you are currently managing that patch set, would you re-spin it 
> with the following check removed?
> 
> +     if (usedpages < akcipher_calcsize(ctx)) {
> +             err = -EMSGSIZE;
> +             goto unlock;
> +     }
> 

Ok, I'll update the patch.
Thanks,
-- 
TS
