From: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Tue, 16 Dec 2008 12:02:09 -0500
Message-ID: <20081216170209.GC410@bombadil.infradead.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org> <4946C4B4.1020605@redhat.com> <20081216160502.GA15331@linux-mips.org> <4947DBFA.9050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4947DBFA.9050108@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 16, 2008 at 05:48:58PM +0100, Gerd Hoffmann wrote:
> i.e. the ordering of the splitted argument depends on the os endianness?
> What is the reason for this?
> 

Eh? The splitting will occur at the C ABI level, not as a result of
glibc (though, it could be done that way if you really wanted, but then
you're just moving the wrapper up the chain.)

A 64-bit value on a 32-bit machine will look like, in a register pair,
like it looks in memory, with MSB/LSB ordering.

> I'd prefer to have the ordering coded explicitly instead, like this:
> 
> asmlinkage int compat_sys_pwritev(unsigned long fd,
>        const struct compat_iovec __user *vec, unsigned long vlen,
>        unsigned pos_low, unsigned pos_high)
> {
> 	loff_t pos = pos_low | (loff_t)pos_high << 32;
>         [ ... ]
> 

Sadly this isn't possible without a wrapper unless you can guarantee
it was passed low high instead of high low. Unless you munge it in
userspace, you can't.

regards, Kyle
