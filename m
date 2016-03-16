From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 21/22] ext4: Add richacl support
Date: Wed, 16 Mar 2016 23:38:32 +0100
Message-ID: <CAHc6FU5f4i_nvwR06Cp7dMJ0AZp2ZuXVrY7cdksLOR3y9P1_rw@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-22-git-send-email-agruenba@redhat.com>
	<20160311142719.GG14808@infradead.org>
	<CAHc6FU4TVKKYr-apCNTuR3aWAHpv7wZJ7ixePfy0Qt2VA49TZQ@mail.gmail.com>
	<20160315071707.GF19747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315071707.GF19747-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 8:17 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, Mar 14, 2016 at 12:08:31AM +0100, Andreas Gruenbacher wrote:
>> The xattr representation is the same on disk and at the xattr syscall
>> layer, and so richacl_from_xattr is used for converting into the
>> in-memory representation in both cases. The error codes are not the
>> same when a user supplies an invalid value via setxattr or NFS and
>> when an invalid xattr is read from disk though. I'll add a parameter
>> to richacl_from_xattr to make this more explicit.
>
> Better add a wrapper instead of a parameter.
>
>>
>> >> +static int
>> >> +__ext4_set_richacl(handle_t *handle, struct inode *inode, struct richacl *acl)
>> >> +{
>> >> +     const int name_index = EXT4_XATTR_INDEX_RICHACL;
>> >> +     umode_t mode = inode->i_mode;
>> >> +     int retval, size;
>> >> +     void *value;
>> >> +
>> >> +     if (richacl_equiv_mode(acl, &mode) == 0) {
>> >> +             inode->i_ctime = ext4_current_time(inode);
>> >> +             inode->i_mode = mode;
>> >> +             ext4_mark_inode_dirty(handle, inode);
>> >> +             return __ext4_remove_richacl(handle, inode);
>> >> +     }
>> >
>> > Should this check for a NULL acl instead of special casing that
>> > in ext4_set_richacl?
>>
>> I'm not sure I understand what you mean. When the
>
> ext4_set_richacl checks for a NULL acl pointer and then calls into
> __ext4_remove_richacl.  I'd rather have that special casing in one
> place.

Those are two different cases: the first is where ext4_set_richacl is
called with a NULL acl to remove an existing ACL; the second is where
ext4_set_richacl is called with a mode-equivalent ACL to set the mode
and remove any existing ACL.

The check for mode-equivalent ACLs is in __ext4_set_richacl and not in
ext4_set_richacl because an inherited ACL (ext4_init_acl) can also be
mode-equivalent.

Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
