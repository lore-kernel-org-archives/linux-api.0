From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 02/51] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
 permission flags
Date: Wed, 4 Nov 2015 04:02:27 +0100
Message-ID: <CAHc6FU7q1WOTk_XH+pYOU2=i_ranmtbney9epyFQuTi27qOaGQ@mail.gmail.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
	<1446563847-14005-3-git-send-email-agruenba@redhat.com>
	<507E7A63-024B-4EBD-B0C3-4ABE8280440F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507E7A63-024B-4EBD-B0C3-4ABE8280440F-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 4, 2015 at 3:33 AM, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
> On Nov 3, 2015, at 8:16 AM, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> @@ -3667,7 +3674,7 @@ EXPORT_SYMBOL(dentry_unhash);
>>
>> int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>> {
>> -     int error = may_delete(dir, dentry, 1);
>> +     int error = may_delete(dir, dentry, true, false);
>
> This is a prime example why passing "true" and "false" as function arguments
> is not very useful, and especially prone to bugs when there are two of them.
>
> That said, this is code originally from Al, so he may have a different
> opinion.

Have you checked how vfs_rename uses the is_dir and new_is_dir
variables? Using file modes there probably won't help readability. An
enum maybe?

Thanks,
Andreas
