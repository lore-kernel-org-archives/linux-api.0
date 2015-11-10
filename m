From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v15 00/22] Richacls (Core and Ext4)
Date: Tue, 10 Nov 2015 14:17:45 -0500
Message-ID: <20151110191745.GA19379@fieldses.org>
References: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
 <20151110112943.GA17038@infradead.org>
 <CAHc6FU5g7=wd1Wt4+GCaLJjNu7giruZyAON3VcYn-A=ffYMsmw@mail.gmail.com>
 <CAH2r5ms1ckC59o9sbBEBAWQA0Q3tGOs=YJpk01xg19zThJDt-w@mail.gmail.com>
 <20151110170703.GB17530@fieldses.org>
 <CAHc6FU6aWsWO1SOSyNVnbObE0GoE4dr5a3WVTgvX4xn0wum1Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHc6FU6aWsWO1SOSyNVnbObE0GoE4dr5a3WVTgvX4xn0wum1Fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 06:58:19PM +0100, Andreas Gruenbacher wrote:
> On Tue, Nov 10, 2015 at 6:07 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> > On Tue, Nov 10, 2015 at 10:43:46AM -0600, Steve French wrote:
> >> I don't have strong disagreement with using pseudo-xattrs to
> >> store/retrieve ACLs (we already do this) but retrieving/setting an ACL
> >> all at once can be awkward  when ACLs are quite large e.g. when it
> >> encodes to over 1MB
> >
> > At least in the NFS case, that's also a limitation of the protocol.
> 
> I couldn't find a limit in the NFSv4 specification, but the client and
> server implementations both define arbitrary ACL size limits. In
> addition, the xattr syscalls allow attributes to be up to 64k long.

I don't recall 4.0 specifying any limit, 4.1 does include negotiation of
maximum rpc calls and replies, and that effectively limits ACL sizes
since they have to fit in a single rpc.

> The bigger problem would be incrementally setting ACLs. To prevent
> processes from racing with each other, we would need a locking
> mechanism. In addition, the memory overhead would be prohibitive and
> access decisions would become extremely slow; we would have to come up
> with mechanisms to avoid those problems.

Right.  Anyway, not worth the trouble, I think.

(Though what might be worth thinking about at some point is just making
sure we fail in helpful ways.)

--b.
