From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v27 03/21] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
 permission flags
Date: Mon, 13 Feb 2017 16:42:27 +0100
Message-ID: <CAHc6FU5j41uqkEuYdFO3OBf9cAZck7Sxwkmht0oewSxUCu6CDw@mail.gmail.com>
References: <1476190256-1677-1-git-send-email-agruenba@redhat.com>
 <1476190256-1677-4-git-send-email-agruenba@redhat.com> <CAELBmZCgttywPy3EtkFao7SPESaw8VB5K6x7PTRk7gwSk7sXqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAELBmZCgttywPy3EtkFao7SPESaw8VB5K6x7PTRk7gwSk7sXqg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 2, 2016 at 10:57 AM, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org> wrote:
> On Tue, Oct 11, 2016 at 2:50 PM, Andreas Gruenbacher
> <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> Normally, deleting a file requires MAY_WRITE access to the parent
>> directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD access
>> to the parent directory or with MAY_DELETE_SELF access to the file.
>>
>> To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
>> when checking for delete access inside a directory, and MAY_DELETE_SELF
>> when checking for delete access to a file itself.
>>
>> The MAY_DELETE_SELF permission overrides the sticky directory check.
>
> And MAY_DELETE_SELF seems totally inappropriate to any kind of rename,
> since from the point of view of the inode we are not doing anything at
> all.  The modifications are all in the parent(s), and that's where the
> permission checks need to be.
>
>> @@ -2780,14 +2780,20 @@ static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
>>         BUG_ON(victim->d_parent->d_inode != dir);
>>         audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
>>
>> -       error = inode_permission(dir, mask);
>> +       error = inode_permission(dir, mask | MAY_WRITE | MAY_DELETE_CHILD);
>> +       if (!error && check_sticky(dir, inode))
>> +               error = -EPERM;
>> +       if (error && IS_RICHACL(inode) &&
>> +           inode_permission(inode, MAY_DELETE_SELF) == 0 &&
>> +           inode_permission(dir, mask) == 0)
>> +               error = 0;
>
> Why is MAY_WRITE missing here?  Everything not aware of
> MAY_DELETE_SELF (e.g. LSMs) will still need MAY_WRITE otherwise this
> is going to be a loophole.

Hmm, this has indeed slipped me. Should be fixed in the version I've
just posted.

Many thanks for the review.

Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
