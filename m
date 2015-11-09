From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 00/20] Fix handling of compat_siginfo_t
Date: Mon, 9 Nov 2015 16:12:04 +0100
Message-ID: <20151109151204.GA10760@redhat.com>
References: <1446684640-4112-1-git-send-email-amanieu@gmail.com> <CALCETrWKK_REdX7TJO8X7jC=8k=YdgJH_txXpC4Pdzn-tukg5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWKK_REdX7TJO8X7jC=8k=YdgJH_txXpC4Pdzn-tukg5A@mail.gmail.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Amanieu d'Antras <amanieu@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, sparclinux@vger.kernel.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kenton Varda <kenton@sandstorm.io>
List-Id: linux-api@vger.kernel.org

On 11/07, Andy Lutomirski wrote:
>
> On Wed, Nov 4, 2015 at 4:50 PM, Amanieu d'Antras <amanieu@gmail.com> wrote:
> > One issue that isn't resolved in this series is sending signals between a 32-bit
> > process and 64-bit process. Sending a si_int will work correctly, but a si_ptr
> > value will likely get corrupted due to the different layouts of the 32-bit and
> > 64-bit siginfo_t structures.
>
> This is so screwed up it's not even funny.

Agreed,

> A 64-bit big-endian compat calls rt_sigqueueinfo.  It passes in (among
> other things) a sigval_t.  The kernel can choose to interpret it

I always thought that the kernel should not interpret it at all. And indeed,
copy_siginfo_to_user() does

	if (from->si_code < 0)
		return __copy_to_user(to, from, sizeof(siginfo_t))

probably copy_siginfo_to_user32() should do something similar, at least
it should not truncate ->si_code it it is less than zero.

Not sure what signalfd_copyinfo() should do.

But perhaps I was wrong, I failed to find man sigqueueinfo, and man
sigqueue() documents that it passes sigval_t.


> BTW, x86 has its own set of screwups here.  Somehow cr2 and error_code
> ended up as part of ucontext instead of siginfo, which makes
> absolutely no sense to me and bloats task_struct.

Yes, and probably ->ip should have been the part of siginfo too. Say,
if you get SIGBUS you can't trust sc->ip if another signal was dequeued
before SIGBUS, in this case sc->ip will point to the handler of that
another signal. That is why we have SYNCHRONOUS_MASK and it helps, but
still this doesn't look nice.

Oleg.

