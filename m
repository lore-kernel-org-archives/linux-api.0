From: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Tue, 16 Jan 2018 10:01:25 +0100
Message-ID: <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
References: <28167.1516032442@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <28167.1516032442-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Adding linux-api@vger]

On Mon, Jan 15, 2018 at 5:07 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I've been looking at the context-mount API visible to userspace as I need to
> adjust the security ops to handle it.  I'm thinking I probably need something
> like the following system calls.  Note that:
>
>  topology_flags are MS_PRIVATE, MS_SLAVE, MS_SHARED, MS_UNBINDABLE.
>
>  mount_flags are things like MS_NOSUID, MS_NODEV, MS_NOEXEC that get
>  translated to MNT_* flags in the kernel.
>
>  (1) Open a filesystem and create a blank context from it:
>
>         fd = fsopen(const char *fs_name, unsigned int flags, ...);
>
>      where flags includes FSOPEN_CLOEXEC, FSOPEN_CREATE_ONLY (don't reuse
>      superblock).
>
>  (2) Access and change the context:
>
>         write(fd, "<command>", ...);
>         read(fd, ...);
>         ioctl(fd, ...);
>
>  (3) Create and set up a context for an existing mountpoint:
>
>         fd = fspick(int dfd, const char *path, unsigned int flags);
>
>      where flags includes FSPICK_CLOEXEC.
>
>  (4) Create a mountpoint on a path, using a context to supply the superblock
>      details:
>
>         mount_create(int fd, int dfd, const char *path,
>                      unsigned int topology_flags,
>                      unsigned int mount_flags);
>
>  (5) Move a mount:
>
>         mount_move(int from_dfd, const char *frompath,
>                    int to_dfd, const char *topath);
>
>      This might want to take new topology flags algo.
>
>  (6) Adjust a mountpoint's topology flags:
>
>         mount_set_topology(int dfd, const char *path,
>                            unsigned int topology_flags);
>
>  (7) Reconfigure a mountpoint:
>
>         mount_reconfigure(int dfd, const char *path,
>                           unsigned int mount_flags);


What's the fundamental  difference between topology flags and other
flags?  Why two syscalls?

Also I think we need a "mask" argument telling the kernel which flags
need to be changed.

>
>  (8) Change R/O protection on a mountpoint:
>
>         mount_protect(int dfd, const char *path,
>                       bool read_only);
>
>      This involves changing the R/O protection on the superblock also, but
>      might be mergeable with mount_reconfigure().

Methinks this should be merged with mount_reconfigure(), and if
superblock state needs to be changed, than that should be done with
the "remount" procedure below.


> Note that two things are missing from the list:
>
>  (1) Bind mount.  This is done by:
>
>         fd = fspick("/mnt/a");
>         mount_create(fd, ..., "/mnt/b", ...);
>         mount_create(fd, ..., "/mnt/c", ...);
>         mount_create(fd, ..., "/mnt/d", ...);
>
>  (2) Remount.  Superblock reconfiguration is done by something like:
>
>         fd = fspick("/mnt/a");
>         write(fd, "? fs");
>         read(fd, filesystem_type);
>         write(fd, "o user_xattr"); // Indicate changes to be made
>         write(fd, "x reconfigure"); // Perform the reconfiguration
>
> Thinking further on this, maybe I should make a mountpoint-context also, so
> that it can be loaded up with target namespace information and other goodies.
> This would vastly expand the parameter space for a mountpoint beyond the few
> syscall args available.  Creating a new mount might then look like:
>
>         sbfd = fsopen("ext4");
>         write(sbfd, "d /dev/sda1");
>         write(sbfd, "o user_xattr");
>         write(sbfd, "x commit");
>
>         mfd = mount_new();
>         write(mfd, "ns mnt 123"); // where fd 123 refers to a mount namesapce
>         write(mfd, "o bind=1"); // Set MS_BIND

What does MS_BIND mean here?

>         write(mfd, "o nosuid=1"); // Set MS_NOSUID
>
>         mount_create(mfd, AT_FDCWD, "/mnt/a", sbfd);

Yeah, more flexible, but also more complicated, with mount_create()
now taking 3 file descriptors, ugh...

Thanks,
Miklos
