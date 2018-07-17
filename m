From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFC] y2038: globally rename compat_time to old_time32
Date: Tue, 17 Jul 2018 18:16:44 +0200
Message-ID: <CAK8P3a3suHZo25uNKnWRz3MLJOFTBRwixTfTW7fSxG2CNoU-NA@mail.gmail.com>
References: <20180713133204.3123939-1-arnd@arndb.de> <CABeXuvphoYM+KOGPgtsuxzS1_XDSOO0Ta5hr3sA7gYtt-78wtQ@mail.gmail.com>
 <CAK8P3a2xu4KGVM1BvTjtXKHfXpBQ2PMynAPybW4cRt7FB8ktwg@mail.gmail.com> <20180717125855.GA3681@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717125855.GA3681@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, y2038 Mailman List <y2038@lists.linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, alsa-devel@alsa-project.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 17, 2018 at 2:58 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Jul 16, 2018 at 12:11:53PM +0200, Arnd Bergmann wrote:
>> I don't think it makes a big difference whether we change it now or later,
>> but if Christoph feels that it addresses his concern about the compat_
>> namespace being reused during the transition, doing it earlier would
>> enable us to finish the remaining syscalls.
>
> Yes, I've been looking at your new series and the reuse of compat_*
> is really confusing

Ok, let's do that then. Do you think it's sufficient to change it on top
of the existing patch series? While I can rebase everything on top of
the rename, the header file dependencies are a bit tricky and adding
a patch at the end would make it easier to ensure that I don't
introduce any bisection issues.

       Arnd
