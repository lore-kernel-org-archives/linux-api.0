From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 09/10] fs: add RWF_DSYNC aand RWF_SYNC
Date: Sun, 7 Aug 2016 07:45:03 +1000
Message-ID: <CAKgNAkjza2eZnS7bzmvg1nB_jLmtk1N-o=uusD_hBo20sHTyaA@mail.gmail.com>
References: <1460044324-5298-1-git-send-email-hch@lst.de> <1460044324-5298-10-git-send-email-hch@lst.de>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1460044324-5298-10-git-send-email-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello Christoph,

On 8 April 2016 at 01:52, Christoph Hellwig <hch@lst.de> wrote:
> This is the per-I/O equivalent of O_DSYNC and O_SYNC, and very useful for
> all kinds of file servers and storage targets.

I've added some documentation for these flags to the man page, but in
the process I realized that have a question. Do these flags provide
equivalents of O_DSYNC and O_SYNC for the I/O operation, or for the
file? What I mean is this: with, say, RWF_DSYNC, is it just the data
written by this pwritev2() call that is synced to the underlying file,
or is all dirty data for the file synced at that point?

Thanks,

Michael


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/read_write.c         | 6 +++++-
>  include/uapi/linux/fs.h | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index cf377cf..3729d8d 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -698,12 +698,16 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
>         struct kiocb kiocb;
>         ssize_t ret;
>
> -       if (flags & ~RWF_HIPRI)
> +       if (flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))
>                 return -EOPNOTSUPP;
>
>         init_sync_kiocb(&kiocb, filp);
>         if (flags & RWF_HIPRI)
>                 kiocb.ki_flags |= IOCB_HIPRI;
> +       if (flags & RWF_DSYNC)
> +               kiocb.ki_flags |= IOCB_DSYNC;
> +       if (flags & RWF_SYNC)
> +               kiocb.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
>         kiocb.ki_pos = *ppos;
>
>         ret = fn(&kiocb, iter);
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index a079d50..e21fe04 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -324,5 +324,7 @@ struct fscrypt_policy {
>
>  /* flags for preadv2/pwritev2: */
>  #define RWF_HIPRI                      0x00000001 /* high priority request, poll if possible */
> +#define RWF_DSYNC                      0x00000002 /* per-IO O_DSYNC */
> +#define RWF_SYNC                       0x00000004 /* per-IO O_SYNC */
>
>  #endif /* _UAPI_LINUX_FS_H */
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
