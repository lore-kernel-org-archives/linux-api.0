From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] aio: implement io_pgetevents
Date: Sun, 8 Jul 2018 22:44:00 +0200
Message-ID: <20180708204359.GA19198@lst.de>
References: <20180502211448.18276-1-hch@lst.de> <20180502211448.18276-8-hch@lst.de> <20180704142116.GM17048@lisas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180704142116.GM17048@lisas.de>
Sender: owner-linux-aio@kvack.org
To: Adrian Reber <adrian@lisas.de>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 04, 2018 at 04:21:16PM +0200, Adrian Reber wrote:
> In file included from /usr/include/linux/signal.h:5,
>                  from /usr/include/linux/aio_abi.h:32,
>                  from include.c:2:
> /usr/include/asm/signal.h:16:23: error: conflicting types for ‘sigset_t’
>  typedef unsigned long sigset_t;
>                        ^~~~~~~~
> In file included from /usr/include/signal.h:35,
>                  from include.c:1:
> /usr/include/bits/types/sigset_t.h:7:20: note: previous declaration of ‘sigset_t’ was here
>  typedef __sigset_t sigset_t;

I guess we could do something like the patch below, although it is
rather ugly:

diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index 75846164290e..b7705ad66d78 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -29,7 +29,11 @@
 
 #include <linux/types.h>
 #include <linux/fs.h>
+#ifdef __KERNEL__
 #include <linux/signal.h>
+#else
+#include <signal.h>
+#endif
 #include <asm/byteorder.h>
 
 typedef __kernel_ulong_t aio_context_t;

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
