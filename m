From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 00/25] VFS: Introduce filesystem information query
 syscall [ver #14]
Date: Wed, 26 Jun 2019 12:47:05 +0200
Message-ID: <20190626104704.dwjd4urpsmuheirc@brauner.io>
References: <156138532485.25627.7459410522109581052.stgit@warthog.procyon.org.uk>
 <20190626100525.irdehd24jowz5f75@brauner.io>
 <cf0361c2d1fc09ad0097f0da1e981b97ad39ab07.camel@themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf0361c2d1fc09ad0097f0da1e981b97ad39ab07.camel@themaw.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Cc: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 26, 2019 at 06:42:51PM +0800, Ian Kent wrote:
> On Wed, 2019-06-26 at 12:05 +0200, Christian Brauner wrote:
> > On Mon, Jun 24, 2019 at 03:08:45PM +0100, David Howells wrote:
> > > Hi Al,
> > > 
> > > Here are a set of patches that adds a syscall, fsinfo(), that allows
> > > attributes of a filesystem/superblock to be queried.  Attribute values are
> > > of four basic types:
> > > 
> > >  (1) Version dependent-length structure (size defined by type).
> > > 
> > >  (2) Variable-length string (up to PAGE_SIZE).
> > > 
> > >  (3) Array of fixed-length structures (up to INT_MAX size).
> > > 
> > >  (4) Opaque blob (up to INT_MAX size).
> > > 
> > > Attributes can have multiple values in up to two dimensions and all the
> > > values of a particular attribute must have the same type.
> > > 
> > > Note that the attribute values *are* allowed to vary between dentries
> > > within a single superblock, depending on the specific dentry that you're
> > > looking at.
> > > 
> > > I've tried to make the interface as light as possible, so integer/enum
> > > attribute selector rather than string and the core does all the allocation
> > > and extensibility support work rather than leaving that to the filesystems.
> > > That means that for the first two attribute types, sb->s_op->fsinfo() may
> > > assume that the provided buffer is always present and always big enough.
> > > 
> > > Further, this removes the possibility of the filesystem gaining access to
> > > the
> > > userspace buffer.
> > > 
> > > 
> > > fsinfo() allows a variety of information to be retrieved about a filesystem
> > > and the mount topology:
> > > 
> > >  (1) General superblock attributes:
> > > 
> > >       - The amount of space/free space in a filesystem (as statfs()).
> > >       - Filesystem identifiers (UUID, volume label, device numbers, ...)
> > >       - The limits on a filesystem's capabilities
> > >       - Information on supported statx fields and attributes and IOC flags.
> > >       - A variety single-bit flags indicating supported capabilities.
> > >       - Timestamp resolution and range.
> > >       - Sources (as per mount(2), but fsconfig() allows multiple sources).
> > >       - In-filesystem filename format information.
> > >       - Filesystem parameters ("mount -o xxx"-type things).
> > >       - LSM parameters (again "mount -o xxx"-type things).
> > > 
> > >  (2) Filesystem-specific superblock attributes:
> > > 
> > >       - Server names and addresses.
> > >       - Cell name.
> > > 
> > >  (3) Filesystem configuration metadata attributes:
> > > 
> > >       - Filesystem parameter type descriptions.
> > >       - Name -> parameter mappings.
> > >       - Simple enumeration name -> value mappings.
> > > 
> > >  (4) Mount topology:
> > > 
> > >       - General information about a mount object.
> > >       - Mount device name(s).
> > >       - Children of a mount object and their relative paths.
> > > 
> > >  (5) Information about what the fsinfo() syscall itself supports, including
> > >      the number of attibutes supported and the number of capability bits
> > >      supported.
> > 
> > Phew, this patchset is a lot. It's good of course but can we please cut
> > some of the more advanced features such as querying by mount id,
> > submounts etc. pp. for now?
> 
> Did you mean the "vfs: Allow fsinfo() to look up a mount object by ID"
> patch?
> 
> We would need to be very careful what was dropped.

Not dropped as in never implement but rather defer it by one merge
window to give us a) more time to review and settle the interface while
b) not stalling the overall patch.

> 
> For example, I've found that the patch above is pretty much essential
> for fsinfo() to be useful from user space.

Yeah, but that interface is not clearly defined yet as can be seen from
the commit message and that's what's bothering me most.
