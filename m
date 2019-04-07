From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v13 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Sun, 7 Apr 2019 10:34:33 -0700
Message-ID: <CALCETrVhpqZiBe6zvK+z6HmD9AhK_O_O=2H=PYzBHid4C=SMYQ@mail.gmail.com>
References: <20190224044400.34975-1-aubrey.li@linux.intel.com> <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Aubrey Li <aubrey.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, aubrey.li@intel.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 5, 2019 at 12:32 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Sun, 24 Feb 2019, Aubrey Li wrote:
>
> > The architecture specific information of the running processes could
> > be useful to the userland. Add support to examine process architecture
> > specific information externally.
> >
> > Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: Tim Chen <tim.c.chen@linux.intel.com>
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
>
> This really lacks
>
> Cc: Linux API <linux-api@vger.kernel.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
>
> Cc'ed now.
>

I certainly understand why you want to expose this info, but would it
make more sense to instead add an arch_status file in /proc with
architecture-specific info?  Or maybe an x86_status field for x86
status, etc.
