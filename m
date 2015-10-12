From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 9/9] btrfs: btrfs_copy_file_range() only supports
 reflinks
Date: Mon, 12 Oct 2015 16:41:06 -0700
Message-ID: <20151012234106.GD11398@birch.djwong.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-10-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142939.GA30905@infradead.org>
 <561B8A09.5070507@draigBrady.com>
 <20151012143444.GA10156@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151012143444.GA10156-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: P??draig Brady <P@draigBrady.com>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Oct 12, 2015 at 07:34:44AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 12, 2015 at 11:23:05AM +0100, P??draig Brady wrote:
> > You're right that if the user doesn't notice, then there is no
> > point exposing this. However I think the user does notice as
> > there is a difference in the end state of the copy.  I.E. generally
> > if there is a different end state it would require an option,
> > while if only a different copying mechanism it would not.
> > I think the different end state of a reflink warrants an option for 3 reasons:
> > 
> >  - The user might want separate bits for resiliency. Now this is
> >    a weak argument due to possible deduplication in lower layers,
> >    but still valid is some setups.
> 
> This one is completely bogus.  For one because literally every lower
> layer can and increasinly will dedup or share in some form.  If we
> prentend we could do this we actively mislead the user.
> 
> >  - The user might want to avoid CoW at a later time critical stage.
> > 
> >  - The user might want to avoid ENOSPC at a later critical stage.
> 
> These two are the same and would be the argument for the "falloc" flag
> I mention before.  But we'd need to sit down and specify the exact
> semantics for it.  For example one important question that comes to mind
> is if it also applies for extents that are holes in the source range.

One of the patches in last week's XFS reflink patchbomb adds FALLOC_FL_UNSHARE
flag; at the moment it _only_ forces copy-on-write of shared blocks, and it
leaves holes alone.

Obviously we haven't yet figured out what are peoples' preferences in terms of
"fill the holes and unshare the shared" vs. "only unshare the shared" vs. "only
fill the holes".  It isn't that hard to add a FALLOC_FL_UNSHARE_FILL_HOLES flag
that fills the holes while unsharing is going on.

Personally I suspect that the most interest is in filling holes and unsharing,
because they don't want to pay for allocation at a critical stage for anywhere
in the file.  But I could be wrong, so allowing both goals to be expressed via
mode allows flexibility.

--D

> 
> I'd much rather get the basic system call in ASAP and then let people
> explain their use cases for this and only add it once we've made sure
> we have consistent semantics that actually fit the users needs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
