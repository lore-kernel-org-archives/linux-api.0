From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Fri, 16 Oct 2015 05:24:53 -0700
Message-ID: <20151016122453.GB5889@infradead.org>
References: <20151012231749.GC11398@birch.djwong.org>
 <561E980C.9010509@Netapp.com>
 <CALCETrU0-Q-q0u0BAPwu+mbyS+LVp6M1Hqro3xwzSm7eNCbEmg@mail.gmail.com>
 <20151014182701.GC31225@infradead.org>
 <561EA83E.8080000@gmail.com>
 <20151015063621.GA3025@infradead.org>
 <561F9B13.7020804@gmail.com>
 <20151016053808.GA29510@infradead.org>
 <5620E3A1.90408@gmail.com>
 <5620E74F.50006@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5620E74F.50006-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: P??draig Brady <P@draigBrady.com>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2015 at 01:02:23PM +0100, P??draig Brady wrote:
> Right. reflinking is transparent to the user, though its consequences are not.
> Consequences being the possible extra latency or ENOSPC on CoW.

You can get all these consequences without doing the file system reflink
by using a COW file system, any dedup scheme or thinly provisioned or
COW storage devices.

> Therefore reflinking should be an explicit action/flag IMHO.

This still does not make any sense, as it only prevents one of many
ways a file could do COW operations underneath.  If you don't want
ENOSPC use fallocate, or the proposed COPY_FALLOC flag.  If you want
care about latency you need to carefull benchmark your setup but in
general falloc / COPY_FALLOC might be a good starting point.  But for
99% of the copies a reflink is exactly the right thing to do.
