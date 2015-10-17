From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
Date: Sun, 18 Oct 2015 10:17:59 +1100
Message-ID: <20151017231759.GV27164@dastard>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
 <1445008706-15115-22-git-send-email-agruenba@redhat.com>
 <5621346E.5000500@gmail.com>
 <CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
 <562141AD.60302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <562141AD.60302-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2015 at 02:27:57PM -0400, Austin S Hemmelgarn wrote:
> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
> >On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
> ><ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>I would like to re-iterate, on both XFS and ext4, I _really_ think this
> >>should be a ro_compat flag, and not an incompat one.  If a person has the
> >>ability to mount the FS (even if it's a read-only mount), then they by
> >>definition have read access to the file or partition that the filesystem is
> >>contained in, which means that any ACL's stored on the filesystem are
> >>functionally irrelevant,
> >
> >It is unfortunately not safe to make such a file system accessible to
> >other users, so the feature is not strictly read-only compatible.
> If it's not safe WRT data integrity, then the design needs to be
> reworked, as that directly implies that isn't safe for even every
> day usage on a writable filesystem.

This is exactly what we have *incompat feature flags for*: to
protect old code that doesn't know about potentially dangerous new
on-disk formats from trying to parse those formats and causing
unpredictable bad things from happening.

Austin, your arguments hold no weight because they are no different
to the considerations for any new on-disk feature: the user needs to
have both kernel and userspace support to recover filesystems that
go bad. If you are using a brand new fs/kernel feature, then it is
expected that you know that your DR processes take this into
account.

This is also why we XFS devs wait at least a year after new on-disk
features are merged into XFS before we consider turning them on by
default. i.e.  to give distros and recovery utilities time to pick
up kernels and userspace pacakges that support the new feature
before the average user will encounter it....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
