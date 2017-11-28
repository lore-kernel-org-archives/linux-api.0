From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/3] y2038: rusage: use __kernel_old_timeval for process times
Date: Tue, 28 Nov 2017 11:32:06 +0100
Message-ID: <CAK8P3a3yMhMPNQS1XQB_kiyL2mV-gCPNVT+Eyr13+dwNqADr7A@mail.gmail.com>
References: <20171127170121.634826-1-arnd@arndb.de> <20171127170121.634826-3-arnd@arndb.de>
 <34369a6e-e0ce-fe7b-65e3-9c4a33e4789a@cs.ucla.edu> <87o9nnlfpq.fsf@xmission.com>
 <CAK8P3a1asMLnJtea=JkduiYzr0dF0BTKQzcx5aQVv1zU5dK2FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-87590-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAK8P3a1asMLnJtea=JkduiYzr0dF0BTKQzcx5aQVv1zU5dK2FA@mail.gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul Eggert <eggert@cs.ucla.edu>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, y2038 Mailman List <y2038@lists.linaro.org>, GNU C Library <libc-alpha@sourceware.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 9:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> One argument for using c) plus the emulation in glibc is that glibc
> has to do emulation anyway, to allow running user space with 64-bit
> time_t on older kernels that don't have the new getrusage system
> call.

To clarify my point here, if we stay with approach c), I think it should work
directly with the Albert's proposed patch "Y2038: add function
__getrusage_t64" [1], and we can remove the  "  // TODO: use
64-bit-time syscall if available" there. If we pick approach b), we
still need the same glibc patch, but would also implement the
interface to the new system call. As Eric said, this would be slightly
cleaner, but not really help us since 32-bit fields in rusage are
sufficient on the kernel interface side.

       Arnd

[1] https://patchwork.ozlabs.org/patch/811246/
