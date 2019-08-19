From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 23/36] x86/vdso: Allocate timens vdso
Date: Mon, 19 Aug 2019 16:44:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908191639320.2147@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-24-dima@arista.com> <b719199a-ed91-610b-38bc-015a0749f600@kernel.org> <alpine.DEB.2.21.1908162208190.1923@nanos.tec.linutronix.de> <483678c7-7687-5445-f09e-e45e9460d559@gmail.com>
 <alpine.DEB.2.21.1908171709360.1923@nanos.tec.linutronix.de> <37f08bfa-0ef8-6df9-e119-e010cdeb9a5a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <37f08bfa-0ef8-6df9-e119-e010cdeb9a5a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Dmitry,

On Mon, 19 Aug 2019, Dmitry Safonov wrote:
> On 8/18/19 5:21 PM, Thomas Gleixner wrote:
> > That means your timens_to_host() and host_to_timens() conversion functions
> > should just use that special VDSO page and do the same array based
> > unconditional add/sub of the clock specific offset.
> 
> I was a bit scarred that clock_mode change would result in some complex
> logic, but your patch showed me that it's definitely not so black as I
> was painting it.

Right. It took me a while to find the right spot which does not affect the
non-timens path and at the same time gives a reasonable result for the
timens case.

One thing occured to me while doing that vvar_fault() hack for testing. For
the timens case it will hit

     if (sym_offset == image->sym_vvar_page) {

first, which is then installing the special vvar page.

It's clear that the code will hit the next fault immediately when trying to
access the real vvar page at the timens offset. So it might be sensible to
map that one in one go to avoid the immediate second page fault. But that
should be a separate patch after the initial 'functional' one.

Thanks,

	tglx
