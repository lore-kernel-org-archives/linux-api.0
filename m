From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 00/15] arch: synchronize syscall tables in preparation for
 y2038
Date: Fri, 11 Jan 2019 09:07:43 +0100
Message-ID: <CAMuHMdUpThq_fmSitzUrEUFx40itYdURpjmunLs_YLA9BPaMQg@mail.gmail.com>
References: <20190110162435.309262-1-arnd@arndb.de>
 <CAMuHMdXYP3=TRHYqddVRfbRRaj_Ou=wfoX6ohKM7XNAx-c2RXw@mail.gmail.com>
 <CAK8P3a0kmr2ju+sZE+f-+=-2t5Eu+t-DS-+r6OKrPVTAxHwf8w@mail.gmail.com>
 <CAMuHMdVpUNUx-wdDYChYNzMYqYi79w5tzjk5x3JskdS88VQCQw@mail.gmail.com>
 <CAK8P3a07yNiadLCJcA0Tyfo90YeQ0P2XF-wOEy9XAb8cDTFObw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAK8P3a07yNiadLCJcA0Tyfo90YeQ0P2XF-wOEy9XAb8cDTFObw@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rich Felker <dalias@libc.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, Linux-sh list <linux-sh@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Firoz Khan <firoz.khan@linaro.org>, Matt Turner <mattst88@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, Will Deacon <will.deacon@a>
List-Id: linux-api@vger.kernel.org

Hi Arnd,

On Thu, Jan 10, 2019 at 11:43 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Thu, Jan 10, 2019 at 7:11 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Jan 10, 2019 at 6:06 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Thu, Jan 10, 2019 at 5:59 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > On Thu, Jan 10, 2019 at 5:26 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > > The system call tables have diverged a bit over the years, and a number
> > > > > of the recent additions never made it into all architectures, for one
> > > > > reason or another.
> > > > >
> > > > > This is an attempt to clean it up as far as we can without breaking
> > > > > compatibility, doing a number of steps:
> > > >
> > > > Thanks a lot!
> > > >
> > > > > - Add system calls that have not yet been integrated into all
> > > > >   architectures but that we definitely want there.
> > > >
> > > > It looks like you missed wiring up io_pgetevents() on m68k.
> > > > Is that intentional?
> > >
> > > Yes, I thought I had described that somewhere but maybe I
> > > forgot: semtimedop() and io_pgetevents() get replaced with
> > > time64 versions in the follow-up, so I only added them in
> > > 64-bit architectures. If you think we should have both
> > > io_pgetevents() and io_pgetevents_time32() on all 32-bit
> > > architectures, I can add that as well.
> >
> > Thanks, sounds fine to me.
>
> Just to be sure, you mean it's fine to not add it, not that we should
> add it?

I'm fine with not having the legacy 32-bit ones.

Sorry for being unclear.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
