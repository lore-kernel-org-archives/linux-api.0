From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] x86: Deprecate a.out support
Date: Sun, 10 Mar 2019 23:19:15 +0000
Message-ID: <20190310231915.GG2217@ZenIV.linux.org.uk>
References: <20190305122218.GD13380@bombadil.infradead.org>
 <20190305134347.4be2449c@alans-desktop>
 <20190305145717.GD8256@zn.tnic>
 <CAHk-=wi2E4kugAW7BQwNSVwYHOr=B_9EgzBRMpQ2+1dxAqydDg@mail.gmail.com>
 <20190305173134.GE8256@zn.tnic>
 <CAHk-=wg0bY=RFhD4NW9x++fC0bME=_-9xM3kexGGM3gefHQTyQ@mail.gmail.com>
 <20190305181138.GG8256@zn.tnic>
 <20190305181808.GH8256@zn.tnic>
 <CAEdQ38G5M3vq9pGBV1iyEViO7JhFuXk5g+VCs-vUH+Z62kNqgQ@mail.gmail.com>
 <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgt7M6yA5BJCJo0nF22WgPJnN8CvViL9CAJmd+S+Civ6w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, linux-alpha <linux-alpha@vger.kernel.org>, linux-m68k@lists.linux-m68k.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 10, 2019 at 03:40:20PM -0700, Linus Torvalds wrote:
>  SYSCALL_DEFINE3(osf_readv, unsigned long, fd,
>  		const struct iovec __user *, vector, unsigned long, count)
>  {
> -#ifdef CONFIG_OSF4_COMPAT
> -	if (unlikely(personality(current->personality) == PER_OSF4))
> -		if (osf_fix_iov_len(vector, count))
> -			return -EFAULT;
> -#endif
> -
>  	return sys_readv(fd, vector, count);
>  }
>  
>  SYSCALL_DEFINE3(osf_writev, unsigned long, fd,
>  		const struct iovec __user *, vector, unsigned long, count)
>  {
> -#ifdef CONFIG_OSF4_COMPAT
> -	if (unlikely(personality(current->personality) == PER_OSF4))
> -		if (osf_fix_iov_len(vector, count))
> -			return -EFAULT;
> -#endif
>  	return sys_writev(fd, vector, count);
>  }

Might as well kill those two off, while we are at it - just use sys_readv/sys_writev
in arch/alpha/kernel/syscalls/syscall.tbl and be done with that...
