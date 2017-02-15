From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] ioctl_list.2: BLKRASET/BLKRAGET take unsigned long
Date: Wed, 15 Feb 2017 12:22:05 +0100
Message-ID: <20170215112205.GA27269@rei.lan>
References: <20170215112015.GA27080@rei.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170215112015.GA27080-2UyX9mZUyMU@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[CCing linux api as well]
> The BLKRASET/BLKRAGET ioctls() take unsigned long, if I pass int * to
> the BLKRAGET ioctl on x86_64 (or on any other arch where sizeof(int) !=
> sizeof(long)) the BLKRAGET ioctl will rewrite four bytes on the stack.
> 
> If you look at block/ioctl.c in kernel sources you can clearly see that
> BLKRAGET ioctl calls put_long().
> 
> Compile following reproducer and run it as ./a.out /dev/sda, you can see
> that the second member of the array will be zeroed. If you change the
> array to have only one member you will see stack smashing trace.
> 
> I also wonder if it's OK to pass int value to ioctl() at all, the arg
> value seems to be unsigned long in the syscall definition in fs/ioctl.c
> and there does not seem to be any glibc magic around the syscall.
> 
> -------------------------8<----------------------------
> #include <sys/mount.h>
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <stdio.h>
> 
> static int fd;
> 
> int main(int argc, char *argv[])
> {
> 	int ra[] = {100, 100};
> 
> 	fd = open(argv[1], O_RDONLY);
> 	if (fd < 0) {
> 		perror("open");
> 		return 1;
> 	}
> 
> 	ioctl(fd, BLKRAGET, ra);
> 
> 	fprintf(stderr, "%i %i\n", ra[0], ra[1]);
> 
> 	return 0;
> }
> 
> -------------------------8<----------------------------
> 
> Signed-off-by: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
> ---
>  man2/ioctl_list.2 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/man2/ioctl_list.2 b/man2/ioctl_list.2
> index 0165c77..c8efd66 100644
> --- a/man2/ioctl_list.2
> +++ b/man2/ioctl_list.2
> @@ -311,8 +311,8 @@ l l l l.
>  0x0000125F	BLKRRPART	void
>  0x00001260	BLKGETSIZE	unsigned long *
>  0x00001261	BLKFLSBUF	void
> -0x00001262	BLKRASET	int
> -0x00001263	BLKRAGET	int *
> +0x00001262	BLKRASET	unsigned long
> +0x00001263	BLKRAGET	unsigned long *
>  0x00000001	FIBMAP	int *	// I-O
>  0x00000002	FIGETBSZ	int *
>  0x80086601	FS_IOC_GETFLAGS	int *
> -- 
> 2.10.2
> 
> 
> -- 
> Cyril Hrubis
> chrubis-AlSwsSmVLrQ@public.gmane.org

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
