From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Tue, 29 May 2018 10:55:13 -0700
Message-ID: <20180529175513.s7iju6rkoya3hvsf@linux-n805>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
 <20180528100237.needq2u5e3v2n642@gondor.apana.org.au>
 <20180529164231.yoj57nqhghtmy54v@linux-n805>
 <20180529180345.jwu2bzax764gtof5@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529180345.jwu2bzax764gtof5@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Wed, 30 May 2018, Herbert Xu wrote:

>On Tue, May 29, 2018 at 09:42:31AM -0700, Davidlohr Bueso wrote:
>>
>> For the sake of simplicity, Linus suggested directly using HASH_MIN_SIZE
>> such that we have a single fallback.
>
>Where did he suggest that?

https://lkml.org/lkml/2018/5/24/1265
