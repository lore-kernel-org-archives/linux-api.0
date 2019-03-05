From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: a.out coredumping: fix or delete?
Date: Tue, 5 Mar 2019 13:43:47 +0000
Message-ID: <20190305134347.4be2449c@alans-desktop>
References: <CAG48ez1RVd5mQ_Pb6eygQESaZhpQz765OAZYSoPE0kPqfZEXQg@mail.gmail.com>
        <20190305091904.GB8256@zn.tnic>
        <20190305122218.GD13380@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190305122218.GD13380@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Jann Horn <jannh@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

> It's been 25 years since Linux added support for ELF.  Can we just
> delete the a.out support entirely now?  According to the Linux-ELF HOWTO,
> support was added in 1.1.52 (August 1994).  It's pretty much necromancy
> at this point.

In the unlikely event that someone actually has an a.out binary they
can't live with they can also just write an a.out loader as an ELF
program entirely in userspace.

I'd vote for giving it the boot unless there are any architectures that
kept using a.out far longer due to tool chain issues ?

Alan
