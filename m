From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Wed, 14 Oct 2015 23:36:21 -0700
Message-ID: <20151015063621.GA3025@infradead.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142203.GA31867@infradead.org>
 <20151012231749.GC11398@birch.djwong.org>
 <561E980C.9010509@Netapp.com>
 <CALCETrU0-Q-q0u0BAPwu+mbyS+LVp6M1Hqro3xwzSm7eNCbEmg@mail.gmail.com>
 <20151014182701.GC31225@infradead.org>
 <561EA83E.8080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561EA83E.8080000-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 14, 2015 at 03:08:46PM -0400, Austin S Hemmelgarn wrote:
> Whether or not reflink is different from a copy is entirely a matter of who
> is looking at it.

So what?  I've been trying to explain why clone semantics matter, and
I've not seen a counter argument for that.  I've also explained a couple
times that a valid clone always is a valid copy, and I've only heard
some slight disagreement, and so far none as long as we take the
COPY_FALLOCATE option into account.

Note that all of this also applies to storage devices - any smart array
will do a clone-like operation underneath an XCOPY, but so far SCSI
doesn't provide full clone _semantics_ even if you can emulate a lot of
it using a lot of complexity around ROD tokens.

Similar at the SCSI level you can perform a fallocate-like operation
using the anchor bit in the UNMAP or WRITE SAME commands.

> I agree that we shouldn't try to make a reflink by default (less than
> intelligent programmers won't read the docs completely, and will make
> various stupid assumptions about how this is 'supposed' to work, making the
> defaults less ambiguous is a good thing), but it makes sense (at least, it
> does to me) to have the ability to say 'make this block of data appear at
> this location as well, I don't care how you do it as long as they are
> functionally independent for userspace applications'.

Yes, we absolutely should use reflink as a default implementation for
copy where available.

But we also need a clone or reflink interface that only gives us well
specified reflink semantics, and not the much weaker copy semantics.
