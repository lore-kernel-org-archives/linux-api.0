From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] fs: Add aio iopriority support for block_dev
Date: Thu, 3 May 2018 11:33:53 -0700
Message-ID: <20180503183353.GC1562@bombadil.infradead.org>
References: <20180503182114.2797-1-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180503182114.2797-1-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 03, 2018 at 11:21:14AM -0700, adam.manzanares@wdc.com wrote:
> If we want to avoid bloating struct kiocb, I suggest we turn the private field 
> into a union of the private and ki_ioprio field. It seems like the users of 
> the private field all use it at a point where we can yank the priority from 
> the kiocb before the private field is used. Comments and suggestions welcome.

Or we could just make ki_hint a u8 or u16 ... seems unlikely we'll need
32 bits of ki_hint.  (currently defined values are 1-5)

> @@ -300,6 +301,7 @@ struct kiocb {
>  	void			*private;
>  	int			ki_flags;
>  	enum rw_hint		ki_hint;
> +	u16			ki_ioprio; /* See linux/ioprio.h */
>  } __randomize_layout;
>  
>  static inline bool is_sync_kiocb(struct kiocb *kiocb)

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
