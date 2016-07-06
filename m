From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v8 6/6] crypto: AF_ALG - add support for key_id
Date: Wed, 6 Jul 2016 12:38:56 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1607061211410.2149@mjmartin-mac01.local>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com> <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com> <alpine.OSX.2.20.1606291104130.37168@mjmartin-mac01.local>
 <e011a955-70c1-0419-9e2d-dea75d319da3@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <e011a955-70c1-0419-9e2d-dea75d319da3@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org


On Tue, 5 Jul 2016, Tadeusz Struk wrote:

> Hi Mat,
> On 06/29/2016 11:43 AM, Mat Martineau wrote:
>>> +    ret = verify_signature(key, &sig);
>>> +    if (!ret) {
>>> +        req->dst_len = sizeof(digest);
>>
>> I think you fixed the BUG_ON() problem but there's still an issue with
>> the handling of the digest. Check the use of sig->digest in
>> public_key_verify_signature(), it's an input not an output. Right now it
>> looks like 20 uninitialized bytes are compared with the computed digest
>> within verify_signature, and then the unintialized bytes are copied to
>> req->dst here.
>>
>> With some modifications to public_key_verify_signature you could get the
>> digest you need, but I'm not sure if verification with a hardware key
>> (like a key in a TPM) can or can not provide the digest needed. Maybe
>> this is why the verify_signature hook in struct asymmetric_key_subtype
>> is optional.
>>
>>> +        scatterwalk_map_and_copy(digest, req->dst, 0, req->dst_len, 1);
>>> +    }
>
> So it looks like the only thing that we need to return to the user in
> this case is the return code. Do you agree?

The way verify_signature is implemented today, the only output is the 
return code. For verify, maybe no read is required (just sendmsg() and 
check the return code).

But this isn't the extent of the problem: verify_signature needs both the 
signature to be verified and the expected hash as inputs. How is the 
expected hash provided? Would you include it as a cmsg header?
ALG_OP_VERIFY should have consistent inputs and outputs whether the key 
was set with ALG_SET_KEY_ID or ALG_SET_KEY.


--
Mat Martineau
Intel OTC
