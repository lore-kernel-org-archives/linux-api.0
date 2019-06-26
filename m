From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 00/25] VFS: Introduce filesystem information query
 syscall [ver #14]
Date: Wed, 26 Jun 2019 12:05:26 +0200
Message-ID: <20190626100525.irdehd24jowz5f75@brauner.io>
References: <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 24, 2019 at 03:08:45PM +0100, David Howells wrote:
> 
> Hi Al,
> 
> Here are a set of patches that adds a syscall, fsinfo(), that allows
> attributes of a filesystem/superblock to be queried.  Attribute values are
> of four basic types:
> 
>  (1) Version dependent-length structure (size defined by type).
> 
>  (2) Variable-length string (up to PAGE_SIZE).
> 
>  (3) Array of fixed-length structures (up to INT_MAX size).
> 
>  (4) Opaque blob (up to INT_MAX size).
> 
> Attributes can have multiple values in up to two dimensions and all the
> values of a particular attribute must have the same type.
> 
> Note that the attribute values *are* allowed to vary between dentries
> within a single superblock, depending on the specific dentry that you're
> looking at.
> 
> I've tried to make the interface as light as possible, so integer/enum
> attribute selector rather than string and the core does all the allocation
> and extensibility support work rather than leaving that to the filesystems.
> That means that for the first two attribute types, sb->s_op->fsinfo() may
> assume that the provided buffer is always present and always big enough.
> 
> Further, this removes the possibility of the filesystem gaining access to the
> userspace buffer.
> 
> 
> fsinfo() allows a variety of information to be retrieved about a filesystem
> and the mount topology:
> 
>  (1) General superblock attributes:
> 
>       - The amount of space/free space in a filesystem (as statfs()).
>       - Filesystem identifiers (UUID, volume label, device numbers, ...)
>       - The limits on a filesystem's capabilities
>       - Information on supported statx fields and attributes and IOC flags.
>       - A variety single-bit flags indicating supported capabilities.
>       - Timestamp resolution and range.
>       - Sources (as per mount(2), but fsconfig() allows multiple sources).
>       - In-filesystem filename format information.
>       - Filesystem parameters ("mount -o xxx"-type things).
>       - LSM parameters (again "mount -o xxx"-type things).
> 
>  (2) Filesystem-specific superblock attributes:
> 
>       - Server names and addresses.
>       - Cell name.
> 
>  (3) Filesystem configuration metadata attributes:
> 
>       - Filesystem parameter type descriptions.
>       - Name -> parameter mappings.
>       - Simple enumeration name -> value mappings.
> 
>  (4) Mount topology:
> 
>       - General information about a mount object.
>       - Mount device name(s).
>       - Children of a mount object and their relative paths.
> 
>  (5) Information about what the fsinfo() syscall itself supports, including
>      the number of attibutes supported and the number of capability bits
>      supported.

Phew, this patchset is a lot. It's good of course but can we please cut
some of the more advanced features such as querying by mount id,
submounts etc. pp. for now?
I feel this would help with review and since your interface is
extensible it's really not a big deal if we defer fancy features to
later cycles after people had more time to review and the interface has
seen some exposure.

The mount api changes over the last months have honestly been so huge
that any chance to make the changes smaller and easier to digest we
should take. (I'm really not complaining. Good that the work is done and
it's entirely ok that it's a lot of code.)

It would also be great if after you have dropped some stuff from this
patchset and gotten an Ack we could stuff it into linux-next for some
time because it hasn't been so far...

Christian
