From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] fsmap: fix documentation of FMR_OF_LAST
Date: Fri, 1 Sep 2017 01:09:04 -0700
Message-ID: <20170901080904.GA32746@infradead.org>
References: <20170831204918.GA7404@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170831204918.GA7404@magnolia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 31, 2017 at 01:49:18PM -0700, Darrick J. Wong wrote:
> The FMR_OF_LAST flag is set on the last fsmap record being returned for
> the dataset requested, contrary to what the header file says.  Fix the
> docs to reflect the behavior of all fsmap implementations.

Hmm.  What's the point of the flag then given that you can trivially
deduce the last entry from fmh_entries?
