From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v2 1/4] lib/rhashtable: simplify bucket_table_alloc()
Date: Fri, 22 Jun 2018 11:35:02 -0700
Message-ID: <20180622183502.i5dv4d3tbwh5sw6u@linux-r8p5>
References: <20180621212825.3059-1-dave@stgolabs.net>
 <20180621212825.3059-2-dave@stgolabs.net>
 <20180622181540.5gul4lx5dteqzzk3@linux-r8p5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180622181540.5gul4lx5dteqzzk3@linux-r8p5>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, neilb@suse.com
List-Id: linux-api@vger.kernel.org

On Fri, 22 Jun 2018, Davidlohr Bueso wrote:

>This slightly changes the gfp flags passed on to nested_table_alloc() as it will now
>also use GFP_ATOMIC | __GFP_NOWARN. However, I consider this a positive consequence
>as for the same reasons we want nowarn semantics in bucket_table_alloc().

If this is not acceptable, we can just keep the caller's current semantics - the
atomic flag could also be labeled 'rehash' or something considering that it comes
only from insert_rehash() when we get EAGAIN after trying to insert the first time:

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 9427b5766134..18740b052aec 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -172,17 +172,15 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 {
 	struct bucket_table *tbl = NULL;
 	size_t size, max_locks;
+	bool atomic = (gfp == GFP_ATOMIC);
 	int i;
 
 	size = sizeof(*tbl) + nbuckets * sizeof(tbl->buckets[0]);
-	if (gfp != GFP_KERNEL)
-		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
-	else
-		tbl = kvzalloc(size, gfp);
+	tbl = kvzalloc(size, atomic ? gfp | __GFP_NOWARN : gfp);
 
 	size = nbuckets;
 
-	if (tbl == NULL && gfp != GFP_KERNEL) {
+	if (tbl == NULL && atomic) {
 		tbl = nested_bucket_table_alloc(ht, nbuckets, gfp);
 		nbuckets = 0;
 	}
