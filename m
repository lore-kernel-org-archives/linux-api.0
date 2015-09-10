From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 9/8] copy_file_range.2: New page documenting
 copy_file_range()
Date: Thu, 10 Sep 2015 09:43:45 -0700
Message-ID: <20150910164345.GF10391@birch.djwong.org>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1441397823-1203-10-git-send-email-Anna.Schumaker@Netapp.com>
 <20150904213856.GC10391@birch.djwong.org>
 <55EEF8E3.8030501@Netapp.com>
 <20150908203918.GB30681@birch.djwong.org>
 <55F01A26.7070706@gmail.com>
 <20150909171757.GE10391@birch.djwong.org>
 <20150910154251.GM8891@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150910154251.GM8891-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dsterba-AlSwsSmVLrQ@public.gmane.org, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 10, 2015 at 05:42:51PM +0200, David Sterba wrote:
> On Wed, Sep 09, 2015 at 10:17:57AM -0700, Darrick J. Wong wrote:
> > I noticed that btrfs won't dedupe more than 16M per call.  Any thoughts?
> 
> btrfs_ioctl_file_extent_same:
> 
> 3138         /*
> 3139          * Limit the total length we will dedupe for each operation.
> 3140          * This is intended to bound the total time spent in this
> 3141          * ioctl to something sane.
> 3142          */
> 3143         if (len > BTRFS_MAX_DEDUPE_LEN)
> 3144                 len = BTRFS_MAX_DEDUPE_LEN;
> 
> The deduplication compares the source and destination blocks and does
> not use the checksum based approach (btrfs_cmp_data()). The 16M limit is
> artifical, I don't have an estimate whether the value is ok or not. The
> longer dedupe chunk the lower the chance to find more matching extents,
> so the practially used chunk sizes are in range of hundreds of
> kilobytes. But this obviously depends on data and many-megabyte-sized
> chunks could fit some usecases easily.

I guessed that 16M was a 'reasonable default maximum' since the semantics seem
to be "link these two ranges together if all block contents match", not "I
think these ranges match, link together any blocks which actually /do/ match".
Personally, I doubt that it'll often be the case that a dedupe tool finds >16M
chunks to dedupe *and* for whatever reason can't just call iteratively.

Internally it could do some fadvise-like magic to avoid polluting the page
cache with the compares, but I agree that not letting the call take forever
is a good thing.

Oh well.  It /could/ be a per-fs tunable if anyone yells loudly.

--D
