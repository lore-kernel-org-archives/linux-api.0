From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/6] lib/rhashtable: guarantee initial hashtable
 allocation
Date: Thu, 24 May 2018 20:26:20 -0700
Message-ID: <20180525032620.eg6gajv4hxxrm4y2@linux-n805>
References: <20180524211135.27760-1-dave@stgolabs.net>
 <20180524211135.27760-3-dave@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180524211135.27760-3-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

On Thu, 24 May 2018, Davidlohr Bueso wrote:
> 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
>+	if (retry) {
>+		gfp |= __GFP_NOFAIL;
>+		tbl = kzalloc(size, gfp);
>+	} /* fall-through */
>+
> 	if (gfp != GFP_KERNEL)
> 		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);

This is wrong I'll fix in a v2, it should be _else_ if (gfp != GFP_KERNEL) ...
