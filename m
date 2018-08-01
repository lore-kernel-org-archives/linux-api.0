From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem information [ver #10]
Date: Wed, 01 Aug 2018 02:07:10 +0100
Message-ID: <5131.1533085630@warthog.procyon.org.uk>
References: <20180731234909.GA4206@magnolia> <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk> <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180731234909.GA4206@magnolia>
Content-ID: <5130.1533085630.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> <snip> I only have time today to review the user interface bits...

Thanks:-)

> > +	fsinfo_attr_volume_id		= 7,	/* Volume ID (string) */
> > +	fsinfo_attr_volume_uuid		= 8,	/* Volume UUID (LE uuid) */
> > +	fsinfo_attr_volume_name		= 9,	/* Volume name (string) */
> 
> What's the difference between a volume name and a volume string?

Um?  There is no "volume string" defined.

What the parenthesis in the comment means is that fsinfo_attr_volume_name
returns a variable-length string rather than a fixed structure - ie. it's type
information.

> XFS has a uuid and a label that can be set by userspace (sort of);
> should we return the label for volume_id and volume_name?
> 
> Hmmm, I see that the default implementations set volume_id from s_id,
> and s_id (for block device filesystems anyway) tends to be the device, I
> guess?
> 
> So if blkid told me that:
> /dev/sda1: LABEL="music" UUID="8d9e5b1e-a094-49e5-a179-6d94f7fd8399" TYPE="xfs"
> 
> volume_id == sda1, volume_uuid == 8d9e5b1e-a094-49e5-a179-6d94f7fd8399,
> and volume_name == "music" ?

I would do it like that.  Note that these things are described in the manual
page that I posted previously.  I'll attach that here (note that it needs
updating).

> > +	fsinfo_attr_source		= 16,	/* Nth mount source name (string) */
> 
> Hmm, so I guess external log devices and realtime device(s) go here?

Ummm...  Not sure.  I feel like they should, but they can also go in
FSINFO_ATTR_PARAMETER if they're already described by a mount parameter.

I was thinking more of bcachefs where the "source" parameter to mount(2) looks
something like "/dev/sda1:/dev/sda2".

One of the important considerations for setting up the parser is that we still
have to handle mount(2) for existing filesystems.

> Are we tied to this enum forever, or do you plan to split up the number
> space to allow filesystems to define their own attributes without having
> to add them here?
> 
> For example, say you let the upper 8 bits be some sort of per-fs code
> (like how _IO{,R,W} work) and the lower 24 bits can be the subcommand.
> 0x00 would be the generic space; XFS could (say) reserve 0x58000000 -
> 0x58ffffff for XFS (0x58 is the prefix code used for xfs ioctls).  If
> there ever are subdivisions of the number space it might be nice to have
> fsinfo_fsinfo return prefix number of the fs-specific subcommands, and
> how many fs-specific subcommands there are.
> 
> I mean, I guess each fs' ->fsinfo function can do that privately but I
> suggest having some mechanism in mind to handle these things.  XFS's
> geometry ioctl structure is nearly out of space and (some day soon) we
> will have to expand and maybe we can use fsinfo instead.

I was planning on requiring them to be added here and also listed in:

	static const u16 fsinfo_buffer_sizes[FSINFO_ATTR__NR] = {
		FSINFO_STRUCT		(STATFS,		statfs),
		FSINFO_STRUCT		(FSINFO,		fsinfo),
		...
	};

in fs/statfs.c.

> > +	__u32	f_dev_minor;
> > +};
> 
> This structure doesn't end on a 64-bit boundary and may cause padding
> problems...

I've fixed that, thanks.

> Maximum inode number possible, for filesystems that can allocate inodes
> dynamically?
> 
> Granted, XFS will probably only ever advertise "0xffffffffffffffff"...

Is that possible with any of our current interfaces?

It's something I can add, but I can imagine circumstances where the inode
number space has holes in it that can't be allocated (say inode numbers
correspond to particular blocks on disk).  I wonder if that's something I need
worry about.

Btw, note that the fsinfo() interface is constructed such that it's practical
to expand any particular struct in the future, provided any new fields are
tagged on the end and don't mind defaulting to 0.  fsinfo() returns just the
data you asked for, truncating the returned data to fit your request.  If you
ask for more than it has, then it clears the excess space (hence the
defaulting to 0 condition above).

> > +struct fsinfo_io_size {
> > +	__u32		dio_size_gran;	/* Size granularity for O_DIRECT */
> > +	__u32		dio_mem_align;	/* Memory alignment for O_DIRECT */
> 
> max io size too?

That needs more discussion, I think, particularly involving Dave Chinner.

> 64-bit too, in case we ever get that insane?

If you really want.  4GiB alignment and granularity is a bit insane, though.

David
---
'\" t
.\" Copyright (c) 2018 David Howells <dhowells@redhat.com>
.\"
.\" %%%LICENSE_START(VERBATIM)
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\" %%%LICENSE_END
.\"
.TH FSINFO 2 2018-06-06 "Linux" "Linux Programmer's Manual"
.SH NAME
fsinfo \- Get filesystem information
.SH SYNOPSIS
.nf
.B #include <sys/types.h>
.br
.B #include <sys/fsinfo.h>
.br
.B #include <unistd.h>
.br
.BR "#include <fcntl.h>           " "/* Definition of AT_* constants */"
.PP
.BI "int fsinfo(int " dirfd ", const char *" pathname ","
.BI "           struct fsinfo_params *" params ","
.BI "           void *" buffer ", size_t " buf_size );
.fi
.PP
.IR Note :
There is no glibc wrapper for
.BR fsinfo ();
see NOTES.
.SH DESCRIPTION
.PP
fsinfo() retrieves the desired filesystem attribute, as selected by the
parameters pointed to by
.IR params ,
and stores its value in the buffer pointed to by
.IR buffer .
.PP
The parameter structure is optional, defaulting to all the parameters being 0
if the pointer is NULL.  The structure looks like the following:
.PP
.in +4n
.nf
struct fsinfo_params {
    __u32 at_flags;     /* AT_SYMLINK_NOFOLLOW and similar flags */
    __u32 request;      /* Requested attribute */
    __u32 Nth;          /* Instance of attribute */
    __u32 Mth;          /* Subinstance of Nth instance */
    __u32 __reserved[6]; /* Reserved params; all must be 0 */
};
.fi
.in
.PP
The filesystem to be queried is looked up using a combination of
.IR dfd ", " pathname " and " params->at_flags.
This is discussed in more detail below.
.PP
The desired attribute is indicated by
.IR params->request .
If
.I params
is NULL, this will default to
.BR fsinfo_attr_statfs ,
which retrieves some of the information returned by
.BR statfs ().
The available attributes are described below in the "THE ATTRIBUTES" section.
.PP
Some attributes can have multiple values and some can even have multiple
instances with multiple values.  For example, a network filesystem might use
multiple servers.  The names of each of these servers can be retrieved by
using
.I params->Nth
to iterate through all the instances until error
.B ENODATA
occurs, indicating the end of the list.  Further, each server might have
multiple addresses available; these can be enumerated using
.I params->Nth
to iterate the servers and
.I params->Mth
to iterate the addresses of the Nth server.
.PP
The amount of data written into the buffer depends on the attribute selected.
Some attributes return variable-length strings and some return fixed-size
structures.  If either
.IR buffer " is  NULL  or " buf_size " is 0"
then the size of the attribute value will be returned and nothing will be
written into the buffer.
.PP
The
.I params->__reserved
parameters must all be 0.
.\"_______________________________________________________
.SS
Allowance for Future Attribute Expansion
.PP
To allow for the future expansion and addition of fields to any fixed-size
structure attribute,
.BR fsinfo ()
makes the following guarantees:
.RS 4m
.IP (1) 4m
It will always clear any excess space in the buffer.
.IP (2) 4m
It will always return the actual size of the data.
.IP (3) 4m
It will truncate the data to fit it into the buffer rather than giving an
error.
.IP (4) 4m
Any new version of a structure will incorporate all the fields from the old
version at same offsets.
.RE
.PP
So, for example, if the caller is running on an older version of the kernel
with an older, smaller version of the structure than was asked for, the kernel
will write the smaller version into the buffer and will clear the remainder of
the buffer to make sure any additional fields are set to 0.  The function will
return the actual size of the data.
.PP
On the other hand, if the caller is running on a newer version of the kernel
with a newer version of the structure that is larger than the buffer, the write
to the buffer will be truncated to fit as necessary and the actual size of the
data will be returned.
.PP
Note that this doesn't apply to variable-length string attributes.

.\"_______________________________________________________
.SS
Invoking \fBfsinfo\fR():
.PP
To access a file's status, no permissions are required on the file itself, but
in the case of
.BR fsinfo ()
with a path, execute (search) permission is required on all of the directories
in
.I pathname
that lead to the file.
.PP
.BR fsinfo ()
uses
.IR pathname ", " dirfd " and " params->at_flags
to locate the target file in one of a variety of ways:
.TP
[*] By absolute path.
.I pathname
points to an absolute path and
.I dirfd
is ignored.  The file is looked up by name, starting from the root of the
filesystem as seen by the calling process.
.TP
[*] By cwd-relative path.
.I pathname
points to a relative path and
.IR dirfd " is " AT_FDCWD .
The file is looked up by name, starting from the current working directory.
.TP
[*] By dir-relative path.
.I pathname
points to relative path and
.I dirfd
indicates a file descriptor pointing to a directory.  The file is looked up by
name, starting from the directory specified by
.IR dirfd .
.TP
[*] By file descriptor.
.IR pathname " is " NULL " and " dirfd
indicates a file descriptor.  The file attached to the file descriptor is
queried directly.  The file descriptor may point to any type of file, not just
a directory.
.PP
.I flags
can be used to influence a path-based lookup.  A value for
.I flags
is constructed by OR'ing together zero or more of the following constants:
.TP
.BR AT_EMPTY_PATH
.\" commit 65cfc6722361570bfe255698d9cd4dccaf47570d
If
.I pathname
is an empty string, operate on the file referred to by
.IR dirfd
(which may have been obtained using the
.BR open (2)
.B O_PATH
flag).
If
.I dirfd
is
.BR AT_FDCWD ,
the call operates on the current working directory.
In this case,
.I dirfd
can refer to any type of file, not just a directory.
This flag is Linux-specific; define
.B _GNU_SOURCE
.\" Before glibc 2.16, defining _ATFILE_SOURCE sufficed
to obtain its definition.
.TP
.BR AT_NO_AUTOMOUNT
Don't automount the terminal ("basename") component of
.I pathname
if it is a directory that is an automount point.  This allows the caller to
gather attributes of the filesystem holding an automount point (rather than
the filesystem it would mount).  This flag can be used in tools that scan
directories to prevent mass-automounting of a directory of automount points.
The
.B AT_NO_AUTOMOUNT
flag has no effect if the mount point has already been mounted over.
This flag is Linux-specific; define
.B _GNU_SOURCE
.\" Before glibc 2.16, defining _ATFILE_SOURCE sufficed
to obtain its definition.
.TP
.B AT_SYMLINK_NOFOLLOW
If
.I pathname
is a symbolic link, do not dereference it:
instead return information about the link itself, like
.BR lstat ().
.SH THE ATTRIBUTES
.PP
There is a range of attributes that can be selected from.  These are:

.\" __________________ fsinfo_attr_statfs __________________
.TP
.B fsinfo_attr_statfs
This retrieves the "dynamic"
.B statfs
information, such as block and file counts, that are expected to change whilst
a filesystem is being used.  This fills in the following structure:
.PP
.RS
.in +4n
.nf
struct fsinfo_statfs {
    __u64 f_blocks;	/* Total number of blocks in fs */
    __u64 f_bfree;	/* Total number of free blocks */
    __u64 f_bavail;	/* Number of free blocks available to ordinary user */
    __u64 f_files;	/* Total number of file nodes in fs */
    __u64 f_ffree;	/* Number of free file nodes */
    __u64 f_favail;	/* Number of free file nodes available to ordinary user */
    __u32 f_bsize;	/* Optimal block size */
    __u32 f_frsize;	/* Fragment size */
};
.fi
.in
.RE
.IP
The fields correspond to those of the same name returned by
.BR statfs ().

.\" __________________ fsinfo_attr_fsinfo __________________
.TP
.B fsinfo_attr_fsinfo
This retrieves information about the
.BR fsinfo ()
system call itself.  This fills in the following structure:
.PP
.RS
.in +4n
.nf
struct fsinfo_fsinfo {
    __u32 max_attr;
    __u32 max_cap;
};
.fi
.in
.RE
.IP
The
.I max_attr
value indicates the number of attributes supported by the
.BR fsinfo ()
system call, and
.I max_cap
indicates the number of capability bits supported by the
.B fsinfo_attr_capabilities
attribute.  The first corresponds to
.I fsinfo_attr__nr
and the second to
.I fsinfo_cap__nr
in the header file.

.\" __________________ fsinfo_attr_ids __________________
.TP
.B fsinfo_attr_ids
This retrieves a number of fixed IDs and other static information otherwise
available through
.BR statfs ().
The following structure is filled in:
.PP
.RS
.in +4n
.nf
struct fsinfo_ids {
    char  f_fs_name[15 + 1]; /* Filesystem name */
    __u64 f_flags;	/* Filesystem mount flags (MS_*) */
    __u64 f_fsid;	/* Short 64-bit Filesystem ID */
    __u64 f_sb_id;	/* Internal superblock ID */
    __u32 f_fstype;	/* Filesystem type from linux/magic.h */
    __u32 f_dev_major;	/* As st_dev_* from struct statx */
    __u32 f_dev_minor;
};
.fi
.in
.RE
.IP
Most of these are filled in as for
.BR statfs (),
with the addition of the filesystem's symbolic name in
.I f_fs_name
and an identifier for use in notifications in
.IR f_sb_id .

.\" __________________ fsinfo_attr_limits __________________
.TP
.B fsinfo_attr_limits
This retrieves information about the limits of what a filesystem can support.
The following structure is filled in:
.PP
.RS
.in +4n
.nf
struct fsinfo_limits {
    __u64 max_file_size;
    __u64 max_uid;
    __u64 max_gid;
    __u64 max_projid;
    __u32 max_dev_major;
    __u32 max_dev_minor;
    __u32 max_hard_links;
    __u32 max_xattr_body_len;
    __u16 max_xattr_name_len;
    __u16 max_filename_len;
    __u16 max_symlink_len;
    __u16 __reserved[1];
};
.fi
.in
.RE
.IP
These indicate the maximum supported sizes for a variety of filesystem objects,
including the file size, the extended attribute name length and body length,
the filename length and the symlink body length.
.IP
It also indicates the maximum representable values for a User ID, a Group ID,
a Project ID, a device major number and a device minor number.
.IP
And finally, it indicates the maximum number of hard links that can be made to
a file.
.IP
Note that some of these values may be zero if the underlying object or concept
is not supported by the filesystem or the medium.

.\" __________________ fsinfo_attr_supports __________________
.TP
.B fsinfo_attr_supports
This retrieves information about what bits a filesystem supports in various
masks.  The following structure is filled in:
.PP
.RS
.in +4n
.nf
struct fsinfo_supports {
    __u64 stx_attributes;
    __u32 stx_mask;
    __u32 ioc_flags;
    __u32 win_file_attrs;
    __u32 __reserved[1];
};
.fi
.in
.RE
.IP
The
.IR stx_attributes " and " stx_mask
fields indicate what bits in the struct statx fields of the matching names
are supported by the filesystem.
.IP
The
.I ioc_flags
field indicates what FS_*_FL flag bits as used through the FS_IOC_GET/SETFLAGS
ioctls are supported by the filesystem.
.IP
The
.I win_file_attrs
indicates what DOS/Windows file attributes a filesystem supports, if any.

.\" __________________ fsinfo_attr_capabilities __________________
.TP
.B fsinfo_attr_capabilities
This retrieves information about what features a filesystem supports as a
series of single bit indicators.  The following structure is filled in:
.PP
.RS
.in +4n
.nf
struct fsinfo_capabilities {
    __u8 capabilities[(fsinfo_cap__nr + 7) / 8];
};
.fi
.in
.RE
.IP
where the bit of interest can be found by:
.PP
.RS
.in +4n
.nf
	p->capabilities[bit / 8] & (1 << (bit % 8)))
.fi
.in
.RE
.IP
The bits are listed by
.I enum fsinfo_capability
and
.B fsinfo_cap__nr
is one more than the last capability bit listed in the header file.
.IP
Note that the number of capability bits actually supported by the kernel can be
found using the
.B fsinfo_attr_fsinfo
attribute.
.IP
The capability bits and their meanings are listed below in the "THE
CAPABILITIES" section.

.\" __________________ fsinfo_attr_timestamp_info __________________
.TP
.B fsinfo_attr_timestamp_info
This retrieves information about what timestamp resolution and scope is
supported by a filesystem for each of the file timestamps.  The following
structure is filled in:
.PP
.RS
.in +4n
.nf
struct fsinfo_timestamp_info {
	__s64 minimum_timestamp;
	__s64 maximum_timestamp;
	__u16 atime_gran_mantissa;
	__u16 btime_gran_mantissa;
	__u16 ctime_gran_mantissa;
	__u16 mtime_gran_mantissa;
	__s8  atime_gran_exponent;
	__s8  btime_gran_exponent;
	__s8  ctime_gran_exponent;
	__s8  mtime_gran_exponent;
	__u32 __reserved[1];
};
.fi
.in
.RE
.IP
where
.IR minimum_timestamp " and " maximum_timestamp
are the limits on the timestamps that the filesystem supports and
.IR *time_gran_mantissa " and " *time_gran_exponent
indicate the granularity of each timestamp in terms of seconds, using the
formula:
.PP
.RS
.in +4n
.nf
mantissa * pow(10, exponent) Seconds
.fi
.in
.RE
.IP
where exponent may be negative and the result may be a fraction of a second.
.IP
Four timestamps are detailed: \fBA\fPccess time, \fBB\fPirth/creation time,
\fBC\fPhange time and \fBM\fPodification time.  Capability bits are defined
that specify whether each of these exist in the filesystem or not.
.IP
Note that the timestamp description may be approximated or inaccurate if the
file is actually remote or is the union of multiple objects.

.\" __________________ fsinfo_attr_volume_id __________________
.TP
.B fsinfo_attr_volume_id
This retrieves the system's superblock volume identifier as a variable-length
string.  This does not necessarily represent a value stored in the medium but
might be constructed on the fly.
.IP
For instance, for a block device this is the block device identifier
(eg. "sdb2"); for AFS this would be the numeric volume identifier.

.\" __________________ fsinfo_attr_volume_uuid __________________
.TP
.B fsinfo_attr_volume_uuid
This retrieves the volume UUID, if there is one, as a little-endian binary
UUID.  This fills in the following structure:
.PP
.RS
.in +4n
.nf
struct fsinfo_volume_uuid {
    __u8 uuid[16];
};
.fi
.in
.RE
.IP

.\" __________________ fsinfo_attr_volume_name __________________
.TP
.B fsinfo_attr_volume_name
This retrieves the filesystem's volume name as a variable-length string.  This
is expected to represent a name stored in the medium.
.IP
For a block device, this might be a label stored in the superblock.  For a
network filesystem, this might be a logical volume name of some sort.

.\" __________________ fsinfo_attr_cell/domain __________________
.PP
.B fsinfo_attr_cell_name
.br
.B fsinfo_attr_domain_name
.br
.IP
These two attributes are variable-length string attributes that may be used to
obtain information about network filesystems.  An AFS volume, for instance,
belongs to a named cell.  CIFS shares may belong to a domain.

.\" __________________ fsinfo_attr_realm_name __________________
.TP
.B fsinfo_attr_realm_name
This attribute is variable-length string that indicates the Kerberos realm that
a filesystem's authentication tokens should come from.

.\" __________________ fsinfo_attr_server_name __________________
.TP
.B fsinfo_attr_server_name
This attribute is a multiple-value attribute that lists the names of the
servers that are backing a network filesystem.  Each value is a variable-length
string.  The values are enumerated by calling
.BR fsinfo ()
multiple times, incrementing
.I params->Nth
each time until an ENODATA error occurs, thereby indicating the end of the
list.

.\" __________________ fsinfo_attr_server_address __________________
.TP
.B fsinfo_attr_server_address
This attribute is a multiple-instance, multiple-value attribute that lists the
addresses of the servers that are backing a network filesystem.  Each value is
a structure of the following type:
.PP
.RS
.in +4n
.nf
struct fsinfo_server_address {
    struct __kernel_sockaddr_storage address;
};
.fi
.in
.RE
.IP
Where the address may be AF_INET, AF_INET6, AF_RXRPC or any other type as
appropriate to the filesystem.
.IP
The values are enumerated by calling
.IR fsinfo ()
multiple times, incrementing
.I params->Nth
to step through the servers and
.I params->Mth
to step through the addresses of the Nth server each time until ENODATA errors
occur, thereby indicating either the end of a server's address list or the end
of the server list.
.IP
Barring the server list changing whilst being accessed, it is expected that the
.I params->Nth
will correspond to
.I params->Nth
for
.BR fsinfo_attr_server_name .

.\" __________________ fsinfo_attr_parameter __________________
.TP
.B fsinfo_attr_parameter
This attribute is a multiple-value attribute that lists the values of the mount
parameters for a filesystem as variable-length strings.
.IP
The parameters are enumerated by calling
.BR fsinfo ()
multiple times, incrementing
.I params->Nth
to step through them until error ENODATA is given.
.IP
Parameter strings are presented in a form akin to the way they're passed to the
context created by the
.BR fsopen ()
system call.  For example, straight text parameters will be rendered as
something like:
.PP
.RS
.in +4n
.nf
"o data=journal"
"o noquota"
.fi
.in
.RE
.IP
Where the initial "word" indicates the option form.

.\" __________________ fsinfo_attr_source __________________
.TP
.B fsinfo_attr_source
This attribute is a multiple-value attribute that lists the mount sources for a
filesystem as variable-length strings.  Normally only one source will be
available, but the possibility of having more than one is allowed for.
.IP
The sources are enumerated by calling
.BR fsinfo ()
multiple times, incrementing
.I params->Nth
to step through them until error ENODATA is given.
.IP
Source strings are presented in a form akin to the way they're passed to the
context created by the
.BR fsopen ()
system call.  For example, they will be rendered as something like:
.PP
.RS
.in +4n
.nf
"s /dev/sda1"
"s example.com/pub/linux/"
.fi
.in
.RE
.IP
Where the initial "word" indicates the option form.

.\" __________________ fsinfo_attr_name_encoding __________________
.TP
.B fsinfo_attr_name_encoding
This attribute is variable-length string that indicates the filename encoding
used by the filesystem.  The default is "utf8".  Note that this may indicate a
non-8-bit encoding if that's what the underlying filesystem actually supports.

.\" __________________ fsinfo_attr_name_codepage __________________
.TP
.B fsinfo_attr_name_codepage
This attribute is variable-length string that indicates the codepage used to
translate filenames from the filesystem to the system if this is applicable to
the filesystem.

.\" __________________ fsinfo_attr_io_size __________________
.TP
.B fsinfo_attr_io_size
This retrieves information about the I/O sizes supported by the filesystem.
The following structure is filled in:
.PP
.RS
.in +4n
.nf
struct fsinfo_io_size {
    __u32 block_size;
    __u32 max_single_read_size;
    __u32 max_single_write_size;
    __u32 best_read_size;
    __u32 best_write_size;
};
.fi
.in
.RE
.IP
Where
.I block_size
indicates the fundamental I/O block size of the filesystem as something
O_DIRECT read/write sizes must be a multiple of;
.IR max_single_write_size " and " max_single_write_size
indicate the maximum sizes for individual unbuffered data transfer operations;
and
.IR best_read_size " and " best_write_size
indicate the recommended I/O sizes.
.IP
Note that any of these may be zero if inapplicable or indeterminable.



.SH THE CAPABILITIES
.PP
There are number of capability bits in a bit array that can be retrieved using
.BR fsinfo_attr_capabilities .
These give information about features of the filesystem driver and the specific
filesystem.

.\" __________________ fsinfo_cap_is_*_fs __________________
.PP
.B fsinfo_cap_is_kernel_fs
.br
.B fsinfo_cap_is_block_fs
.br
.B fsinfo_cap_is_flash_fs
.br
.B fsinfo_cap_is_network_fs
.br
.B fsinfo_cap_is_automounter_fs
.IP
These indicate the primary type of the filesystem.
.B kernel
filesystems are special communication interfaces that substitute files for
system calls; examples include procfs and sysfs.
.B block
filesystems require a block device on which to operate; examples include ext4
and XFS.
.B flash
filesystems require an MTD device on which to operate; examples include JFFS2.
.B network
filesystems require access to the network and contact one or more servers;
examples include NFS and AFS.
.B automounter
filesystems are kernel special filesystems that host automount points and
triggers to dynamically create automount points.  Examples include autofs and
AFS's dynamic root.

.\" __________________ fsinfo_cap_automounts __________________
.TP
.B fsinfo_cap_automounts
The filesystem may have automount points that can be triggered by pathwalk.

.\" __________________ fsinfo_cap_adv_locks __________________
.TP
.B fsinfo_cap_adv_locks
The filesystem supports advisory file locks.  For a network filesystem, this
indicates that the advisory file locks are cross-client (and also between
server and its local filesystem on something like NFS).

.\" __________________ fsinfo_cap_mand_locks __________________
.TP
.B fsinfo_cap_mand_locks
The filesystem supports mandatory file locks.  For a network filesystem, this
indicates that the mandatory file locks are cross-client (and also between
server and its local filesystem on something like NFS).

.\" __________________ fsinfo_cap_leases __________________
.TP
.B fsinfo_cap_leases
The filesystem supports leases.  For a network filesystem, this means that the
server will tell the client to clean up its state on a file before passing the
lease to another client.

.\" __________________ fsinfo_cap_*ids __________________
.PP
.B fsinfo_cap_uids
.br
.B fsinfo_cap_gids
.br
.B fsinfo_cap_projids
.IP
These indicate that the filesystem supports numeric user IDs, group IDs and
project IDs respectively.

.\" __________________ fsinfo_cap_id_* __________________
.PP
.B fsinfo_cap_id_names
.br
.B fsinfo_cap_id_guids
.IP
These indicate that the filesystem employs textual names and/or GUIDs as
identifiers.

.\" __________________ fsinfo_cap_windows_attrs __________________
.TP
.B fsinfo_cap_windows_attrs
Indicates that the filesystem supports some Windows FILE_* attributes.

.\" __________________ fsinfo_cap_*_quotas __________________
.PP
.B fsinfo_cap_user_quotas
.br
.B fsinfo_cap_group_quotas
.br
.B fsinfo_cap_project_quotas
.IP
These indicate that the filesystem supports quotas for users, groups and
projects respectively.

.\" __________________ fsinfo_cap_xattrs/filetypes __________________
.PP
.B fsinfo_cap_xattrs
.br
.B fsinfo_cap_symlinks
.br
.B fsinfo_cap_hard_links
.br
.B fsinfo_cap_hard_links_1dir
.br
.B fsinfo_cap_device_files
.br
.B fsinfo_cap_unix_specials
.IP
These indicate that the filesystem supports respectively extended attributes;
symbolic links; hard links spanning direcories; hard links, but only within a
directory; block and character device files; and UNIX special files, such as
FIFO and socket.

.\" __________________ fsinfo_cap_*journal* __________________
.PP
.B fsinfo_cap_journal
.br
.B fsinfo_cap_data_is_journalled
.IP
The first of these indicates that the filesystem has a journal and the second
that the file data changes are being journalled.

.\" __________________ fsinfo_cap_o_* __________________
.PP
.B fsinfo_cap_o_sync
.br
.B fsinfo_cap_o_direct
.IP
These indicate that O_SYNC and O_DIRECT are supported respectively.

.\" __________________ fsinfo_cap_o_* __________________
.PP
.B fsinfo_cap_volume_id
.br
.B fsinfo_cap_volume_uuid
.br
.B fsinfo_cap_volume_name
.br
.B fsinfo_cap_volume_fsid
.br
.B fsinfo_cap_cell_name
.br
.B fsinfo_cap_domain_name
.br
.B fsinfo_cap_realm_name
.IP
These indicate if various attributes are supported by the filesystem, where
.B fsinfo_cap_X
here corresponds to
.BR fsinfo_attr_X .

.\" __________________ fsinfo_cap_iver_* __________________
.PP
.B fsinfo_cap_iver_all_change
.br
.B fsinfo_cap_iver_data_change
.br
.B fsinfo_cap_iver_mono_incr
.IP
These indicate if
.I i_version
on an inode in the filesystem is supported and
how it behaves.
.B all_change
indicates that i_version is incremented on metadata changes as well as data
changes.
.B data_change
indicates that i_version is only incremented on data changes, including
truncation.
.B mono_incr
indicates that i_version is incremented by exactly 1 for each change made.

.\" __________________ fsinfo_cap_resource_forks __________________
.TP
.B fsinfo_cap_resource_forks
This indicates that the filesystem supports some sort of resource fork or
alternate data stream on a file.  This isn't the same as an extended attribute.

.\" __________________ fsinfo_cap_name_* __________________
.PP
.B fsinfo_cap_name_case_indep
.br
.B fsinfo_cap_name_non_utf8
.br
.B fsinfo_cap_name_has_codepage
.IP
These indicate certain facts about the filenames in a filesystem: whether
they're case-independent; if they're not UTF-8; and if there's a codepage
employed to map the names.

.\" __________________ fsinfo_cap_sparse __________________
.TP
.B fsinfo_cap_sparse
This indicates that the filesystem supports sparse files.

.\" __________________ fsinfo_cap_not_persistent __________________
.TP
.B fsinfo_cap_not_persistent
This indicates that the filesystem is not persistent, and that any data stored
here will not be saved in the event that the filesystem is unmounted, the
machine is rebooted or the machine loses power.

.\" __________________ fsinfo_cap_no_unix_mode __________________
.TP
.B fsinfo_cap_no_unix_mode
This indicates that the filesystem doesn't support the UNIX mode permissions
bits.

.\" __________________ fsinfo_cap_has_*time __________________
.PP
.B fsinfo_cap_has_atime
.br
.B fsinfo_cap_has_btime
.br
.B fsinfo_cap_has_ctime
.br
.B fsinfo_cap_has_mtime
.IP
These indicate as to what timestamps a filesystem supports, including: Access
time, Birth/creation time, Change time (metadata and data) and Modification
time (data only).


.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH RETURN VALUE
On success, the size of the value that the kernel has available is returned,
irrespective of whether the buffer is large enough to hold that.  The data
written to the buffer will be truncated if it is not.  On error, \-1 is
returned, and
.I errno
is set appropriately.
.SH ERRORS
.TP
.B EACCES
Search permission is denied for one of the directories
in the path prefix of
.IR pathname .
(See also
.BR path_resolution (7).)
.TP
.B EBADF
.I dirfd
is not a valid open file descriptor.
.TP
.B EFAULT
.I pathname
is NULL or
.IR pathname ", " params " or " buffer
point to a location outside the process's accessible address space.
.TP
.B EINVAL
Reserved flag specified in
.IR params->at_flags " or one of " params->__reserved[]
is not 0.
.TP
.B EOPNOTSUPP
Unsupported attribute requested in
.IR params->request .
This may be beyond the limit of the supported attribute set or may just not be
one that's supported by the filesystem.
.TP
.B ENODATA
Unavailable attribute value requested by
.IR params->Nth " and/or " params->Mth .
.TP
.B ELOOP
Too many symbolic links encountered while traversing the pathname.
.TP
.B ENAMETOOLONG
.I pathname
is too long.
.TP
.B ENOENT
A component of
.I pathname
does not exist, or
.I pathname
is an empty string and
.B AT_EMPTY_PATH
was not specified in
.IR params->at_flags .
.TP
.B ENOMEM
Out of memory (i.e., kernel memory).
.TP
.B ENOTDIR
A component of the path prefix of
.I pathname
is not a directory or
.I pathname
is relative and
.I dirfd
is a file descriptor referring to a file other than a directory.
.SH VERSIONS
.BR fsinfo ()
was added to Linux in kernel 4.18.
.SH CONFORMING TO
.BR fsinfo ()
is Linux-specific.
.SH NOTES
Glibc does not (yet) provide a wrapper for the
.BR fsinfo ()
system call; call it using
.BR syscall (2).
.SH SEE ALSO
.BR ioctl_iflags (2),
.BR statx (2),
.BR statfs (2)
