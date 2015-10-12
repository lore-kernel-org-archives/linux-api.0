From: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v5 9/9] btrfs: btrfs_copy_file_range() only supports
 reflinks
Date: Mon, 12 Oct 2015 11:23:05 +0100
Message-ID: <561B8A09.5070507@draigBrady.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-10-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142939.GA30905@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151011142939.GA30905-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/10/15 15:29, Christoph Hellwig wrote:
> On Wed, Sep 30, 2015 at 01:26:53PM -0400, Anna Schumaker wrote:
>> Reject copies that don't have the COPY_FR_REFLINK flag set.
>=20
> I think a reflink actually is a perfectly valid copy, and I don't buy
> the duplicate arguments in earlier threads.  We really need to think
> more in terms of how this impacts a user and now how it's implemented
> internally.  How does a user notice it's a reflink?  They don't as
> implemented in btrfs and co.=20

You're right that if the user doesn't notice, then there is no
point exposing this. However I think the user does notice as
there is a difference in the end state of the copy.  I.E. generally
if there is a different end state it would require an option,
while if only a different copying mechanism it would not.
I think the different end state of a reflink warrants an option for 3 r=
easons:

 - The user might want separate bits for resiliency. Now this is
   a weak argument due to possible deduplication in lower layers,
   but still valid is some setups.

 - The user might want to avoid CoW at a later time critical stage.

 - The user might want to avoid ENOSPC at a later critical stage.

> Now on filesystem that don't always do
> copy on write but might support reflinks (ocfs2, XFS in the future)
> this becomes a bit more interesting - the difference he is that we
> get an implicit fallocate when doing a real copy.  But if that's
> something we have actual requests for that's how we should specify
> it rather than in terms of arcane implementation details.

thanks,
P=E1draig.
