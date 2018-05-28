From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] lib/rhashtable: convert param sanitations to WARN_ON
Date: Mon, 28 May 2018 17:40:48 +0800
Message-ID: <20180528094048.etqeu2ubc227qrxf@gondor.apana.org.au>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-2-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180524211135.27760-2-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Thu, May 24, 2018 at 02:11:30PM -0700, Davidlohr Bueso wrote:
> For the purpose of making rhashtable_init() unable to fail,
> we can replace the returning -EINVAL with WARN_ONs whenever
> the caller passes bogus parameters during initialization.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

I don't really see why we need these WARN_ONs.  The problem should
be quite obvious when you're writing your code.

If you really want them perhaps add them to the ipc code instead?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
