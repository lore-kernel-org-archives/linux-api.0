From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 20/22] vfs: Add richacl permission checking
Date: Thu, 14 Jul 2016 22:59:16 +0200
Message-ID: <CAHc6FU6+NpXZTMCub6XydBbHw_LVz8aPh8whZ9HwDoTbxjqLBw@mail.gmail.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
 <1467294433-3222-21-git-send-email-agruenba@redhat.com> <1468325634.7798.24.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468325634.7798.24.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 12, 2016 at 2:13 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
>> Hook the richacl permission checking function into the vfs.
>>
>> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/namei.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 52 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index 7a822d0..48c9958 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -34,6 +34,7 @@
>>  #include
>>  #include
>>  #include
>> +#include
>>  #include
>>  #include
>>  #include
>> @@ -256,7 +257,43 @@ void putname(struct filename *name)
>>               __putname(name);
>>  }
>>
>> -static int check_acl(struct inode *inode, int mask)
>> +static int check_richacl(struct inode *inode, int mask)
>> +{
>> +#ifdef CONFIG_FS_RICHACL
>> +     if (mask & MAY_NOT_BLOCK) {
>> +             struct base_acl *base_acl;
>> +
>> +             base_acl = rcu_dereference(inode->i_acl);
>> +             if (!base_acl)
>> +                     goto no_acl;
>> +             /* no ->get_richacl() calls in RCU mode... */
>> +             if (is_uncached_acl(base_acl))
>> +                     return -ECHILD;
>> +             return richacl_permission(inode, richacl(base_acl),
>> +                                       mask & ~MAY_NOT_BLOCK);
>> +     } else {
>> +             struct richacl *acl;
>> +
>> +             acl = get_richacl(inode);
>> +             if (IS_ERR(acl))
>> +                     return PTR_ERR(acl);
>> +             if (acl) {
>> +                     int error = richacl_permission(inode, acl, mask);
>> +                     richacl_put(acl);
>> +                     return error;
>> +             }
>> +     }
>> +no_acl:
>> +#endif
>
> nit: Can you move the above to a static inline or something that becomes a noop when the config var is turned off?

We could move check_richacl into richacl.c and check_posix_acl into
posix_acl.c. Given that those functions are currently only called once
in namei.c, that's a very small improvement at most though.

>> +     if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
>> +                 MAY_CHMOD | MAY_SET_TIMES)) {
>> +             /* File permission bits cannot grant this. */
>> +             return -EACCES;
>> +     }
>> +     return -EAGAIN;
>> +}
>> +
>> +static int check_posix_acl(struct inode *inode, int mask)
>>  {
>>  #ifdef CONFIG_FS_POSIX_ACL
>>       if (mask & MAY_NOT_BLOCK) {
>> @@ -294,11 +331,24 @@ static int acl_permission_check(struct inode *inode, int mask)
>>  {
>>       unsigned int mode = inode->i_mode;
>>
>> +     /*
>> +      * With POSIX ACLs, the (mode & S_IRWXU) bits exactly match the owner
>> +      * permissions, and we can skip checking posix acls for the owner.
>> +      * With richacls, the owner may be granted fewer permissions than the
>> +      * mode bits seem to suggest (for example, append but not write), and
>> +      * we always need to check the richacl.
>> +      */
>> +
>> +     if (IS_RICHACL(inode)) {
>> +             int error = check_richacl(inode, mask);
>> +             if (error != -EAGAIN)
>> +                     return error;
>> +     }
>>       if (likely(uid_eq(current_fsuid(), inode->i_uid)))
>>               mode >>= 6;
>>       else {
>>               if (IS_POSIXACL(inode) && (mode & S_IRWXG)) {
>> -                     int error = check_acl(inode, mask);
>> +                     int error = check_posix_acl(inode, mask);
>>                       if (error != -EAGAIN)
>>                               return error;
>>               }
>
> Looks fine other than the nit above:
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Andreas
