From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] fstests: generic test for preadv2 behavior on linux
Date: Mon, 16 Mar 2015 15:07:46 -0600
Message-ID: <BF78A586-3F25-4434-B646-EEA9DB8E62B6@dilger.ca>
References: <cover.1426528417.git.milosz@adfin.com> <1426530862-32276-1-git-send-email-milosz@adfin.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <1426530862-32276-1-git-send-email-milosz@adfin.com>
Sender: owner-linux-aio@kvack.org
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org


> On Mar 16, 2015, at 12:34 PM, Milosz Tanski <milosz@adfin.com> wrote:
>=20
> preadv2 is a new syscall introduced that is like preadv2 but with flag

Sorry, "preadv2 ... is like preadv2"?

> argument. The first use case of this is to let us add a flag to =
perform a
> non-blocking file using the page cache.

This is also missing a Signed-off-by: line.

Cheers, Andreas
> ---
> src/Makefile           |   2 +-
> src/preadv2-pwritev2.h |  52 +++++++++++++++++
> src/preadv2.c          | 150 =
+++++++++++++++++++++++++++++++++++++++++++++++++
> tests/generic/067      |  85 ++++++++++++++++++++++++++++
> tests/generic/067.out  |   9 +++
> tests/generic/group    |   1 +
> 6 files changed, 298 insertions(+), 1 deletion(-)
> create mode 100644 src/preadv2-pwritev2.h
> create mode 100644 src/preadv2.c
> create mode 100755 tests/generic/067
> create mode 100644 tests/generic/067.out
>=20
> diff --git a/src/Makefile b/src/Makefile
> index 4781736..f7d3681 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -19,7 +19,7 @@ LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize =
preallo_rw_pattern_reader \
> 	bulkstat_unlink_test_modified t_dir_offset t_futimens =
t_immutable \
> 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test =
\
> 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec =
cloner \
> -	renameat2 t_getcwd e4compact
> +	renameat2 t_getcwd e4compact preadv2
>=20
> SUBDIRS =3D
>=20
> diff --git a/src/preadv2-pwritev2.h b/src/preadv2-pwritev2.h
> new file mode 100644
> index 0000000..786e524
> --- /dev/null
> +++ b/src/preadv2-pwritev2.h
> @@ -0,0 +1,52 @@
> +#ifndef PREADV2_PWRITEV2_H
> +#define PREADV2_PWRITEV2_H
> +
> +#include "global.h"
> +
> +#ifndef HAVE_PREADV2
> +#include <sys/syscall.h>
> +
> +#if !defined(SYS_preadv2) && defined(__x86_64__)
> +#define SYS_preadv2 323
> +#define SYS_pwritev2 324
> +#endif
> +
> +#if !defined (SYS_preadv2) && defined(__i386__)
> +#define SYS_preadv2 359
> +#define SYS_pwritev2 360
> +#endif
> +
> +/* LO_HI_LONG taken from glibc */
> +#define LO_HI_LONG(val)							=
\
> +  (off_t) val,                                                        =
  \
> +  (off_t) ((((uint64_t) (val)) >> (sizeof (long) * 4)) >> (sizeof =
(long) * 4))
> +
> +static inline ssize_t
> +preadv2(int fd, const struct iovec *iov, int iovcnt, off_t offset, =
int flags)
> +{
> +#ifdef SYS_preadv2
> +        return syscall(SYS_preadv2, fd, iov, iovcnt, =
LO_HI_LONG(offset),
> +		       flags);
> +#else
> +	errno =3D ENOSYS;
> +	return -1;
> +#endif
> +}
> +
> +static inline ssize_t
> +pwritev2(int fd, const struct iovec *iov, int iovcnt, off_t offset, =
int flags)
> +{
> +#ifdef SYS_pwritev2
> +        return syscall(SYS_pwritev2, fd, iov, iovcnt, =
LO_HI_LONG(offset),
> +		       flags);
> +#else
> +	errno =3D ENOSYS;
> +	return -1;
> +#endif
> +}
> +
> +#define RWF_NONBLOCK	0x00000001
> +#define RWF_DSYNC	0x00000002
> +
> +#endif /* HAVE_PREADV2 */
> +#endif /* PREADV2_PWRITEV2_H */
> diff --git a/src/preadv2.c b/src/preadv2.c
> new file mode 100644
> index 0000000..a4f89b5
> --- /dev/null
> +++ b/src/preadv2.c
> @@ -0,0 +1,150 @@
> +/*
> + * Copyright 2014 Red Hat, Inc.  All rights reserved.
> + * Copyright 2015 Milosz Tanski
> + *
> + * License: GPLv2
> + *
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <getopt.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <linux/fs.h> /* for RWF_NONBLOCK */
> +
> +/*
> + * Once preadv2 is part of the upstream kernel and there is glibc =
support for
> + * it. We'll add support for preadv2 to xfs_io and this will be =
unnecessary.
> + */
> +#include "preadv2-pwritev2.h"
> +
> +/*
> + * Test to see if the system call is implemented.  If -EINVAL or =
-ENOSYS
> + * are returned, consider the call unimplemented.  All other errors =
are
> + * considered success.
> + *
> + * Returns: 0 if the system call is implemented, 1 if the system call
> + * is not implemented.
> + */
> +int
> +preadv2_check(int fd)
> +{
> +	int ret;
> +	struct iovec iov[] =3D {};
> +
> +	/* 0 length read; just check iof the syscall is there.
> +         *
> +         * - 0 length iovec
> +         * - Position is -1 (eg. use current position)
> +         */
> +	ret =3D preadv2(fd, iov, 0, -1, 0);
> +
> +	if (ret < 0) {
> +		if (errno =3D=3D ENOSYS || errno =3D=3D EINVAL)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +void
> +usage(char *prog)
> +{
> +	fprintf(stderr, "Usage: %s [-v] [-ctdw] [-n] -p POS -l LEN =
<filename>\n\n", prog);
> +	fprintf(stderr, "General arguments:\n");
> +	fprintf(stderr, "  -v Verify that the syscall is supported and =
quit:\n");
> +	fprintf(stderr, "\n");
> +	fprintf(stderr, "Open arguments:\n");
> +	fprintf(stderr, "  -c Open file with O_CREAT flag\n");
> +	fprintf(stderr, "  -t Open file with O_TRUNC flag\n");
> +	fprintf(stderr, "  -d Open file with O_DIRECT flag\n");
> +	fprintf(stderr, "  -w Open file with O_RDWR flag vs O_RDONLY =
(default)\n");
> +	fprintf(stderr, "\n");
> +	fprintf(stderr, "preadv2 arguments:\n");
> +	fprintf(stderr, "  -n use RWF_NONBLOCK when performing read\n");
> +	fprintf(stderr, "  -p POS offset file to read at\n");
> +	fprintf(stderr, "  -l LEN length of file data to read\n");
> +	fprintf(stderr, "\n");
> +	fflush(stderr);
> +}
> +
> +int
> +main(int argc, char **argv)
> +{
> +	int fd;
> +	int ret;
> +	int opt;
> +	off_t pos =3D -1;
> +	struct iovec iov =3D { NULL, 0 };
> +	int o_flags =3D 0;
> +	int r_flags =3D 0;
> +	char *filename;
> +
> +	while ((opt =3D getopt(argc, argv, "vctdwnp:l:")) !=3D -1) {
> +		switch (opt) {
> +		case 'v':
> +			/*
> +			 * See if we were called to check for =
availability of
> +			 * sys_preadv2. STDIN is okay, since we do a =
zero
> +			 * length read (see man 2 read).
> +			 */
> +			ret =3D preadv2_check(STDIN_FILENO);
> +			exit(ret);
> +		case 'c':
> +			o_flags |=3D O_CREAT;
> +			break;
> +		case 't':
> +			o_flags |=3D O_TRUNC;
> +			break;
> +		case 'd':
> +			o_flags |=3D O_DIRECT;
> +			break;
> +		case 'w':
> +			o_flags |=3D O_RDWR;
> +			break;
> +		case 'n':
> +			r_flags |=3D RWF_NONBLOCK;
> +			break;
> +		case 'p':
> +			pos =3D atoll(optarg);
> +			break;
> +		case 'l':
> +			iov.iov_len =3D atoll(optarg);
> +			break;
> +		default:
> +			fprintf(stderr, "invalid option: %c\n", opt);
> +			usage(argv[0]);
> +			exit(1);
> +		}
> +	}
> +
> +	if (optind >=3D argc) {
> +		usage(argv[0]);
> +		exit(1);
> +	}
> +
> +	if ((o_flags & O_RDWR) !=3D O_RDWR)
> +		o_flags |=3D O_RDONLY;
> +
> +	if ((iov.iov_base =3D malloc(iov.iov_len)) =3D=3D NULL) {
> +		perror("malloc");
> +		exit(1);
> +	}
> +
> +	filename =3D argv[optind];
> +	fd =3D open(filename, o_flags);
> +
> +	if (fd < 0) {
> +		perror("open");
> +		exit(1);
> +	}
> +
> +	if ((ret =3D preadv2(fd, &iov, 1, pos, r_flags)) =3D=3D -1) {
> +		perror("preadv2");
> +		exit(ret);
> +	}
> +
> +	free(iov.iov_base);
> +	exit(0);
> +}
> diff --git a/tests/generic/067 b/tests/generic/067
> new file mode 100755
> index 0000000..4cc58f8
> --- /dev/null
> +++ b/tests/generic/067
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# FS QA Test No. 067
> +#
> +# Test for the preadv2 syscall
> +#
> =
+#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Milosz Tanski <mtanski@gmail.com>.  All Rights =
Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software =
Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> =
+#-----------------------------------------------------------------------
> +#
> +
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test
> +
> +# test file we'll be using
> +file=3D$SCRATCH_MNT/067.preadv2.$$
> +
> +# Create a file:
> +# two regions of data and a hole in the middle
> +# use O_DIRECT so it's not in the page cache
> +echo "create file"
> +$XFS_IO_PROG -t -f -d \
> +	-c "pwrite 0 1024" \
> +	-c "pwrite 2048 1024" \
> +	$file > /dev/null
> +
> +# Make sure it returns EAGAIN on uncached data
> +echo "uncached"
> +$here/src/preadv2 -n -p 0 -l 1024 $file
> +
> +# Make sure we read in the whole file, after that RWF_NONBLOCK should =
return us all the data
> +echo "cached"
> +$XFS_IO_PROG -f $file -c "pread 0 4096" $file > /dev/null
> +$here/src/preadv2 -n -p 0 -l 1024 $file
> +
> +# O_DIRECT and RWF_NONBLOCK should return EAGAIN always
> +echo "O_DIRECT"
> +$here/src/preadv2 -d -n -p 0 -l 1024 $file
> +
> +# Holes do not block
> +echo "holes"
> +$here/src/preadv2 -n -p 2048 -l 1024 $file
> +
> +# EOF behavior (no EAGAIN)
> +echo "EOF"
> +$here/src/preadv2 -n -p 3072 -l 1 $file
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/generic/067.out b/tests/generic/067.out
> new file mode 100644
> index 0000000..6e3740f
> --- /dev/null
> +++ b/tests/generic/067.out
> @@ -0,0 +1,9 @@
> +QA output created by 067
> +create file
> +uncached
> +preadv2: Resource temporarily unavailable
> +cached
> +O_DIRECT
> +preadv2: Resource temporarily unavailable
> +holes
> +EOF
> diff --git a/tests/generic/group b/tests/generic/group
> index e5db772..91c5870 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -69,6 +69,7 @@
> 064 auto quick prealloc
> 065 metadata auto quick
> 066 metadata auto quick
> +067 auto quick rw
> 068 other auto freeze dangerous stress
> 069 rw udf auto quick
> 070 attr udf auto quick stress
> --=20
> 1.9.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
