From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Mon, 9 Jul 2018 22:11:42 -0700
Message-ID: <20180710051141.GB21096@outlook.office365.com>
References: <20180502211448.18276-1-hch@lst.de>
 <20180502211448.18276-8-hch@lst.de>
 <20180704142116.GM17048@lisas.de>
 <20180708204359.GA19198@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180708204359.GA19198@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Adrian Reber <adrian@lisas.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Jul 08, 2018 at 10:44:00PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 04, 2018 at 04:21:16PM +0200, Adrian Reber wrote:
> > In file included from /usr/include/linux/signal.h:5,
> >                  from /usr/include/linux/aio_abi.h:32,
> >                  from include.c:2:
> > /usr/include/asm/signal.h:16:23: error: conflicting types for ‘sigset_t’
> >  typedef unsigned long sigset_t;
> >                        ^~~~~~~~
> > In file included from /usr/include/signal.h:35,
> >                  from include.c:1:
> > /usr/include/bits/types/sigset_t.h:7:20: note: previous declaration of ‘sigset_t’ was here
> >  typedef __sigset_t sigset_t;
> 
> I guess we could do something like the patch below, although it is
> rather ugly:
> 
> diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
> index 75846164290e..b7705ad66d78 100644
> --- a/include/uapi/linux/aio_abi.h
> +++ b/include/uapi/linux/aio_abi.h
> @@ -29,7 +29,11 @@
>  
>  #include <linux/types.h>
>  #include <linux/fs.h>
> +#ifdef __KERNEL__
>  #include <linux/signal.h>
> +#else
> +#include <signal.h>
> +#endif

I think we can not do this because this header specifies the kernel
API, but signal.h is provided by libc and sigset_t can be defined
differently there:

[avagin@laptop ~]$ cat test.c 
#ifdef TEST_LINUX_SIGNAL
#  include <glob.h>
#  include <linux/signal.h>
#else
#  include <signal.h>
#endif
#include <stdio.h>
int main()
{
	printf("sizeof(sigset_t) = %d\n", sizeof(sigset_t));
	return 0;
}
[avagin@laptop ~]$ gcc -DTEST_LINUX_SIGNAL test.c && ./a.out
sizeof(sigset_t) = 8
[avagin@laptop ~]$ gcc test.c && ./a.out
sizeof(sigset_t) = 128

[avagin@laptop include]$ rpm -qf /usr/include/signal.h 
glibc-headers-2.27-8.fc28.i686
glibc-headers-2.27-8.fc28.x86_64
[avagin@laptop include]$ rpm -qf /usr/include/linux/signal.h 
kernel-headers-4.16.5-300.fc28.x86_64

>  #include <asm/byteorder.h>
>  
>  typedef __kernel_ulong_t aio_context_t;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
