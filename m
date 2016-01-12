From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Date: Tue, 12 Jan 2016 00:07:14 -0600
Message-ID: <20160112060714.GA4980@zzz>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
	<20151219085559.12478.33700.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20151219085559.12478.33700.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-api@vger.kernel.org

Some feedback on the VFS portion of the FIDEDUPERANGE ioctl and its man page...
(note: I realize the patch is mostly just moving the code that already existed
in btrfs, but in the VFS it deserves a more thorough review):

At high level, I am confused about what is meant by the "source" and
"destination" files.  I understand that with more than two files, you
effectively have to choose one file to treat specially and dedupe with all the
other files (an NxN comparison isn't realistic).  But with just two files, a
deduplication operation should be completely symmetric, should it not?  The end
result should be that the data is deduplicated, regardless of the order in which
I gave the file descriptors.  So why is there some non-symmetric behavior?
There are several examples but one is that the VFS is checking !S_ISREG() on the
"source" file descriptor but not on the "destination" file descriptor.  Another
is that different permissions are required on the source versus on the
destination.  If there are good reasons for the nonsymmetry then this needs to
be clearly explained in the man page; otherwise it may not be clear what to use
as the "source" and what to use as the "destination".

It seems odd to be adding "copy" as a system call but then have "dedupe" and
"clone" as ioctls rather than system calls... it seems that they should all be
one or the other (at least, if we put aside the fact that the ioctls already
exist in btrfs).

The range checking in clone_verify_area() appears incomplete.  Someone could
provide len=UINT64_MAX and all the checks would still pass even though 'pos+len'
would overflow.

Should the ioctl be interruptible?  Right now it always goes through *all* the
'struct file_dedupe_range_info's you passed in --- potentially up to 65535 of
them.

Why 'info->bytes_deduped += deduped' rather than 'info->bytes_deduped =
deduped'?  'bytes_deduped' is per file descriptor, not for the operation as a
whole.

What permissions do you need on the destination file descriptors?  The man page
implies they must be open for writing and not appending.  The implementation
differs: it requires FMODE_WRITE only for non-admin users, and it doesn't check
for O_APPEND at all.  The man page also says you get EPERM if "dest_fd is
immutable" and ETXTBSY if "one of the files is a swap file", which I don't see
actually happening in the implementation; it seems those error codes perhaps
exist at all for this ioctl but rather be left to open(..., O_WRONLY).

If the filesystem doesn't support deduplication, or I pass in a strange file
descriptor such as one for a named pipe, do I get EINVAL or EOPNOTSUPP?  The man
page isn't clear.

Under what circumstances will 'bytes_deduped' differ from the count that was
passed in?  If short counts are allowed, what will be the 'status' be in that
case: FILE_DEDUP_RANGE_DIFFERS, FILE_DEDUPE_RANGE_SAME, or something else?  Can
data be deduped even if only a prefix of the data region matches?

The man page doesn't mention FILE_DEDUPE_RANGE_SAME at all, instead calling it
0; it only mentions FILE_DEDUPE_RANGE_DIFFERS.

The man page isn't clear about whether the ioctl stops early if an error occurs
or always processes all the 'struct file_dedupe_range_info's you pass in.  And
if it were, hypothetically, to stop early, how is the user meant to know on
which file it stopped?

The man page says "logical_offset" but in the struct it is called "dest_offset".

There are some variables named "same" which don't really make sense now that the
ioctl is called FIDEDUPERANGE instead of EXTENT_SAME.

Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
