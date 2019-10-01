From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC][PATCH] sysctl: Remove the sysctl system call
Date: Tue, 1 Oct 2019 11:46:45 -0700
Message-ID: <201910011140.EA0181F13@keescook>
References: <8736gcjosv.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8736gcjosv.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, Cong Wang <xiyou.wangcong@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Alex Smith <alex.smith@imgtec.com>, Anders Berg <anders.berg@lsi.com>, Apelete Seketeli <apelete@seketeli.net>, Arnd Bergmann <arnd@arndb.de>, Chee Nouk Phoon <cnphoon@altera.com>, Chris Zankel <chris@zankel.net>, Christian Ruppert <christian.ruppert@abilis.com>, Greg Ungerer <gerg@uclinux.org>, Harvey Hunt <harvey.hunt@imgtec.com>, Helge Deller <deller@gmx.de>, Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>, Huacai Chen <chenhc@lemote.com>, John Crispin <blo>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 01, 2019 at 01:36:32PM -0500, Eric W. Biederman wrote:
> 
> This system call has been deprecated almost since it was introduced, and
> in a survey of the linux distributions I can no longer find any of them
> that enable CONFIG_SYSCTL_SYSCALL.  The only indication that I can find
> that anyone might care is that a few of the defconfigs in the kernel
> enable CONFIG_SYSCTL_SYSCALL.  However this appears in only 31 of 414
> defconfigs in the kernel, so I suspect this symbols presence is simply
> because it is harmless to include rather than because it is necessary.
> 
> As there appear to be no users of the sysctl system call, remove the
> code.  As this removes one of the few uses of the internal kernel mount
> of proc I hope this allows for even more simplifications of the proc
> filesystem.

I'm for it. :) I tripped over this being deprecated over a decade ago. :P

I think you can actually take this further and remove (or at least
empty) the uapi/linux/sysctl.h file too.

-- 
Kees Cook
