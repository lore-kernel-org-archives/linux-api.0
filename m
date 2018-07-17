From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/17] y2038: Remove newstat family from default
 syscall set
Date: Tue, 17 Jul 2018 05:50:39 -0700
Message-ID: <20180717125039.GB25416@infradead.org>
References: <20180716161103.16239-1-arnd@arndb.de>
 <20180716161103.16239-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180716161103.16239-3-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: tglx@linutronix.de, y2038@lists.linaro.org, hch@infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, libc-alpha@sourceware.org, albert.aribaud@3adev.fr, netdev@vger.kernel.org, viro@zeniv.linux.org.uk, peterz@infradead.org, dvhart@infradead.org, ebiederm@xmission.com, linux@dominikbrodowski.net
List-Id: linux-api@vger.kernel.org

On Mon, Jul 16, 2018 at 06:10:48PM +0200, Arnd Bergmann wrote:
> We have four generations of stat() syscalls:
> - the oldstat syscalls that are only used on the older architectures
> - the newstat family that is used on all 64-bit architectures but
>   lacked support for large files on 32-bit architectures.
> - the stat64 family that is used mostly on 32-bit architectures to
>   replace newstat
> - statx() to replace all of the above, adding 64-bit timestamps among
>   other things.
> 
> We already compile stat64 only on those architectures that need it,
> but newstat is always built, including on those that don't reference
> it. This adds a new __ARCH_WANT_NEW_STAT symbol along the lines of
> __ARCH_WANT_OLD_STAT and __ARCH_WANT_STAT64 to control compilation of
> newstat. All architectures that need it use an explict define, the
> others now get a little bit smaller, and future architecture (including
> 64-bit targets) won't ever see it.
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Do I read this right that you only want to provide statx by default?
It is a little different from the traditional stat calls, so I'd like
to know this is actually ok from libc folks first.
