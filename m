From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 1/5] lib/rhashtable: convert param sanitations to WARN_ON
Date: Fri, 1 Jun 2018 10:10:28 -0700
Message-ID: <20180601171028.3rjlozqmuoofa3iy@linux-r8p5>
References: <20180601160125.30031-1-dave@stgolabs.net>
 <20180601160125.30031-2-dave@stgolabs.net>
 <20180601160944.ji2gsp3pyunlj476@gondor.apana.org.au>
 <20180601165347.kvruerdm3gu57ifv@linux-r8p5>
 <20180601165903.bd3jonbv2jrfcevi@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180601165903.bd3jonbv2jrfcevi@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, tgraf@suug.ch, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Sat, 02 Jun 2018, Herbert Xu wrote:

>On Fri, Jun 01, 2018 at 09:53:47AM -0700, Davidlohr Bueso wrote:
>>
>> Curious, are these users setting up the param structure dynamically
>> or something that they can pass along bogus values?
>>
>> If that's the case then yes, I definitely agree.
>
>It's just a quality of implementation issue.  This is a generic API.
>Sure for early-boot users like yours it makes sense to just WARN_ON
>rather than deal with the messy hash table allocation failure.
>
>But for a driver author writing some kernel module it isn't nice
>to WARN_ON and then crash on a NULL-pointer dereference when we
>can cleanly fail the table init.

Fine, at least patch 2 applies without this one. So Andrew, if you
consider taking this series please drop patch 1 and 5 (which no
longer makes sense as rhashtable_init() won't be returning void
in the future).

If you want me to resend (assuming other issues are not pointed out),
I can do but I wanted to avoid spamming more the necessary.

Thanks,
Davidlohr
