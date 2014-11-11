From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCHv2 2/3] selftests: Add test of O_BENEATH & openat(2)
Date: Tue, 11 Nov 2014 16:36:41 +1100
Message-ID: <20141111053641.GR23575@dastard>
References: <1415094884-18349-1-git-send-email-drysdale@google.com>
 <1415094884-18349-3-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1415094884-18349-3-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[cc fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]

On Tue, Nov 04, 2014 at 09:54:43AM +0000, David Drysdale wrote:
> Add simple tests of openat(2) variations, including examples that
> check the new O_BENEATH flag.
> 
> Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Wouldn't this be better added to fstests? That's the regression
test suite used by filesystem developers and most distro QA
organisations and where the fs developers aggregate all their new
regression tests.

IMO, the fewer places we aggregate VFS/filesystem tests the better.
I really don't think the kernel tree is the best place for adding
VFS behavioural tests because it has none of the infrastructure
around it to test arbitrary filesystems and configurations and hence
is not particularly useful to the people whoa re likely to notice
and care about fs regression tests suddenly breaking.

As an example, the recent renameat() syscall additions (e.g.
RENAME_EXCHANGE, RENAME_NOREPLACE) have unit tests in fstests, so
these new O_BENEATH tests should really follow the same model...

Cheers,

Dave.

> ---
>  tools/testing/selftests/Makefile          |   1 +
>  tools/testing/selftests/openat/.gitignore |   4 +
>  tools/testing/selftests/openat/Makefile   |  28 +++++
>  tools/testing/selftests/openat/openat.c   | 180 ++++++++++++++++++++++++++++++
>  4 files changed, 213 insertions(+)
>  create mode 100644 tools/testing/selftests/openat/.gitignore
>  create mode 100644 tools/testing/selftests/openat/Makefile
>  create mode 100644 tools/testing/selftests/openat/openat.c
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 36ff2e4c7b6f..812e973233d2 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -14,6 +14,7 @@ TARGETS += powerpc
>  TARGETS += user
>  TARGETS += sysctl
>  TARGETS += firmware
> +TARGETS += openat
> 
>  TARGETS_HOTPLUG = cpu-hotplug
>  TARGETS_HOTPLUG += memory-hotplug
> diff --git a/tools/testing/selftests/openat/.gitignore b/tools/testing/selftests/openat/.gitignore
> new file mode 100644
> index 000000000000..835b2dcd8678
> --- /dev/null
> +++ b/tools/testing/selftests/openat/.gitignore
> @@ -0,0 +1,4 @@
> +openat
> +subdir
> +topfile
> +symlinkdown
> \ No newline at end of file
> diff --git a/tools/testing/selftests/openat/Makefile b/tools/testing/selftests/openat/Makefile
> new file mode 100644
> index 000000000000..84cd06e7ee82
> --- /dev/null
> +++ b/tools/testing/selftests/openat/Makefile
> @@ -0,0 +1,28 @@
> +CC = $(CROSS_COMPILE)gcc
> +CFLAGS = -Wall
> +BINARIES = openat
> +DEPS = subdir topfile symlinkdown subdir/bottomfile subdir/symlinkup subdir/symlinkout subdir/symlinkin
> +all: $(BINARIES) $(DEPS)
> +
> +subdir:
> +	mkdir -p subdir
> +topfile:
> +	echo 0123456789 > $@
> +subdir/bottomfile: | subdir
> +	echo 0123456789 > $@
> +subdir/symlinkup: | subdir
> +	ln -s ../topfile $@
> +subdir/symlinkout: | subdir
> +	ln -s /etc/passwd $@
> +subdir/symlinkin: | subdir
> +	ln -s bottomfile $@
> +symlinkdown:
> +	ln -s subdir/bottomfile $@
> +%: %.c
> +	$(CC) $(CFLAGS) -o $@ $^
> +
> +run_tests: all
> +	./openat
> +
> +clean:
> +	rm -rf $(BINARIES) $(DEPS)
> diff --git a/tools/testing/selftests/openat/openat.c b/tools/testing/selftests/openat/openat.c
> new file mode 100644
> index 000000000000..0c030cbd10dc
> --- /dev/null
> +++ b/tools/testing/selftests/openat/openat.c
> @@ -0,0 +1,180 @@
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/syscall.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +
> +#include <linux/fcntl.h>
> +
> +/* Bypass glibc */
> +static int openat_(int dirfd, const char *pathname, int flags)
> +{
> +	return syscall(__NR_openat, dirfd, pathname, flags);
> +}
> +
> +static int openat_or_die(int dfd, const char *path, int flags)
> +{
> +	int fd = openat_(dfd, path, flags);
> +
> +	if (fd < 0) {
> +		printf("Failed to openat(%d, '%s'); "
> +			"check prerequisites are available\n", dfd, path);
> +		exit(1);
> +	}
> +	return fd;
> +}
> +
> +static int check_openat(int dfd, const char *path, int flags)
> +{
> +	int rc;
> +	int fd;
> +	char buffer[4];
> +
> +	errno = 0;
> +	printf("Check success of openat(%d, '%s', %x)... ",
> +	       dfd, path?:"(null)", flags);
> +	fd = openat_(dfd, path, flags);
> +	if (fd < 0) {
> +		printf("[FAIL]: openat() failed, rc=%d errno=%d (%s)\n",
> +			fd, errno, strerror(errno));
> +		return 1;
> +	}
> +	errno = 0;
> +	rc = read(fd, buffer, sizeof(buffer));
> +	if (rc < 0) {
> +		printf("[FAIL]: read() failed, rc=%d errno=%d (%s)\n",
> +			rc, errno, strerror(errno));
> +		return 1;
> +	}
> +	close(fd);
> +	printf("[OK]\n");
> +	return 0;
> +}
> +
> +#define check_openat_fail(dfd, path, flags, errno)	\
> +	_check_openat_fail(dfd, path, flags, errno, #errno)
> +static int _check_openat_fail(int dfd, const char *path, int flags,
> +			      int expected_errno, const char *errno_str)
> +{
> +	int rc;
> +
> +	errno = 0;
> +	printf("Check failure of openat(%d, '%s', %x) with %s... ",
> +		dfd, path?:"(null)", flags, errno_str);
> +	rc = openat_(dfd, path, flags);
> +	if (rc > 0) {
> +		printf("[FAIL] (unexpected success from openat(2))\n");
> +		close(rc);
> +		return 1;
> +	}
> +	if (errno != expected_errno) {
> +		printf("[FAIL] (expected errno %d (%s) not %d (%s)\n",
> +			expected_errno, strerror(expected_errno),
> +			errno, strerror(errno));
> +		return 1;
> +	}
> +	printf("[OK]\n");
> +	return 0;
> +}
> +
> +int check_proc(void)
> +{
> +	int proc_dfd = openat_(AT_FDCWD, "/proc/self", O_RDONLY);
> +	int fail = 0;
> +
> +	if (proc_dfd < 0) {
> +		printf("'/proc/self' unavailable (errno=%d '%s'), skipping\n",
> +			errno, strerror(errno));
> +		return 1;
> +	}
> +	fail |= check_openat(proc_dfd, "root/etc/passwd", O_RDONLY);
> +#ifdef O_BENEATH
> +	fail |= check_openat_fail(proc_dfd, "root/etc/passwd",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +#endif
> +	return fail;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int fail = 0;
> +	int dot_dfd = openat_or_die(AT_FDCWD, ".", O_RDONLY);
> +	int subdir_dfd = openat_or_die(AT_FDCWD, "subdir", O_RDONLY);
> +	int file_fd = openat_or_die(AT_FDCWD, "topfile", O_RDONLY);
> +
> +	/* Sanity check normal behavior */
> +	fail |= check_openat(AT_FDCWD, "topfile", O_RDONLY);
> +	fail |= check_openat(AT_FDCWD, "subdir/bottomfile", O_RDONLY);
> +
> +	fail |= check_openat(dot_dfd, "topfile", O_RDONLY);
> +	fail |= check_openat(dot_dfd, "subdir/bottomfile", O_RDONLY);
> +	fail |= check_openat(dot_dfd, "subdir/../topfile", O_RDONLY);
> +
> +	fail |= check_openat(subdir_dfd, "../topfile", O_RDONLY);
> +	fail |= check_openat(subdir_dfd, "bottomfile", O_RDONLY);
> +	fail |= check_openat(subdir_dfd, "../subdir/bottomfile", O_RDONLY);
> +	fail |= check_openat(subdir_dfd, "symlinkup", O_RDONLY);
> +	fail |= check_openat(subdir_dfd, "symlinkout", O_RDONLY);
> +
> +	fail |= check_openat(AT_FDCWD, "/etc/passwd", O_RDONLY);
> +	fail |= check_openat(dot_dfd, "/etc/passwd", O_RDONLY);
> +	fail |= check_openat(subdir_dfd, "/etc/passwd", O_RDONLY);
> +
> +	fail |= check_openat_fail(AT_FDCWD, "bogus", O_RDONLY, ENOENT);
> +	fail |= check_openat_fail(dot_dfd, "bogus", O_RDONLY, ENOENT);
> +	fail |= check_openat_fail(999, "bogus", O_RDONLY, EBADF);
> +	fail |= check_openat_fail(file_fd, "bogus", O_RDONLY, ENOTDIR);
> +
> +#ifdef O_BENEATH
> +	/* Test out O_BENEATH */
> +	fail |= check_openat(AT_FDCWD, "topfile", O_RDONLY|O_BENEATH);
> +	fail |= check_openat(AT_FDCWD, "subdir/bottomfile",
> +			     O_RDONLY|O_BENEATH);
> +
> +	fail |= check_openat(dot_dfd, "topfile", O_RDONLY|O_BENEATH);
> +	fail |= check_openat(dot_dfd, "subdir/bottomfile",
> +			     O_RDONLY|O_BENEATH);
> +	fail |= check_openat(subdir_dfd, "bottomfile", O_RDONLY|O_BENEATH);
> +
> +	/* Symlinks without .. or leading / are OK */
> +	fail |= check_openat(dot_dfd, "symlinkdown", O_RDONLY|O_BENEATH);
> +	fail |= check_openat(dot_dfd, "subdir/symlinkin", O_RDONLY|O_BENEATH);
> +	fail |= check_openat(subdir_dfd, "symlinkin", O_RDONLY|O_BENEATH);
> +	/* ... unless of course we specify O_NOFOLLOW */
> +	fail |= check_openat_fail(dot_dfd, "symlinkdown",
> +				  O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
> +	fail |= check_openat_fail(dot_dfd, "subdir/symlinkin",
> +				  O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
> +	fail |= check_openat_fail(subdir_dfd, "symlinkin",
> +				  O_RDONLY|O_BENEATH|O_NOFOLLOW, ELOOP);
> +
> +	/* Can't open paths with ".." in them */
> +	fail |= check_openat_fail(dot_dfd, "subdir/../topfile",
> +				O_RDONLY|O_BENEATH, EPERM);
> +	fail |= check_openat_fail(subdir_dfd, "../topfile",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +	fail |= check_openat_fail(subdir_dfd, "../subdir/bottomfile",
> +				O_RDONLY|O_BENEATH, EPERM);
> +
> +	/* Can't open paths starting with "/" */
> +	fail |= check_openat_fail(AT_FDCWD, "/etc/passwd",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +	fail |= check_openat_fail(dot_dfd, "/etc/passwd",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +	fail |= check_openat_fail(subdir_dfd, "/etc/passwd",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +	/* Can't sneak around constraints with symlinks */
> +	fail |= check_openat_fail(subdir_dfd, "symlinkup",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +	fail |= check_openat_fail(subdir_dfd, "symlinkout",
> +				  O_RDONLY|O_BENEATH, EPERM);
> +#else
> +	printf("Skipping O_BENEATH tests due to missing #define\n");
> +#endif
> +	fail |= check_proc();
> +
> +	return fail ? -1 : 0;
> +}
> --
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
