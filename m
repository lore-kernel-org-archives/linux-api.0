From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] asm-generic: syscall table script for arch/sh
Date: Thu, 20 Dec 2018 23:06:59 -0800
Message-ID: <20181221070659.GA32300@infradead.org>
References: <CAK8P3a3iAF3J8X2yj7JaCaTM_BcZ--2LZj32kkDf55mBn_cQ5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3iAF3J8X2yj7JaCaTM_BcZ--2LZj32kkDf55mBn_cQ5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Firoz Khan <firoz.khan@linaro.org>, Linux API <linux-api@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-sh list <linux-sh@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>
List-Id: linux-api@vger.kernel.org

> The conversion does not include the old 64-bit sh5 architecture, which
> has never shipped and not even compiled in a long time.

Maybe it is time to drop the code for it then?
