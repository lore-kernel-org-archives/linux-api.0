From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] new flag COPY_FILE_RANGE_FILESIZE for copy_file_range()
Date: Sun, 14 Apr 2019 10:10:16 +0300
Message-ID: <CAOQ4uxgkE+Ls+Sff1ptWtFwpT3dZrRayXsr4wX4Z9bZ=28Vxhw@mail.gmail.com>
References: <20190413205439.9623-1-shawn@git.icu> <20190414010254.GA7408@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190414010254.GA7408@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Landden <shawn@git.icu>
Cc: linux-api@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 14, 2019 at 4:04 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Sat, Apr 13, 2019 at 03:54:39PM -0500, Shawn Landden wrote:
>
> /me pulls out his close-reading glasses and the copy_file_range manpage...
>
> > If flags includes COPY_FILE_RANGE_FILESIZE then the length
> > copied is the length of the file. off_in and off_out are
> > ignored.  len must be 0 or the file size.
>
> They're ignored?  As in the copy operation reads the number of bytes in
> the file referenced by fd_in from fd_in at its current position and is
> writes that out to fd_out at its current position?  I don't see why I
> would want such an operation...
>
> ...but I can see how people could make use of a CFR_ENTIRE_FILE that
> would check that both file descriptors are actually regular files, and
> if so copy the entire contents of the fd_in file into the same position
> in the fd_out file, and then set the fd_out file's length to match.  If
> @off_in or @off_out are non-NULL then they'll be updated to the new EOFs
> if the copy completes succesfully and @len can be anything.
>

IDGI. In what way would that be helpful?
Would the syscall fail if it cannot copy entire file (like clone_file_range)
or return bytes copied?
If latter, then user will have to call syscall again until getting 0
return value.
User can already call copy_file_range with len=SSIZE_MAX and get almost
the same thing.
Unless the idea is to optimize for less syscalls for copying very large files??
In that case, MAX_RW_COUNT limit for this syscall would need to be relaxed.

While on the subject, something that has been discussed in the past is that
copy_file_range() and sendfile() of a large file are not killable, so that is
that should be fixed, especially if the interface is going to be used to copy
more data in-kernel.

IOW, the motivation of the patch is not clear to me:

> This implementation saves a call to stat() in the common case

What is the real life workload where this micro optimization would
have any affect?

> It does not fix any race conditions, but that is possible in the future
> with this interface.

Then please present a plan or an implementation of how that interface
can solve race conditions and if that is the only motivation for the
interface than I do not see why we should merge the interface before
the implementation.

Please let me know if I am missing something.

Thanks,
Amir.
