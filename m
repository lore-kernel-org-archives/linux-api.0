From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] statxat: Provide IOC flags for Windows fs attributes
Date: Tue, 12 Nov 2013 12:06:15 -0600
Message-ID: <CAH2r5ms3p4wNwGyDYF6sr=_iwG1dqAD=SaciSYdEUBuM129Zgg@mail.gmail.com>
References: <20131112173518.25813.67568.stgit@warthog.procyon.org.uk>
	<20131112173526.25813.85546.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131112173526.25813.85546.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, andreas.gruenbacher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I was experimenting with these flags when adding the per-file
compression support for cifs and smb2/smb3, and noticed that it would
be helpful to be able to display the FILE_ATTRIBUTE_ENCRYPTED flag
here too on get (ie to show that the file is encrypted at rest on the
server).   I am unsure whether displaying the "FILE_ATTRIBUTE_SPARSE"
is useful or not here but that is another obvious one.

And the other obvious flag to display would be
"FILE_ATTRIBUTE_INTEGRITY_STREAM" or equivalent (to indicate that this
file is protected by data and metadata checksums, perhaps btrfs and
other local file systems may even eventually allow you to configure
additional extra data/metadata integrity checks someday as well, not
just SMB3).

On Tue, Nov 12, 2013 at 11:35 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Provide IOC flags for Windows fs attributes so that they can be retrieved (or
> even altered) using the FS_IOC_[GS]ETFLAGS ioctl and read using statxat().
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
>  include/uapi/linux/fs.h |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 6c28b61bb690..8b966f48dd41 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -191,10 +191,13 @@ struct inodes_stat_t {
>  #define FS_EXTENT_FL                   0x00080000 /* Extents */
>  #define FS_DIRECTIO_FL                 0x00100000 /* Use direct i/o */
>  #define FS_NOCOW_FL                    0x00800000 /* Do not cow file */
> +#define FS_HIDDEN_FL                   0x10000000 /* Windows hidden file attribute */
> +#define FS_SYSTEM_FL                   0x20000000 /* Windows system file attribute */
> +#define FS_ARCHIVE_FL                  0x40000000 /* Windows archive file attribute */
>  #define FS_RESERVED_FL                 0x80000000 /* reserved for ext2 lib */
>
> -#define FS_FL_USER_VISIBLE             0x0003DFFF /* User visible flags */
> -#define FS_FL_USER_MODIFIABLE          0x000380FF /* User modifiable flags */
> +#define FS_FL_USER_VISIBLE             0x7003DFFF /* User visible flags */
> +#define FS_FL_USER_MODIFIABLE          0x700380FF /* User modifiable flags */
>
>
>  #define SYNC_FILE_RANGE_WAIT_BEFORE    1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
