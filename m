From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Date: Thu, 26 Oct 2017 12:22:05 -0600
Message-ID: <20171026182205.GA8048@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-19-jack@suse.cz>
 <20171024211007.GA1611@linux.intel.com>
 <20171026132402.GB31161@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171026132402.GB31161-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 26, 2017 at 03:24:02PM +0200, Jan Kara wrote:
> On Tue 24-10-17 15:10:07, Ross Zwisler wrote:
> > On Tue, Oct 24, 2017 at 05:24:15PM +0200, Jan Kara wrote:
> > > Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > 
> > This looks unchanged since the previous version?
> 
> Ah, thanks for checking. I forgot to commit modifications. Attached is
> really updated patch.
> 
> 								Honza
> -- 
> Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
> SUSE Labs, CR

> From 59eeec2998ed9b3840aab951f213148cb1d053a5 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Date: Thu, 19 Oct 2017 14:44:55 +0200
> Subject: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and MAP_SYNC
> 
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good, you can add: 

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
