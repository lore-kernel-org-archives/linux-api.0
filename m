From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v8 6/6] crypto: AF_ALG - add support for key_id
Date: Fri, 8 Jul 2016 08:21:58 -0700
Message-ID: <783d7868-6aae-40da-5df6-6e41ca2284fc@intel.com>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
 <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com>
 <alpine.OSX.2.20.1606291104130.37168@mjmartin-mac01.local>
 <e011a955-70c1-0419-9e2d-dea75d319da3@intel.com>
 <alpine.OSX.2.20.1607061211410.2149@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1607061211410.2149@mjmartin-mac01.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Hi Mat,
On 07/06/2016 12:38 PM, Mat Martineau wrote:
>> So it looks like the only thing that we need to return to the user in
>> this case is the return code. Do you agree?
> 
> The way verify_signature is implemented today, the only output is the
> return code. For verify, maybe no read is required (just sendmsg() and
> check the return code).
> 
> But this isn't the extent of the problem: verify_signature needs both
> the signature to be verified and the expected hash as inputs. How is the
> expected hash provided? Would you include it as a cmsg header?
> ALG_OP_VERIFY should have consistent inputs and outputs whether the key
> was set with ALG_SET_KEY_ID or ALG_SET_KEY.

The signature of verify_signature() is quite different from the other
new public key handlers, i.e. create_signature(), encrypt_blob(), and
decrypt_blob(). For verify_signature() we need the following parameters:
encrypted src, hash function to use, expected digest.
The expected digest could be optional if we would modify the
verify_signature() to return the decrypted buffer.
I think the best solution for now would be to just return -ENOPROTOOPT
for verify_signature in SET_KEY_ID mode.
All the four operations will be supported in the SET_KEY mode and
all but verify_signature() will be supported in the SET_KEY_ID mode.
This can added later if we will find a way to pass all parameters in a
consistent way. What do you think? If you are ok with that I will send a
new version soon.
Thanks,
-- 
TS
