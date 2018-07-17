From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 05/17] asm-generic: Remove empty asm/unistd.h
Date: Tue, 17 Jul 2018 05:51:21 -0700
Message-ID: <20180717125121.GD25416@infradead.org>
References: <20180716161103.16239-1-arnd@arndb.de>
 <20180716161103.16239-6-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180716161103.16239-6-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: tglx@linutronix.de, y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net
List-Id: linux-api@vger.kernel.org

On Mon, Jul 16, 2018 at 06:10:51PM +0200, Arnd Bergmann wrote:
> Nothing is left in asm/unistd.h except for the redirect to
> uapi/asm/unistd.h, so removing the file simply leads to that one being
> used directly.  The linux/export.h inclusion is a leftover from commit
> e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations")
> and should not be used anyway.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
