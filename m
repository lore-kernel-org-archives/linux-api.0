From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v8 6/6] crypto: AF_ALG - add support for key_id
Date: Fri, 8 Jul 2016 10:26:55 -0700
Message-ID: <1184c5f4-5a87-452f-dd29-ab207403f677@intel.com>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
 <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com>
 <alpine.OSX.2.20.1606291104130.37168@mjmartin-mac01.local>
 <e011a955-70c1-0419-9e2d-dea75d319da3@intel.com>
 <alpine.OSX.2.20.1607061211410.2149@mjmartin-mac01.local>
 <783d7868-6aae-40da-5df6-6e41ca2284fc@intel.com>
 <alpine.OSX.2.20.1607080826160.39799@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1607080826160.39799@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au, smueller@chronox.de, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

On 07/08/2016 09:38 AM, Mat Martineau wrote:
> Are the inputs and outputs defined for ALG_OP_VERIFY in SET_KEY mode
> going to work for hardware keys (like TPM) in SET_KEY_ID mode? That's
> needed if the verify SET_KEY_ID mode is to be added later.

Yes, we will just need to change the verify_signature() in public_key.c
to be consistent with the rest of handlers. What we need really is the
src (encrypted input), key (or key id), and an output buffer where we
can copy the result to.
Thanks,
-- 
TS
