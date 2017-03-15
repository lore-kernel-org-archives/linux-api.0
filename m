From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/2] fanotify: new event FAN_MODIFY_DIR
Date: Wed, 15 Mar 2017 05:52:26 +0100
Message-ID: <CAHO5Pa0hgPqnPby7YDrZn61q9W7wib92MoXY_mMbFaahtr63RA@mail.gmail.com>
References: <a0fa4e7890ea16e7f90a17524e817755f7dde8b5.1489445257.git.p@regnarg.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a0fa4e7890ea16e7f90a17524e817755f7dde8b5.1489445257.git.p-7SWK6AguE3TrBKCeMvbIDA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?RmlsaXAgxaB0xJtkcm9uc2vDvQ==?= <r.lklm-7SWK6AguE3TrBKCeMvbIDA@public.gmane.org>
Cc: Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC +=3D linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

Filip,

Since this is a kernel-user-space API change, please CC linux-api@
(and on future iterations of this patch). The kernel source file
Documentation/SubmitChecklist notes that all Linux kernel patches that
change userspace interfaces should be CCed to
linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that the various parties who are
interested in API changes are informed. For further information, see
https://www.kernel.org/doc/man-pages/linux-api-ml.html

Thanks,

Michael



On Tue, Mar 14, 2017 at 12:02 AM, Filip =C5=A0t=C4=9Bdronsk=C3=BD <r.lklm@r=
egnarg.cz> wrote:
> Fanotify currently does not report directory modification events
> (rename, unlink, etc.). But these events are essential for about half of
> concievable fanotify use cases, especially:
>
>   - file system indexers / desktop search tools
>   - file synchronization tools (like Dropbox, Nextcloud, etc.),
>     online backup tools
>
> and pretty much any app that needs to maintain and up-to-date internal
> representation of current contents of the file system.
>
> All applications of the above classes that I'm aware of currently use
> recursive inotify watches, which do not scale (my home dir has ~200k
> directories, creating all the watches takes ~2min and eats several tens
> of MB of kernel memory).
>
> There have been many calls for such a feature, pretty much since the
> creation of fanotify in 2009:
>   * By GNOME developers:
>     https://wiki.gnome.org/BastienNocera/KernelWishlist#VFS.2C_filesystem=
s
>   * By KDE developers:
>     http://lkml.kernel.org/r/201211011352.42476.Martin%40lichtvoll.de
>     'Better support for (desktop) file search / indexing applications'
>   * And others:
>     http://lkml.kernel.org/r/AANLkTi=3DowK=3DWZW4oNtpm5WpAZhqCQUdTR2K5gzJ=
_MqZ+%40mail.gmail.com
>     'Fanotify mv/rename?'
>     http://lkml.kernel.org/r/1238158043.23703.20.camel%40fatty
>     'Issues with using fanotify for a filesystem indexer'
>
> Add a new fanotify event, FAN_MODIFY_DIR, that is emitted whenever the
> contents of a directory change (a directory entry is added, removed or
> renamed). This covers all the currently missing events: rename, unlink,
> mknod, mkdir, rmdir, etc.
>
> Included with the event is a file descriptor to the modified directory
> but no further info. The userspace application is expected to rescan the
> whole directory and update its model accordingly. This needs to be done
> carefully to prevent race conditions. A cross-directory rename generates
> two FAN_MODIFY_DIR events.
>
> This minimalistic approach has several advantages:
>   * Does not require changes to the fanotify userspace API or the
>     fsnotify in-kernel framework, apart from adding a new event.
>     Especially doesn't complicate it by adding string fields.
>   * Has simple and clear semantics, even with multiple renames occurring
>     in parallel etc. In case of any inconsistencies, one can simply wait
>     for a while and rescan again.
>   * FAN_MODIFY_DIR events are easily merged in case of multiple
>     operations on a directory (e.g. deleting all files).
>
> Signed-off-by: Filip =C5=A0t=C4=9Bdronsk=C3=BD <r.lkml-7SWK6AguE3TrBKCeMvbIDA@public.gmane.org>
>
> ---
>
> An alternative might be to create wrapper functions like
> vfs_path_(rename|unlink|...). They could also take care of calling
> security_path_(rename|unlink|...), which is currently also up to
> the indvidual callers (possibly with a flag because it might not
> be always desired).
>
> An alternative was proposed by Amir Goldstein in several long series of
> patches that add superblock-scoped (as opposed to vfsmount-scoped)
> fanotify watches and specific dentry manipulation events with filenames:
>
>     http://lkml.kernel.org/r/1481984434-13293-1-git-send-email-amir73il%4=
0gmail.com
>     http://lkml.kernel.org/r/1482247207-4424-1-git-send-email-amir73il%40=
gmail.com
>     http://lkml.kernel.org/r/1476126784-12520-1-git-send-email-amir73il%4=
0gmail.com
>     http://lkml.kernel.org/r/1489411223-12081-1-git-send-email-amir73il%4=
0gmail.com
>
> There is large but not complete overlap between that proposal and
> mine (which is was originally created over a year ago, before Amir's
> work, but never posted).
>
> I think the superblock watch idea is very interesting because it might
> in the future allow reporing fsnotify events from remote and virtual
> filesystems. So I'm posting this more as a potential source of more
> ideas for discussion, or a fallback proposal in case Amir's patches
> don't make it.
> ---
>  fs/notify/fanotify/fanotify.c    |  1 +
>  include/linux/fsnotify.h         | 17 +++++++++++++++++
>  include/linux/fsnotify_backend.h |  1 +
>  include/uapi/linux/fanotify.h    |  5 ++++-
>  4 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.=
c
> index bbc175d4213d..5178b06c338c 100644
> --- a/fs/notify/fanotify/fanotify.c
> +++ b/fs/notify/fanotify/fanotify.c
> @@ -186,6 +186,7 @@ static int fanotify_handle_event(struct fsnotify_grou=
p *group,
>
>         BUILD_BUG_ON(FAN_ACCESS !=3D FS_ACCESS);
>         BUILD_BUG_ON(FAN_MODIFY !=3D FS_MODIFY);
> +       BUILD_BUG_ON(FAN_MODIFY_DIR !=3D FS_MODIFY_DIR);
>         BUILD_BUG_ON(FAN_CLOSE_NOWRITE !=3D FS_CLOSE_NOWRITE);
>         BUILD_BUG_ON(FAN_CLOSE_WRITE !=3D FS_CLOSE_WRITE);
>         BUILD_BUG_ON(FAN_OPEN !=3D FS_OPEN);
> diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
> index b43d3f5bd9ea..00fb87c975d6 100644
> --- a/include/linux/fsnotify.h
> +++ b/include/linux/fsnotify.h
> @@ -208,6 +208,23 @@ static inline void fsnotify_modify(struct file *file=
)
>  }
>
>  /*
> + * fsnotify_modifydir - directory contents were changed
> + * (as a result of rename, creat, unlink, etc.)
> + */
> +static inline void fsnotify_modify_dir(struct path *path)
> +{
> +       struct inode *inode =3D path->dentry->d_inode;
> +       __u32 mask =3D FS_MODIFY_DIR;
> +
> +       if (S_ISDIR(inode->i_mode))
> +               mask |=3D FS_ISDIR;
> +       else
> +               return;
> +
> +       fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
> +}
> +
> +/*
>   * fsnotify_open - file was opened
>   */
>  static inline void fsnotify_open(struct file *file)
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_ba=
ckend.h
> index 487246546ebe..7751b337ec31 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -42,6 +42,7 @@
>
>  #define FS_OPEN_PERM           0x00010000      /* open event in an permi=
ssion hook */
>  #define FS_ACCESS_PERM         0x00020000      /* access event in a perm=
issions hook */
> +#define FS_MODIFY_DIR          0x00040000      /* directory changed (ren=
ame/unlink/...) */
>
>  #define FS_EXCL_UNLINK         0x04000000      /* do not send events if =
object is unlinked */
>  #define FS_ISDIR               0x40000000      /* event occurred against=
 dir */
> diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.=
h
> index 030508d195d3..f14e048d492a 100644
> --- a/include/uapi/linux/fanotify.h
> +++ b/include/uapi/linux/fanotify.h
> @@ -15,6 +15,8 @@
>  #define FAN_OPEN_PERM          0x00010000      /* File open in perm chec=
k */
>  #define FAN_ACCESS_PERM                0x00020000      /* File accessed =
in perm check */
>
> +#define FAN_MODIFY_DIR         0x00040000      /* directory changed (ren=
ame/unlink/...) */
> +
>  #define FAN_ONDIR              0x40000000      /* event occurred against=
 dir */
>
>  #define FAN_EVENT_ON_CHILD     0x08000000      /* interested in child ev=
ents */
> @@ -67,7 +69,8 @@
>  #define FAN_ALL_EVENTS (FAN_ACCESS |\
>                         FAN_MODIFY |\
>                         FAN_CLOSE |\
> -                       FAN_OPEN)
> +                       FAN_OPEN |\
> +                       FAN_MODIFY_DIR)
>
>  /*
>   * All events which require a permission response from userspace
> --
> 2.11.1
>



--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
