From: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 9/9] btrfs: btrfs_copy_file_range() only supports
 reflinks
Date: Sat, 17 Oct 2015 09:44:40 -0400
Message-ID: <20151017134440.GE6874@ret.masoncoding.com>
References: <561B8A09.5070507@draigBrady.com>
 <20151012143444.GA10156@infradead.org>
 <20151012234106.GD11398@birch.djwong.org>
 <20151013072959.GB10794@infradead.org>
 <20151014184608.GK850@birch.djwong.org>
 <20151015060045.GA23996@infradead.org>
 <20151016114919.GB6874@ret.masoncoding.com>
 <20151016122544.GC5889@infradead.org>
 <20151016131950.GC6874@ret.masoncoding.com>
 <20151016214435.GA2786@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151016214435.GA2786@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, P??draig Brady <P@draigBrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 17, 2015 at 08:44:35AM +1100, Dave Chinner wrote:
> 
> > When we're doing writes, it'll check the preallocated extents for extra
> > refs and force COW if any exist.  So writes into a preallocated region
> > can enospc.
> 
> This really seems like an btrfs interpretation/implementation
> issue, not a problem for reflink in general.
> 

Right, now matter how we do it there are tradeoffs, and this one seemed
the least surprising to me.  I don't think it's a big problem at all.

Automatically replacing preallocated extents with holes during clone
seems like a better compromise though (at least for btrfs anyway).

-chris
