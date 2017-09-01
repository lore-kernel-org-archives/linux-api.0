From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Date: Fri, 1 Sep 2017 08:07:16 -0700
Message-ID: <20170901150716.GW3775@magnolia>
References: <20170831204918.GA7404@magnolia>
 <20170901080904.GA32746@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170901080904.GA32746-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 01, 2017 at 01:09:04AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 31, 2017 at 01:49:18PM -0700, Darrick J. Wong wrote:
> > The FMR_OF_LAST flag is set on the last fsmap record being returned for
> > the dataset requested, contrary to what the header file says.  Fix the
> > docs to reflect the behavior of all fsmap implementations.
> 
> Hmm.  What's the point of the flag then given that you can trivially
> deduce the last entry from fmh_entries?

fmh_entries is the number of records returned, not the number of records
in the dataset.  If, for example, you allocate space for 100 records and
perform a query for a block that has been reflinked 1000 times, the
dataset size is 1000 but fmh_entries is set to 100.  The lack of a LAST
flag on the 100th record tells you that there's more records to return.

If however you allocate space for 100 records and the block is reflinked
exactly 100 times, there's no way (without the flag) for userspace to
know that record 100 is the end of the dataset, so the only thing it can
do is to fsmap_advance() and try the query again, only to receive zero
results.  Granted I don't think fsmap queries are all /that/ expensive,
but it's trivial for the kernel to set the flag.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
