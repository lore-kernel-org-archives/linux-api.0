From: David Howells <dhowells@redhat.com>
Subject: Re: User-visible context-mount API
Date: Tue, 16 Jan 2018 10:10:12 +0000
Message-ID: <22576.1516097412@warthog.procyon.org.uk>
References: <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com> <28167.1516032442@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
Content-ID: <22575.1516097412.1@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: dhowells@redhat.com, viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>, "Eric W. Biederman" <ebiederm@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> wrote:

> >  (6) Adjust a mountpoint's topology flags:
> >
> >         mount_set_topology(int dfd, const char *path,
> >                            unsigned int topology_flags);
> >
> >  (7) Reconfigure a mountpoint:
> >
> >         mount_reconfigure(int dfd, const char *path,
> >                           unsigned int mount_flags);
> 
> 
> What's the fundamental  difference between topology flags and other
> flags?  Why two syscalls?

Inside the kernel the MS_* flags appear to belong to a number of fundamentally
different classes:

 (1) Things like MS_SILENT and MS_REMOUNT which affect the behaviour of the
     mount process, but aren't persistent beyond that.

 (2) Inter-namespace topology management, controlling how mounts are shared
     and duplicated between namespaces.

 (3) Restrictions on accesses through a particular mountpoint, eg. MS_NODEV,
     MS_NOEXEC.

 (4) Instructions to a filesystem on how a superblock is to behave.

I think the classes are fundamentally different - and we've already separated
(4) from the others inside the kernel.  However, I've no great objection to
keeping (2) and (3) together in the same mask.  It just sounds cleaner to
separate them.  Do we foresee adding any extra flags to these classes?

> Also I think we need a "mask" argument telling the kernel which flags
> need to be changed.

Sounds reasonable.

> >  (8) Change R/O protection on a mountpoint:
> >
> >         mount_protect(int dfd, const char *path,
> >                       bool read_only);
> >
> >      This involves changing the R/O protection on the superblock also, but
> >      might be mergeable with mount_reconfigure().
> 
> Methinks this should be merged with mount_reconfigure(), and if
> superblock state needs to be changed, than that should be done with
> the "remount" procedure below.

Maybe - the problem is that it's harder to manage if you've got multiple
mounts attached to a single superblock as you can only change the superblock
state if all the mounts are R/O.

> >         write(mfd, "o bind=1"); // Set MS_BIND
> 
> What does MS_BIND mean here?

Sorry, bad example; MS_BIND wouldn't be allowed there.  Consider the following
instead:

     write(mfd, "o nodev=1"); // Set 'MS_NODEV'

> >         write(mfd, "o nosuid=1"); // Set MS_NOSUID
> >
> >         mount_create(mfd, AT_FDCWD, "/mnt/a", sbfd);
> 
> Yeah, more flexible, but also more complicated, with mount_create()
> now taking 3 file descriptors, ugh...

Yeah, I know:-/ ... but there are more parameters that I can foresee adding
(such as [ug]id mapping tables), and a syscall just doesn't have enough
argument space.  Also, I think that we need to set all the parameters on a
mountpoint at the time of creation and that doing this retroactively isn't a
good idea, since it's live as soon as it's created.

David
