From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 5/5] nfs: don't clear STATX_ATIME from result_mask
Date: Fri, 19 Oct 2018 19:46:16 +0200
Message-ID: <CAJfpegtq1+vZ+uXwzFs20GeSPCR9UbtqD5-fOn8ynoJUJYx25g@mail.gmail.com>
References: <20181019122049.27121-1-mszeredi@redhat.com> <20181019122049.27121-5-mszeredi@redhat.com>
 <2ca365ec330cf918188e8c47b26e741073382d9d.camel@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2ca365ec330cf918188e8c47b26e741073382d9d.camel@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trondmy@hammerspace.com>
Cc: "mszeredi@redhat.com" <mszeredi@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "amir73il@gmail.com" <amir73il@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "adilger@dilger.ca" <adilger@dilger.ca>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, "fw@deneb.enyo.de" <fw@deneb.enyo.de>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "dhowells@redhat.com" <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 19, 2018 at 5:52 PM, Trond Myklebust
<trondmy@hammerspace.com> wrote:
> On Fri, 2018-10-19 at 14:20 +0200, Miklos Szeredi wrote:
>> As per statx(2) man page only clear out flags that are unsupported by
>> the
>> fs or have an unrepresentable value.  Atime is supported by NFS as
>> long as
>> it's supported on the server.
>>
>> So the STATX_ATIME flag should not be cleared in the result_mask if
>> the
>> operation was requested on a MNT_NOATIME or MNT_NODIRATIME mount.
>>
>> This patch doesn't change the revalidation algorithm in any way, just
>> the
>> clearing of flags in stat->result_mask.
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> Fixes: 9ccee940bd5b ("Support statx() mask and query flags
>> parameters")
>> Cc: Trond Myklebust <trond.myklebust@primarydata.com>
>> ---
>>  fs/nfs/inode.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
>> index b65aee481d13..34bb3e591709 100644
>> --- a/fs/nfs/inode.c
>> +++ b/fs/nfs/inode.c
>> @@ -811,7 +811,7 @@ int nfs_getattr(const struct path *path, struct
>> kstat *stat,
>>       if (!(request_mask &
>> (STATX_MODE|STATX_NLINK|STATX_ATIME|STATX_CTIME|
>>                                       STATX_MTIME|STATX_UID|STATX_GID
>> |
>>                                       STATX_SIZE|STATX_BLOCKS)))
>> -             goto out_no_revalidate;
>> +             goto out_no_update;
>>
>>       /* Check whether the cached attributes are stale */
>>       do_update |= force_sync || nfs_attribute_cache_expired(inode);
>> @@ -833,9 +833,6 @@ int nfs_getattr(const struct path *path, struct
>> kstat *stat,
>>                       goto out;
>>       } else
>>               nfs_readdirplus_parent_cache_hit(path->dentry);
>> -out_no_revalidate:
>> -     /* Only return attributes that were revalidated. */
>> -     stat->result_mask &= request_mask;
>>  out_no_update:
>>       generic_fillattr(inode, stat);
>>       stat->ino = nfs_compat_user_ino64(NFS_FILEID(inode));
>
> NACK.
>
> When we don't revalidate the attribute, then the content of the field
> contains junk values. The above code is very intentional.

How is it then that only STATX_ATIME is cleared and not the other fields?

Note: junk != stale.  The statx definition doesn't talk about the
fields being up-to-date, except for AT_STATX_FORCE_SYNC, so stale
attributes are okay, and do not warrant clearing the result_mask.

Thanks,
Miklos
