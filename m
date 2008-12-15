From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Mon, 15 Dec 2008 12:02:04 -0800 (PST)
Message-ID: <20081215.120204.257704544.davem@davemloft.net>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
	<20081215160311.GA23153@linux-mips.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20081215160311.GA23153@linux-mips.org>
Sender: linux-arch-owner@vger.kernel.org
To: ralf@linux-mips.org
Cc: kraxel@redhat.com, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 15 Dec 2008 16:03:11 +0000

> On Mon, Dec 15, 2008 at 12:36:14PM +0100, Gerd Hoffmann wrote:
> 
> > Next revision of the patch series, with the alignment issue fixed by
> > swapping the last two arguments as suggested by arch maintainers.
> > 
> > I've dropped the now-obsolete wrappers for mips.  Ralf, please
> > double-check.
> 
> It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
> will pass the 64-bit argument in two registers but the 64-bit kernel code
> will assume it to be passed in a single registers.

Same on 32-bit sparc, and I assume 32-bit powerpc as well.

> I'm surprised this works for x86; does x86-64 code really expect 64-bit
> arguments as 2 32-bit arguments?

Args get pushed onto the stack, so perhaps it works by accident :)
