From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/8] asm-generic: Make time32 syscall numbers optional
Date: Tue, 19 Feb 2019 21:29:01 +0100
Message-ID: <CAK8P3a0UD7_omc4=o7VLaLKUX4Z1eWXU15TeqgvjXfhyv+7xCA@mail.gmail.com>
References: <20190218210712.3503891-1-arnd@arndb.de> <20190218210712.3503891-5-arnd@arndb.de>
 <CAMuHMdVbz=_GFMnKx4PuxpmG9jpdA=Do2XnR3bY5wRZPM3G+Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVbz=_GFMnKx4PuxpmG9jpdA=Do2XnR3bY5wRZPM3G+Gw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linux-Arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yury Norov <yury.norov@gmail.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>, "moderated list:H8/300 ARCHITECTURE" <uclinux-h8-devel@lists.sourceforge.jp>, Stafford Horne <shorne@gmail.com>, Vineet Gupta <vgupta@synopsys.com>, Palmer Dabbelt <palmer@sifive.com>, Guo Ren <guoren@kernel.org>, Greentime Hu <green.hu@gmail.com>, linux-riscv@lists.infradead.org, Guan Xuetao <gxt@pku.edu.cn>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 19, 2019 at 9:06 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Arnd,
>
> On Tue, Feb 19, 2019 at 3:34 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > We don't want new architectures to even provide the old 32-bit time_t
> > based system calls any more, or define the syscall number macros.
> >
> > Add a new __ARCH_WANT_TIME32_SYSCALLS macro that gets enabled for all
> > existing 32-bit architectures so we don't change any current behavior.
>
> ... (only) 32-bit architectures using the generic syscall list, right?

Correct, I've added a clarification in the commit text in my git tree now,
thanks for the proofreading!

       Arnd
