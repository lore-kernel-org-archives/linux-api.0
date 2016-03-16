From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Tue, 15 Mar 2016 22:40:00 -0500
Message-ID: <CAH2r5ms+bQTQjL5DUz0v7vWhcaUr_ewvDcFiSasFNYphFdsf=Q@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
 <20160311140134.GA14808@infradead.org> <CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
 <CAH2r5mv3OTmPOQBV7xc-uZmB0gWxykXOCEVOcybx3tbHiViTZg@mail.gmail.com> <20160315071439.GE19747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315071439.GE19747-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 2:14 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Fri, Mar 11, 2016 at 02:05:16PM -0600, Steve French wrote:
>> A loosely related question is what can be done for tools around existing
>> interfaces for ACLs.  I recently found out NTFS-3g has this xattr:
>>
>>     static const char nf_ns_xattr_ntfs_acl[] = "system.ntfs_acl";
>>
>> which allows you to query system.ntfs_acl xattr to get their full ACL
>
> Bah.  Filesystems really have no business exposing random system xattrs,
> and we really need to add a filter to fs/xattr.c to not expose
> arbitrary attrs ouside the user.* prefix.

Hopefully we don't consider them random system xattrs, it is
plausible that ntfs uses these for user space tools that I don't
have.

At least for cifs.ko a similar subset (querying ACLs, streams and
reparse info e.g.)
to the ntfs set would be very helpful.  For example,
Being able to query the actual ACL over the wire, is important for backup
and for debug, the only question is whether to do it via an xattr (possibly
being able to have some synergy with existing ntfs-3g tools) or an ioctl
(since adding an NTFS specific syscall for a couple fs doesn't make sense).


For the specific example of the odd ntfs.streams.list xattr, I can see why
they have it.  I would have mixed feelings about having no way to tell
streams and EAs from each other
since NTFS-3g displaying streams as xattrs and also Extended
Attributes (EAs) as xattrs
(and if they didn't have an additional xattr to list streams)
without a way to tell the difference (at least a system xattr to list
the alternate
data streams is useful).   There is useful information in alternate data streams
that backup (and debugging) programs need for some workloads,
for example the origin (where internet explorer downloaded a file from)
and file classification information.

-- 
Thanks,

Steve
