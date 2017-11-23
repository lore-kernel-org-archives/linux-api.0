From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 4/4] test: add a test for the process_vmsplice syscall
Date: Thu, 23 Nov 2017 09:01:03 +0100
Message-ID: <20171123080103.GA490@kroah.com>
References: <1511379391-988-1-git-send-email-rppt@linux.vnet.ibm.com>
 <1511379391-988-5-git-send-email-rppt@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511379391-988-5-git-send-email-rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 22, 2017 at 09:36:31PM +0200, Mike Rapoport wrote:
> From: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> 
> This test checks that process_vmsplice() can splice pages from a remote
> process and returns EFAULT, if process_vmsplice() tries to splice pages
> by an unaccessiable address.
> 
> Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  tools/testing/selftests/process_vmsplice/Makefile  |   5 +
>  .../process_vmsplice/process_vmsplice_test.c       | 188 +++++++++++++++++++++
>  2 files changed, 193 insertions(+)
>  create mode 100644 tools/testing/selftests/process_vmsplice/Makefile
>  create mode 100644 tools/testing/selftests/process_vmsplice/process_vmsplice_test.c
> 
> diff --git a/tools/testing/selftests/process_vmsplice/Makefile b/tools/testing/selftests/process_vmsplice/Makefile
> new file mode 100644
> index 0000000..246d5a7
> --- /dev/null
> +++ b/tools/testing/selftests/process_vmsplice/Makefile
> @@ -0,0 +1,5 @@
> +CFLAGS += -I../../../../usr/include/
> +
> +TEST_GEN_PROGS := process_vmsplice_test
> +
> +include ../lib.mk
> diff --git a/tools/testing/selftests/process_vmsplice/process_vmsplice_test.c b/tools/testing/selftests/process_vmsplice/process_vmsplice_test.c
> new file mode 100644
> index 0000000..8abf59b
> --- /dev/null
> +++ b/tools/testing/selftests/process_vmsplice/process_vmsplice_test.c
> @@ -0,0 +1,188 @@
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/syscall.h>
> +#include <fcntl.h>
> +#include <sys/uio.h>
> +#include <errno.h>
> +#include <signal.h>
> +#include <sys/prctl.h>
> +#include <sys/wait.h>
> +
> +#include "../kselftest.h"
> +
> +#ifndef __NR_process_vmsplice
> +#define __NR_process_vmsplice 333
> +#endif
> +
> +#define pr_err(fmt, ...) \
> +		({ \
> +			fprintf(stderr, "%s:%d:" fmt, \
> +				__func__, __LINE__, ##__VA_ARGS__); \
> +			KSFT_FAIL; \
> +		})
> +#define pr_perror(fmt, ...) pr_err(fmt ": %m\n", ##__VA_ARGS__)
> +#define fail(fmt, ...) pr_err("FAIL:" fmt, ##__VA_ARGS__)
> +
> +static ssize_t process_vmsplice(pid_t pid, int fd, const struct iovec *iov,
> +			unsigned long nr_segs, unsigned int flags)
> +{
> +	return syscall(__NR_process_vmsplice, pid, fd, iov, nr_segs, flags);
> +
> +}
> +
> +#define MEM_SIZE (4096 * 100)
> +#define MEM_WRONLY_SIZE (4096 * 10)
> +
> +int main(int argc, char **argv)
> +{
> +	char *addr, *addr_wronly;
> +	int p[2];
> +	struct iovec iov[2];
> +	char buf[4096];
> +	int status, ret;
> +	pid_t pid;
> +
> +	ksft_print_header();
> +
> +	addr = mmap(0, MEM_SIZE, PROT_READ | PROT_WRITE,
> +					MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +	if (addr == MAP_FAILED)
> +		return pr_perror("Unable to create a mapping");
> +
> +	addr_wronly = mmap(0, MEM_WRONLY_SIZE, PROT_WRITE,
> +				MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +	if (addr_wronly == MAP_FAILED)
> +		return pr_perror("Unable to create a write-only mapping");
> +
> +	if (pipe(p))
> +		return pr_perror("Unable to create a pipe");
> +
> +	pid = fork();
> +	if (pid < 0)
> +		return pr_perror("Unable to fork");
> +
> +	if (pid == 0) {
> +		addr[0] = 'C';
> +		addr[4096 + 128] = 'A';
> +		addr[4096 + 128 + 4096 - 1] = 'B';
> +
> +		if (prctl(PR_SET_PDEATHSIG, SIGKILL))
> +			return pr_perror("Unable to set PR_SET_PDEATHSIG");
> +		if (write(p[1], "c", 1) != 1)
> +			return pr_perror("Unable to write data into pipe");
> +
> +		while (1)
> +			sleep(1);
> +		return 1;
> +	}
> +	if (read(p[0], buf, 1) != 1) {
> +		pr_perror("Unable to read data from pipe");
> +		kill(pid, SIGKILL);
> +		wait(&status);
> +		return 1;
> +	}
> +
> +	munmap(addr, MEM_SIZE);
> +	munmap(addr_wronly, MEM_WRONLY_SIZE);
> +
> +	iov[0].iov_base = addr;
> +	iov[0].iov_len = 1;
> +
> +	iov[1].iov_base = addr + 4096 + 128;
> +	iov[1].iov_len = 4096;
> +
> +	/* check one iovec */
> +	if (process_vmsplice(pid, p[1], iov, 1, SPLICE_F_GIFT) != 1)
> +		return pr_perror("Unable to splice pages");

Shouldn't you check to see if the syscall is even present?  You should
not error if it is not, as this test will then "fail" on kernels/arches
without the syscall enabled, which isn't the nicest.

thanks,

greg k-h
