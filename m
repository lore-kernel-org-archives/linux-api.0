From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 18/22] richacl: xattr mapping functions
Date: Fri, 11 Mar 2016 18:03:11 +0100
Message-ID: <CAHc6FU7gH54C-hfV8VQzgpYv=PYNvpA9dc8stgVf2_khF7dUdg@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<1456733847-17982-19-git-send-email-agruenba@redhat.com>
	<20160311141701.GE14808@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160311141701.GE14808-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 11, 2016 at 3:17 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> +#include <linux/richacl_xattr.h>
>> +
>> +MODULE_LICENSE("GPL");
>
> what's the point given that the code isn't even modolar?

A leftover, removed now.

>> +static void
>> +fix_xattr_from_user(const char *kname, void *kvalue, size_t size)
>> +{
>> +     if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
>> +             return;
>> +     kname += XATTR_SYSTEM_PREFIX_LEN;
>> +     if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
>> +         !strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
>> +             posix_acl_fix_xattr_from_user(kvalue, size);
>> +}
>>
>>  /*
>>   * Extended attribute SET operations
>> @@ -329,9 +339,7 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
>>                       error = -EFAULT;
>>                       goto out;
>>               }
>> -             if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> -                 (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> -                     posix_acl_fix_xattr_from_user(kvalue, size);
>> +             fix_xattr_from_user(kname, kvalue, size);
>>       }
>>
>>       error = vfs_setxattr(d, kname, kvalue, size, flags);
>> @@ -396,6 +404,17 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>>       return error;
>>  }
>>
>> +static void
>> +fix_xattr_to_user(const char *kname, void *kvalue, size_t size)
>> +{
>> +     if (strncmp(kname, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
>> +             return;
>> +     kname += XATTR_SYSTEM_PREFIX_LEN;
>> +     if (!strcmp(kname, XATTR_POSIX_ACL_ACCESS) ||
>> +         !strcmp(kname, XATTR_POSIX_ACL_DEFAULT))
>> +             posix_acl_fix_xattr_to_user(kvalue, size);
>> +}
>> +
>>  /*
>>   * Extended attribute GET operations
>>   */
>> @@ -426,9 +445,7 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
>>
>>       error = vfs_getxattr(d, kname, kvalue, size);
>>       if (error > 0) {
>> -             if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> -                 (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> -                     posix_acl_fix_xattr_to_user(kvalue, size);
>> +             fix_xattr_to_user(kname, kvalue, size);
>
> I don't see how this is related to the rest of the patch.

Indeed, this is unrelated now. I'll split it off.

>> +++ b/include/linux/richacl_xattr.h
>
> What's the point in splitting this from the richacl.h header?
>
> Same for the uapi versions.
>
>> +struct richacl_xattr {
>> +     unsigned char   a_version;
>> +     unsigned char   a_flags;
>
> Explicit __u8 for uapi headers, please.

Okay.

Thanks,
Andreas
