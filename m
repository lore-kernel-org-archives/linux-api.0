From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/5] fs: Convert kiocb rw_hint from enum to u16
Date: Tue, 22 May 2018 03:04:27 -0700
Message-ID: <20180522100427.GA30026@infradead.org>
References: <20180521160147.2372-1-adam.manzanares@wdc.com>
 <20180521160147.2372-3-adam.manzanares@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180521160147.2372-3-adam.manzanares@wdc.com>
Sender: owner-linux-aio@kvack.org
To: adam.manzanares@wdc.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, bcrl@kvack.org, tglx@linutronix.de, mingo@kernel.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, bigeasy@linutronix.de, jack@suse.cz, darrick.wong@oracle.com, rgoldwyn@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, May 21, 2018 at 09:01:44AM -0700, adam.manzanares@wdc.com wrote:
> From: Adam Manzanares <adam.manzanares@wdc.com>
> 
> In order to avoid kiocb bloat for per command iopriority support, rw_hint
> is converted from enum to a u16. Added a guard around ki_hint assigment.
> 
> Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
