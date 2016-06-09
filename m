From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 09 Jun 2016 20:24:17 +0200
Message-ID: <1499283.NSekfIF0FQ@tauon.atsec.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1> <8115473.hELPVzZyL0@tauon.atsec.com> <alpine.OSX.2.20.1606091020130.21471@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.20.1606091020130.21471@mjmartin-mac01.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, dhowells@redhat.com, herbert@gondor.apana.org.au, linux-api@vger.kernel.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, dwmw2@infradead.org, davem@davemloft.net
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 9. Juni 2016, 11:18:04 schrieb Mat Martineau:

Hi Mat,

> > Or is your concern that the user space interface restricts things too much
> > and thus prevents a valid use case?
> 
> The latter - my primary concern is the constraint this places on userspace
> by forcing larger buffer sizes than might be necessary for the operation.
> struct akcipher_request has separate members for src_len and dst_len, and
> dst_len is documented as needing "to be at least as big as the expected
> result depending on the operation". Not the maximum result, the expected
> result. It's also documented that the cipher will generate an error if
> dst_len is insufficient and update the value with the required size.
> 
> I'm updating some userspace TLS code that worked with an earlier, unmerged
> patch set for AF_ALG akcipher (from last year). The read calls with
> shorter buffers were the main porting problem.

I see -- are you proposing to drop that check entirely?

Ciao
Stephan
