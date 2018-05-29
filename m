From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Tue, 29 May 2018 11:05:09 -0700
Message-ID: <20180529180509.dprhzm6zctpytqyy@linux-n805>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
 <20180528100237.needq2u5e3v2n642@gondor.apana.org.au>
 <20180529164231.yoj57nqhghtmy54v@linux-n805>
 <20180529180345.jwu2bzax764gtof5@gondor.apana.org.au>
 <20180529175513.s7iju6rkoya3hvsf@linux-n805>
 <20180529181510.ttlmndxk36rmkwcy@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529181510.ttlmndxk36rmkwcy@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Wed, 30 May 2018, Herbert Xu wrote:

>Well I think we should respect min_size.  rhashtable users may
>fail at insertion time if the table is too small.

I'm fine either way.
