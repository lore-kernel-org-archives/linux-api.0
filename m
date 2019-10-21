From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH man-pages] Document encoded I/O
Date: Mon, 21 Oct 2019 11:53:56 -0700
Message-ID: <20191021185356.GB81648@vader>
References: <cover.1571164762.git.osandov@fb.com>
 <c7e8f93596fee7bb818dc0edf29f484036be1abb.1571164851.git.osandov@fb.com>
 <CAOQ4uxh_pZSiMmD=46Mc3o0GE+svXuoC155P_9FGJXdsE4cweg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh_pZSiMmD=46Mc3o0GE+svXuoC155P_9FGJXdsE4cweg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, kernel-team@fb.com, Theodore Tso <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 21, 2019 at 09:18:13AM +0300, Amir Goldstein wrote:
> CC: Ted
> 
> What ever happened to read/write ext4 encrypted data API?
> https://marc.info/?l=linux-ext4&m=145030599010416&w=2
> 
> Can we learn anything from the ext4 experience to improve
> the new proposed API?

I wasn't aware of these patches, thanks for pointing them out. Ted, do
you have any thoughts about making this API work for fscrypt?

> On Wed, Oct 16, 2019 at 12:29 AM Omar Sandoval <osandov@osandov.com> wrote:
> >
> > From: Omar Sandoval <osandov@fb.com>
> >
> > This adds a new page, rwf_encoded(7), providing an overview of encoded
> > I/O and updates fcntl(2), open(2), and preadv2(2)/pwritev2(2) to
> > reference it.
> >
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  man2/fcntl.2       |  10 +-
> >  man2/open.2        |  13 ++
> >  man2/readv.2       |  46 +++++++
> >  man7/rwf_encoded.7 | 297 +++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 365 insertions(+), 1 deletion(-)
> >  create mode 100644 man7/rwf_encoded.7
> >
> > diff --git a/man2/fcntl.2 b/man2/fcntl.2
> > index fce4f4c2b..76fe9cc6f 100644
> > --- a/man2/fcntl.2
> > +++ b/man2/fcntl.2
> > @@ -222,8 +222,9 @@ On Linux, this command can change only the
> >  .BR O_ASYNC ,
> >  .BR O_DIRECT ,
> >  .BR O_NOATIME ,
> > +.BR O_NONBLOCK ,
> >  and
> > -.B O_NONBLOCK
> > +.B O_ENCODED
> >  flags.
> >  It is not possible to change the
> >  .BR O_DSYNC
> > @@ -1803,6 +1804,13 @@ Attempted to clear the
> >  flag on a file that has the append-only attribute set.
> >  .TP
> >  .B EPERM
> > +Attempted to set the
> > +.B O_ENCODED
> > +flag and the calling process did not have the
> > +.B CAP_SYS_ADMIN
> > +capability.
> > +.TP
> > +.B EPERM
> >  .I cmd
> >  was
> >  .BR F_ADD_SEALS ,
> > diff --git a/man2/open.2 b/man2/open.2
> > index b0f485b41..cdd3c549c 100644
> > --- a/man2/open.2
> > +++ b/man2/open.2
> > @@ -421,6 +421,14 @@ was followed by a call to
> >  .BR fdatasync (2)).
> >  .IR "See NOTES below" .
> >  .TP
> > +.B O_ENCODED
> > +Open the file with encoded I/O permissions;
> 
> 1. I find the name of the flag confusing.
> Yes, most people don't read documentation so carefully (or at all)
> so they will assume O_ENCODED will affect read/write or that it
> relates to RWF_ENCODED in a similar way that O_SYNC relates
> to RWF_SYNC (i.e. logical OR and not logical AND).
> 
> I am not good at naming and to prove it I will propose:
> O_PROMISCUOUS, O_MAINTENANCE, O_ALLOW_ENCODED

Agreed, the name is misleading. I can't think of anything better than
O_ALLOW_ENCODED, so I'll go with that unless someone comes up with
something better :)

> 2. While I see no harm in adding O_ flag to open(2) for this
> use case, I also don't see a major benefit in adding it.
> What if we only allowed setting the flag via fcntl(2) which returns
> an error on old kernels?
> Since unlike most O_ flags, O_ENCODED does NOT affect file
> i/o without additional opt-in flags, it is not standard anyway and
> therefore I find that setting it only via fcntl(2) is less error prone.

If I make this fcntl-only, then it probably shouldn't be through
F_GETFL/F_SETFL (it'd be pretty awkward for an O_ flag to not be valid
for open(), and also awkward to mix some non-O_ flag with O_ flags for
F_GETFL/F_SETFL). So that leaves a couple of options:

1. Get/set it with F_GETFD/F_SETFD, which is currently only used for
   FD_CLOEXEC. That also silently ignores unknown flags, but as with the
   O_ flag option, I don't think that's a big deal for FD_ALLOW_ENCODED.
2. Add a new fcntl command (F_GETFD2/F_SETFD2?). This seems like
   overkill to me.

However, both of these options are annoying to implement. Ideally, we
wouldn't have to add another flags field to struct file. But, to reuse
f_flags, we'd need to make sure that FD_ALLOW_ENCODED doesn't collide
with other O_ flags, and we'd probably want to hide it from F_GETFL. At
that point, it might as well be an O_ flag.

It seems to me that it's more trouble than it's worth to make this not
an O_ flag, but please let me know if you see a nice way to do so.

> > +see
> > +.BR rwf_encoded (7).
> > +The caller must have the
> > +.B CAP_SYS_ADMIN
> > +capabilty.
> > +.TP
> >  .B O_EXCL
> >  Ensure that this call creates the file:
> >  if this flag is specified in conjunction with
> > @@ -1168,6 +1176,11 @@ did not match the owner of the file and the caller was not privileged.
> >  The operation was prevented by a file seal; see
> >  .BR fcntl (2).
> >  .TP
> > +.B EPERM
> > +The
> > +.B O_ENCODED
> > +flag was specified, but the caller was not privileged.
> > +.TP
> >  .B EROFS
> >  .I pathname
> >  refers to a file on a read-only filesystem and write access was
> > diff --git a/man2/readv.2 b/man2/readv.2
> > index af27aa63e..aa60b980a 100644
> > --- a/man2/readv.2
> > +++ b/man2/readv.2
> > @@ -265,6 +265,11 @@ the data is always appended to the end of the file.
> >  However, if the
> >  .I offset
> >  argument is \-1, the current file offset is updated.
> > +.TP
> > +.BR RWF_ENCODED " (since Linux 5.6)"
> > +Read or write encoded (e.g., compressed) data.
> > +See
> > +.BR rwf_encoded (7).
> >  .SH RETURN VALUE
> >  On success,
> >  .BR readv (),
> > @@ -284,6 +289,13 @@ than requested (see
> >  and
> >  .BR write (2)).
> >  .PP
> > +If
> > +.B
> > +RWF_ENCODED
> > +was specified in
> > +.IR flags ,
> > +then the return value is the number of encoded bytes.
> > +.PP
> >  On error, \-1 is returned, and \fIerrno\fP is set appropriately.
> >  .SH ERRORS
> >  The errors are as given for
> > @@ -314,6 +326,40 @@ is less than zero or greater than the permitted maximum.
> >  .TP
> >  .B EOPNOTSUPP
> >  An unknown flag is specified in \fIflags\fP.
> > +.TP
> > +.B EOPNOTSUPP
> > +.B RWF_ENCODED
> > +is specified in
> > +.I flags
> > +and the filesystem does not implement encoded I/O.
> > +.TP
> > +.B EPERM
> > +.B RWF_ENCODED
> > +is specified in
> > +.I flags
> > +and the file was not opened with the
> > +.B O_ENCODED
> > +flag.
> > +.PP
> > +.BR preadv2 ()
> > +can fail for the following reasons:
> > +.TP
> > +.B EFBIG
> > +.B RWF_ENCODED
> > +is specified in
> > +.I flags
> > +and buffers in
> > +.I iov
> > +were not big enough to return the encoded data.
> 
> I don't like it that EFBIG is returned for read.
> While EXXX values meaning is often very vague, EFBIG meaning
> is still quite consistent - it is always a write related error when trying
> to change i_size above fs/system limits.
> 
> In the case above, I find E2BIG much more appropriate.
> Although its original meaning was too long arg list, it already grew
> several cases where it generally means "buffer cannot hold the result"
> like the case with msgrcv(2) and listxattr(2).

Yes, E2BIG is a better fit, I'll change it.
