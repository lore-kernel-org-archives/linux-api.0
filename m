From: Szabolcs Nagy <nsz@port70.net>
Subject: Re: [(resend)] seq_file: reset iterator to first record for zero
 offset
Date: Wed, 8 Nov 2017 14:10:05 +0100
Message-ID: <20171108131005.GA15263@port70.net>
References: <20161219113800.GE27207@veci.piliscsaba.szeredi.hu>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-12082-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20161219113800.GE27207@veci.piliscsaba.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com, Rich Felker <dalias@libc.org>
List-Id: linux-api@vger.kernel.org

* Miklos Szeredi <miklos@szeredi.hu> [2016-12-19 12:38:00 +0100]:
> Al,
> 
> Can you please take (or NACK) this patch please?
> 
> Thanks,
> Miklos
> ---
> From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Date: Tue, 29 Nov 2016 15:18:20 +0100
> 
> If kernfs file is empty on a first read, successive read operations
> using the same file descriptor will return no data, even when data is
> available. Default kernfs 'seq_next' implementation advances iterator
> position even when next object is not there. Kernfs 'seq_start' for
> following requests will not return iterator as position is already on
> the second object.
> 
> This defect doesn't allow to monitor badblocks sysfs files from MD raid.
> They are initially empty but if data appears at some stage, userspace is
> not able to read it.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---

this patch broke userspace abi:

commit e522751d605d99a81508e58390a8f51ee96fb662
Author:     Tomasz Majchrzak <tomasz.majchrzak@intel.com>
AuthorDate: 2016-11-29 15:18:20 +0100
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: 2016-12-22 23:03:06 -0500

    seq_file: reset iterator to first record for zero offset

reported in may at:
https://bugzilla.kernel.org/show_bug.cgi?id=195697

read(fd,buf,0) on sysfs/procfs changes the behaviour of the next read:
the next read reads the first line twice.

same issue with readv() with a 0 length buffer.

test code:

#include <string.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char* argv[])
{
	char buf1[512] = {0};
	char buf2[512] = {0};
	int fd;

	fd = open("/proc/mounts", O_RDONLY);
	if (read(fd, buf1, 0) < 0) return 1;
	if (read(fd, buf1, 512) < 0) return 1;
	lseek(fd, 0, SEEK_SET);
	if (read(fd, buf2, 512) < 0) return 1;

	// buf1 should be the same as buf2,
	// the first 512 bytes of /proc/mounts

	buf1[511]=buf2[511]='\n';
	write(1, "# buf1:\n", 8);
	write(1, buf1, 512);      // prints the first line twice
	write(1, "# buf2:\n", 8);
	write(1, buf2, 512);

	return memcmp(buf1, buf2, 512) != 0;
}

stdio in musl libc can use readv with 0 length buffer in some cases,
and various tools use stdio to read these synthetic filesystems
so this is observable regression between linux v4.9 and v4.10

(i think musl can avoid the 0 length buffer in stdio, but the
linux behaviour is still incorrect. in general readv/writev could
have more posix conform behaviour on sysfs/procfs, currently they
don't behave as atomic fs operations which is surprising:
writev with several buffers behaves as if several independent write
syscalls were made instead of one, which can cause issues when users
do 'echo 12 >/proc/foo' and writev is used in the stdio implementation)


>  fs/seq_file.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -190,6 +190,13 @@ ssize_t seq_read(struct file *file, char
>  	 */
>  	m->version = file->f_version;
>  
> +	/*
> +	 * if request is to read from zero offset, reset iterator to first
> +	 * record as it might have been already advanced by previous requests
> +	 */
> +	if (*ppos == 0)
> +		m->index = 0;
> +
>  	/* Don't assume *ppos is where we left it */
>  	if (unlikely(*ppos != m->read_pos)) {
>  		while ((err = traverse(m, *ppos)) == -EAGAIN)
