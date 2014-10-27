From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Date: Mon, 27 Oct 2014 15:09:40 -0400
Message-ID: <CANP1eJGe0KRjGDhx=h_A_jH7qLOh2+uLVpzWbBpxwG6ZyzdreQ@mail.gmail.com>
References: <cover.1413923420.git.milosz@adfin.com>
	<ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
	<CAH2r5msUXQn+J3hoU-66Oz5EQpB7f_ObOaw9vnqY8=tgCB4J7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAH2r5msUXQn+J3hoU-66Oz5EQpB7f_ObOaw9vnqY8=tgCB4J7g@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 27, 2014 at 3:03 PM, Steve French <smfrench@gmail.com> wrote:
> What would be required for a network file system to support the
> RWF_NONBLOCK flag?
>
> SMB3 operations are all async (on the wire) by default but they do
> block on the network send and interim response.

Steve,

Any kernel filesystem that stores data in the page cache and does not
require a blocking/waiting operation (on network or diskIO, not locks)
should support this flag. If the data is in the page cache locally
we'll return it right away without blocking, otherwise we'll return
EAGAIN.

Think of this operation as being analogous to doing a recv with
MSG_NOWAIT ... where it will return data if there's data in the socket
buffer, otherwise returns EAGAIN.

I Hope this helps.


>
> On Tue, Oct 21, 2014 at 3:46 PM, Milosz Tanski <milosz@adfin.com> wrote:
>> Filesystems that generic_file_read_iter will not be allowed to perform
>> non-blocking reads. This only will read data if it's in the page cache and if
>> there is no page error (causing a re-read).
>>
>> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).
>>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>> ---
>>  fs/cifs/file.c     |  6 ++++++
>>  fs/ocfs2/file.c    |  6 ++++++
>>  fs/pipe.c          |  3 ++-
>>  fs/read_write.c    | 21 ++++++++++++++-------
>>  fs/xfs/xfs_file.c  |  4 ++++
>>  include/linux/fs.h |  3 +++
>>  mm/filemap.c       | 18 ++++++++++++++++++
>>  mm/shmem.c         |  4 ++++
>>  8 files changed, 57 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 3e4d00a..c485afa 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -3005,6 +3005,9 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
>>         struct cifs_readdata *rdata, *tmp;
>>         struct list_head rdata_list;
>>
>> +       if (iocb->ki_rwflags & RWF_NONBLOCK)
>> +               return -EAGAIN;
>> +
>>         len = iov_iter_count(to);
>>         if (!len)
>>                 return 0;
>> @@ -3123,6 +3126,9 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
>>             ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
>>                 return generic_file_read_iter(iocb, to);
>>
>> +       if (iocb->ki_rwflags & RWF_NONBLOCK)
>> +               return -EAGAIN;
>> +
>>         /*
>>          * We need to hold the sem to be sure nobody modifies lock list
>>          * with a brlock that prevents reading.
>> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
>> index 324dc93..bb66ca4 100644
>> --- a/fs/ocfs2/file.c
>> +++ b/fs/ocfs2/file.c
>> @@ -2472,6 +2472,12 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
>>                         filp->f_path.dentry->d_name.name,
>>                         to->nr_segs);   /* GRRRRR */
>>
>> +       /*
>> +        * No non-blocking reads for ocfs2 for now.  Might be doable with
>> +        * non-blocking cluster lock helpers.
>> +        */
>> +       if (iocb->ki_rwflags & RWF_NONBLOCK)
>> +               return -EAGAIN;
>>
>>         if (!inode) {
>>                 ret = -EINVAL;
>> diff --git a/fs/pipe.c b/fs/pipe.c
>> index 21981e5..212bf68 100644
>> --- a/fs/pipe.c
>> +++ b/fs/pipe.c
>> @@ -302,7 +302,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>>                          */
>>                         if (ret)
>>                                 break;
>> -                       if (filp->f_flags & O_NONBLOCK) {
>> +                       if ((filp->f_flags & O_NONBLOCK) ||
>> +                           (iocb->ki_rwflags & RWF_NONBLOCK)) {
>>                                 ret = -EAGAIN;
>>                                 break;
>>                         }
>> diff --git a/fs/read_write.c b/fs/read_write.c
>> index e3d8451..955d829 100644
>> --- a/fs/read_write.c
>> +++ b/fs/read_write.c
>> @@ -835,14 +835,19 @@ static ssize_t do_readv_writev(int type, struct file *file,
>>                 file_start_write(file);
>>         }
>>
>> -       if (iter_fn)
>> +       if (iter_fn) {
>>                 ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
>>                                                 pos, iter_fn, flags);
>> -       else if (fnv)
>> -               ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
>> -                                               pos, fnv);
>> -       else
>> -               ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
>> +       } else {
>> +               if (type == READ && (flags & RWF_NONBLOCK))
>> +                       return -EAGAIN;
>> +
>> +               if (fnv)
>> +                       ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
>> +                                                       pos, fnv);
>> +               else
>> +                       ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
>> +       }
>>
>>         if (type != READ)
>>                 file_end_write(file);
>> @@ -866,8 +871,10 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
>>                 return -EBADF;
>>         if (!(file->f_mode & FMODE_CAN_READ))
>>                 return -EINVAL;
>> -       if (flags & ~0)
>> +       if (flags & ~RWF_NONBLOCK)
>>                 return -EINVAL;
>> +       if ((file->f_flags & O_DIRECT) && (flags & RWF_NONBLOCK))
>> +               return -EAGAIN;
>>
>>         return do_readv_writev(READ, file, vec, vlen, pos, flags);
>>  }
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index eb596b4..b1f6334 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -246,6 +246,10 @@ xfs_file_read_iter(
>>
>>         XFS_STATS_INC(xs_read_calls);
>>
>> +       /* XXX: need a non-blocking iolock helper, shouldn't be too hard */
>> +       if (iocb->ki_rwflags & RWF_NONBLOCK)
>> +               return -EAGAIN;
>> +
>>         if (unlikely(file->f_flags & O_DIRECT))
>>                 ioflags |= XFS_IO_ISDIRECT;
>>         if (file->f_mode & FMODE_NOCMTIME)
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 9ed5711..eaebd99 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -1459,6 +1459,9 @@ struct block_device_operations;
>>  #define HAVE_COMPAT_IOCTL 1
>>  #define HAVE_UNLOCKED_IOCTL 1
>>
>> +/* These flags are used for the readv/writev syscalls with flags. */
>> +#define RWF_NONBLOCK 0x00000001
>> +
>>  struct iov_iter;
>>
>>  struct file_operations {
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index 45964c8..e73ba7e 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -1493,6 +1493,8 @@ static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
>>  find_page:
>>                 page = find_get_page(mapping, index);
>>                 if (!page) {
>> +                       if (flags & RWF_NONBLOCK)
>> +                               goto would_block;
>>                         page_cache_sync_readahead(mapping,
>>                                         ra, filp,
>>                                         index, last_index - index);
>> @@ -1584,6 +1586,11 @@ page_ok:
>>                 continue;
>>
>>  page_not_up_to_date:
>> +               if (flags & RWF_NONBLOCK) {
>> +                       page_cache_release(page);
>> +                       goto would_block;
>> +               }
>> +
>>                 /* Get exclusive access to the page ... */
>>                 error = lock_page_killable(page);
>>                 if (unlikely(error))
>> @@ -1603,6 +1610,12 @@ page_not_up_to_date_locked:
>>                         goto page_ok;
>>                 }
>>
>> +               if (flags & RWF_NONBLOCK) {
>> +                       unlock_page(page);
>> +                       page_cache_release(page);
>> +                       goto would_block;
>> +               }
>> +
>>  readpage:
>>                 /*
>>                  * A previous I/O error may have been due to temporary
>> @@ -1673,6 +1686,8 @@ no_cached_page:
>>                 goto readpage;
>>         }
>>
>> +would_block:
>> +       error = -EAGAIN;
>>  out:
>>         ra->prev_pos = prev_index;
>>         ra->prev_pos <<= PAGE_CACHE_SHIFT;
>> @@ -1706,6 +1721,9 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>>                 size_t count = iov_iter_count(iter);
>>                 loff_t size;
>>
>> +               if (iocb->ki_rwflags & RWF_NONBLOCK)
>> +                       return -EAGAIN;
>> +
>>                 if (!count)
>>                         goto out; /* skip atime */
>>                 size = i_size_read(inode);
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index cd6fc75..5c30f04 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1531,6 +1531,10 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>>         ssize_t retval = 0;
>>         loff_t *ppos = &iocb->ki_pos;
>>
>> +       /* XXX: should be easily supportable */
>> +       if (iocb->ki_rwflags & RWF_NONBLOCK)
>> +               return -EAGAIN;
>> +
>>         /*
>>          * Might this read be for a stacking filesystem?  Then when reading
>>          * holes of a sparse file, we actually need to allocate those pages,
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Thanks,
>
> Steve



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
