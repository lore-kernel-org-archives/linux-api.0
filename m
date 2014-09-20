From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Getting ready for IO extensions, v3
Date: Fri, 19 Sep 2014 17:46:34 -0700
Message-ID: <20140920004634.GA18529@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi everyone,

I've been working (albeit slowly) on the userspace IO extension interface that
I talked about last April[1].  The mechanism of attaching various attributes
(which so far have been mandatory ones) to IO requests has been messy, since it
requires me to design an interface for both the extensions I have in mind as
well as a generic way to pass extensions into the kernel from userland.

Is this the appropriate forum to talk about API design in Linux?  It seems that
way to me based on the list archives, but then I'm new at this, and would like
to discuss the design before sending full patches (again).

So far I've defined this structure:

/* IO extension flags */
#define IO_EXT_PI	(1)	/* protection info (checksums, etc) */
#define IO_EXT_REPLICA	(0x2)	/* replica */
#define IO_EXT_ALL	(IO_EXT_PI | IO_EXT_REPLICA)

/* IO extension descriptor */
struct io_extension {
	__u64 ie_has;

	/* Checksum buffer to go with the IO */
	__u64 ie_pi_buf;
	__u32 ie_pi_buflen;
	__u64 ie_pi_flags;

	/* If storage stores multiple copies, order an IO to specific one */
	__u32 ie_replica;
};

ie_has is a bitfield of IO_EXT_* values that indicates which of the fields have
been filled in; the ie_pi_* and ie_replica pieces are for the individual
extensions to attach to a struct bio (or whatever) in the appropriate ways.  I
don't see structure size mismatches becoming an issue -- since we're exporting
the structure definition along with the _has flags, a program ought to be using
a structure that's big enough, and it can be allowed to segfault if the pointer
isn't good.

In order to attach a struct io_extension* to IOs, I've thought about extending
the readv, writev, preadv, and pwritev syscalls to take a pointer to this
struct, and using the aio_reserved2 field in struct iocb (along with setting a
new IOCB_FLAG_) to handle the AIO case.  I hate to add more syscalls, but as
we've seen on -fsdevel recently I'm not the only person interested in adding
more arguments.

The glaring downsides of this approach of course is that we waste memory on
fields that might not be turned on, we have to find a sane way to handle the
ie_has flags, and fields cannot be removed from the structure.  I don't know of
a good way to design around those problems without greatly increasing the
complexity of the data structure (a generic dictionary would work but ye gods
that's horrifying), so I was wondering if any of you could suggest something
better?

Thank you in advance for comments and criticisms as I learn API design. :)

--D

[1] http://www.spinics.net/lists/linux-scsi/msg73308.html
