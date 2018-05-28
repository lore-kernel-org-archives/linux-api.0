From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 1/6] lib/rhashtable: convert param sanitations to WARN_ON
Date: Mon, 28 May 2018 08:51:12 -0700
Message-ID: <20180528155112.iqsw6x3cdy5piaro@linux-n805>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-2-dave@stgolabs.net>
 <20180528094048.etqeu2ubc227qrxf@gondor.apana.org.au>
 <20180528131209.mt4ythkapvfvykc7@linux-n805>
 <20180528155414.mbwyldat7mn6ro2j@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528155414.mbwyldat7mn6ro2j@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Mon, 28 May 2018, Herbert Xu wrote:

>On Mon, May 28, 2018 at 06:12:09AM -0700, Davidlohr Bueso wrote:
>>
>> Well, I don't really _want_ them; nor does the ipc code which already
>> does a WARN_ON() (but that goes away in future patches). What I want
>> is to get rid of the return path. So I don't really care if we convert
>> them to WARN or remove them altogether. Would you be happy with the
>> later?
>
>It has nothing to do with the error return path.  Assuming you
>remove the allocation failure path, then this error path can never
>trigger for *your* use-case. 

Why would this be triggered by any use case if the developer setup the
params correctly...? I don't see the point of not getting rid of the
EINVAL or wrapping around warning around it. Ultimately it would be
good to just have rhashtable_init() return void.
