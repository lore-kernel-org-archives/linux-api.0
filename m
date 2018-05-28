From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] lib/rhashtable: convert param sanitations to WARN_ON
Date: Mon, 28 May 2018 23:54:14 +0800
Message-ID: <20180528155414.mbwyldat7mn6ro2j@gondor.apana.org.au>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-2-dave@stgolabs.net>
 <20180528094048.etqeu2ubc227qrxf@gondor.apana.org.au>
 <20180528131209.mt4ythkapvfvykc7@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528131209.mt4ythkapvfvykc7@linux-n805>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Mon, May 28, 2018 at 06:12:09AM -0700, Davidlohr Bueso wrote:
>
> Well, I don't really _want_ them; nor does the ipc code which already
> does a WARN_ON() (but that goes away in future patches). What I want
> is to get rid of the return path. So I don't really care if we convert
> them to WARN or remove them altogether. Would you be happy with the
> later?

It has nothing to do with the error return path.  Assuming you
remove the allocation failure path, then this error path can never
trigger for *your* use-case.  IOW you can either just ignore the
return value for ipc or just do the WARN_ON in your code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
