From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Mon, 19 Jan 2009 15:20:11 +0100
Message-ID: <49748C1B.8090205@redhat.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de> <4970DDF9.4090007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <4970DDF9.4090007@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Ulrich Drepper <drepper@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com
List-Id: linux-api@vger.kernel.org

Ulrich Drepper wrote:
> If they are in the kernel there is no reason not to export them from
> glibc.

Great.

> But I have a general comment about all kinds of read syscalls.
> If think they have been misdesigned from day one and if we are going to
> add new ones we might want to fix them.
> 
> The problem is that they don't allow for zero-copy operations in enough
> cases.  The kernel is not free to store the data wherever it wants even
> if the userlevel code is fine with that.

[ ... more text snipped ... ]

I do see the point in adding a interface like this ...

>    ssize_t readz (int fd, void *buf, size_t len, void **res)

... to help the kernel do zero-copy I/O.

I think system calls for vector I/O are *not* the right place for that
though.  Usually applications use vectored I/O because they *do* care
about the place the data is stored, because vectored I/O allows them to
avoid copying data within the application.

cheers,
  Gerd
