From: Rich Felker <dalias@libc.org>
Subject: Re: Re: [(resend)] seq_file: reset iterator to first record
 for zero offset
Date: Thu, 9 Nov 2017 20:14:19 -0500
Message-ID: <20171110011419.GP1627@brightrain.aerifal.cx>
References: <20161219113800.GE27207@veci.piliscsaba.szeredi.hu>
 <20171108131005.GA15263@port70.net>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <musl-return-12086-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20171108131005.GA15263@port70.net>
Sender: Rich Felker <dalias@aerifal.cx>
To: Szabolcs Nagy <nsz@port70.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On Wed, Nov 08, 2017 at 02:10:05PM +0100, Szabolcs Nagy wrote:
> * Miklos Szeredi <miklos@szeredi.hu> [2016-12-19 12:38:00 +0100]:
> > Al,
> > 
> > Can you please take (or NACK) this patch please?
> > 
> > Thanks,
> > Miklos
> > ---
> > From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> > Date: Tue, 29 Nov 2016 15:18:20 +0100
> > 
> > If kernfs file is empty on a first read, successive read operations
> > using the same file descriptor will return no data, even when data is
> > available. Default kernfs 'seq_next' implementation advances iterator
> > position even when next object is not there. Kernfs 'seq_start' for
> > following requests will not return iterator as position is already on
> > the second object.
> > 
> > This defect doesn't allow to monitor badblocks sysfs files from MD raid.
> > They are initially empty but if data appears at some stage, userspace is
> > not able to read it.
> > 
> > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > ---
> 
> this patch broke userspace abi:
> 
> commit e522751d605d99a81508e58390a8f51ee96fb662

Thanks for reporting this!

> Author:     Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> AuthorDate: 2016-11-29 15:18:20 +0100
> Commit:     Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: 2016-12-22 23:03:06 -0500
> 
>     seq_file: reset iterator to first record for zero offset
> 
> reported in may at:
> https://bugzilla.kernel.org/show_bug.cgi?id=195697
> 
> read(fd,buf,0) on sysfs/procfs changes the behaviour of the next read:
> the next read reads the first line twice.
> 
> same issue with readv() with a 0 length buffer.
> 
> test code:
> 
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> 
> int main(int argc, char* argv[])
> {
> 	char buf1[512] = {0};
> 	char buf2[512] = {0};
> 	int fd;
> 
> 	fd = open("/proc/mounts", O_RDONLY);
> 	if (read(fd, buf1, 0) < 0) return 1;
> 	if (read(fd, buf1, 512) < 0) return 1;
> 	lseek(fd, 0, SEEK_SET);
> 	if (read(fd, buf2, 512) < 0) return 1;
> 
> 	// buf1 should be the same as buf2,
> 	// the first 512 bytes of /proc/mounts
> 
> 	buf1[511]=buf2[511]='\n';
> 	write(1, "# buf1:\n", 8);
> 	write(1, buf1, 512);      // prints the first line twice
> 	write(1, "# buf2:\n", 8);
> 	write(1, buf2, 512);
> 
> 	return memcmp(buf1, buf2, 512) != 0;
> }
> 
> stdio in musl libc can use readv with 0 length buffer in some cases,
> and various tools use stdio to read these synthetic filesystems
> so this is observable regression between linux v4.9 and v4.10
> 
> (i think musl can avoid the 0 length buffer in stdio, but the
> linux behaviour is still incorrect. in general readv/writev could
> have more posix conform behaviour on sysfs/procfs, currently they
> don't behave as atomic fs operations which is surprising:
> writev with several buffers behaves as if several independent write
> syscalls were made instead of one, which can cause issues when users
> do 'echo 12 >/proc/foo' and writev is used in the stdio implementation)

Formally, readv is specified to behave as if it does one read of size
matching the total size of the iovecs. Currently Linux tty devices and
procfs files behave nonconformingly in that the iovecs get treated
like separate read calls. musl works around the issue this causes with
ttys, and probably could work around this issue with procfs too (by
collapsing out the zero-length iovec), but it's a regression breaking
a lot of existing binaries out there and I think it needs to be fixed.

Rich
