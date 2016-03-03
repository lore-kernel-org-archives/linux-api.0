From: Christoph Hellwig <hch@lst.de>
Subject: Re: selective block polling and preadv2/pwritev2 revisited V3
Date: Thu, 3 Mar 2016 17:11:40 +0100
Message-ID: <20160303161140.GA26015@lst.de>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <56D853B5.9000906@dev.mellanox.co.il> <20160303151116.GA24614@lst.de> <2369295.6CpmrvqZVS@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2369295.6CpmrvqZVS@wuerfel>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, viro@zeniv.linux.org.uk, axboe@fb.com, milosz@adfin.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 03, 2016 at 04:52:55PM +0100, Arnd Bergmann wrote:
> If we decide to revise the asm-generic/unistd.h system call list
> for future architecture ports, can the syscalls replace all of
> read/write/readv/writev/pread64/write64/preadv/pwritev, or would
> it be better to keep all of them around indefinitely?

It does replace all off them fully.  I never quite understood
why having the wrappers is better in libc than the kernel, though.
