From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 2/3] fs: Convert kiocb rw_hint from enum to u16
Date: Fri, 18 May 2018 09:05:12 -0700
Message-ID: <20180518160512.GG22791@infradead.org>
References: <20180517203803.2664-1-adam.manzanares@wdc.com>
 <20180517203803.2664-3-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180517203803.2664-3-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org, mingo@kernel.org, peterz@infradead.org, pombredanne@nexb.com, gregkh@linuxfoundation.org, bigeasy@linutronix.de, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> +/* ki_hint changed from enum to u16, make sure rw_hint fits into u16 */

I don't think this comment is very useful.

> +static inline u16 ki_hint_valid(enum rw_hint hint)

I'd call this ki_hint_validate.

> +{
> +	if (hint > MAX_KI_HINT)
> +		return 0;
> +
> +	return hint;

Nit: kill the empty line.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
