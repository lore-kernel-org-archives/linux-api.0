From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 19 Apr 2012 17:29:28 -0600
Message-ID: <EFBB2162-3558-4F84-8D32-D602C84D48F1@dilger.ca>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

On 2012-04-19, at 8:05 AM, David Howells wrote:
> Implement a pair of new system calls to provide extended and further
> extensible stat functions.

Hallelujah for this.  I've been waiting/wanting something like this
for ages already.  Now if only we can get this landed before it
degrades into the mess it did last time.

> Should fxstat() be implemented as xstat() with a NULL filename,
> using dfd as fd?

I'm personally inclined toward fewer syscalls, especially since
the fstatxat()->statxat() mapping (if I can be so bold as to
prefer the names used later in this thread) is IMHO clear and
unambiguous, and avoids several thin wrappers in the kernel.

> Should the default for a network fs be to do an unconditional
> (heavyweight) stat with a flag to suppress going to the server
> to update the locally held attributes and flushing pending writebacks?

NOOOooo!  If application writers are going to use this, they should
request the information needed, and no more.  Make no assumptions
about what information is easy or hard for a filesystem to return,
since the overhead can vary wildly depending on the implementation.

Something like "ls --color" (no -l or -s) always stats the file just
to get the mode bits to color executable files differently.  Having
to return other information that isn't totally free almost ruins the
benefit of adding a new syscall in the first place.

> Should things like the Windows Archive, Hidden and System bits be
> handled through IOC flags, perhaps expanded to 64-bits?

I'm definitely in favour of a 64-bit IOC flags value, since they are
getting close to running out already.  As to whether those other bits
should be merged into the IOC flags, I'm mostly indifferent, but I
lean toward including them since they are definitely related.

I wouldn't object to 64-bit UID/GID values or split 32-bit low/hi UID
and GID values, since NFSv4 and Kerberos realms will likely need this
at some point as well.  That said, if the API is extensible, it would
be just as easy to add the low/hi split values when they are needed
in the future.

> Are these things useful to userspace other than Samba and userspace
> NFS servers?

Definitely yes.  The GNU fileutils can use a lot of this, since they
are VERY stat() heavy for things like checking st_dev and st_ino
changes during directory traversal, but don't need any of the other
info.

> Is it useful to pass the volume ID out?  Or is statfs() sufficient
> for this?

Can't hurt, IMHO.  It is a better (more persistent) identifier than
st_dev, and if it is free, or explicitly requested by the application
(Samba, Ganesha, etc) it can be very useful.

Cheers, Andreas





