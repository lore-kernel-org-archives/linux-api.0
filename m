From: Petr Baudis <pasky@suse.cz>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Wed, 21 Jan 2009 01:11:31 +0100
Message-ID: <20090121001131.GF21648@machine.or.cz>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de> <4970DDF9.4090007@redhat.com> <49748C1B.8090205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49748C1B.8090205@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com
List-Id: linux-api@vger.kernel.org

On Mon, Jan 19, 2009 at 03:20:11PM +0100, Gerd Hoffmann wrote:
> I do see the point in adding a interface like this ...
> 
> >    ssize_t readz (int fd, void *buf, size_t len, void **res)
> 
> ... to help the kernel do zero-copy I/O.
> 
> I think system calls for vector I/O are *not* the right place for that
> though.  Usually applications use vectored I/O because they *do* care
> about the place the data is stored, because vectored I/O allows them to
> avoid copying data within the application.

Can you elaborate on this? An application would have to have quite a
contrived design if its pointers simply cannot be updated according
to what the kernel returns.

Then again, I'm not sure why wouldn't readv() actually be
zerocopy-ready. Just make sure you handle iov_base being NULL gracefully
now (EINVAL, with the remark that the kernel can write to the iovec
memory area in the future) and later the kernel can in that case set
iov_base to the buffer location?

-- 
				Petr "Pasky" Baudis
The average, healthy, well-adjusted adult gets up at seven-thirty
in the morning feeling just terrible. -- Jean Kerr
