From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v5 04/27] x86/fpu/xstate: Add XSAVES system states for
 shadow stack
Date: Thu, 8 Nov 2018 16:45:26 -0800
Message-ID: <CALCETrWbYwxDtkp7jjf=L7xFubEOP3+DuCQFHdf7bVy0MqqvXQ@mail.gmail.com>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com> <20181011151523.27101-5-yu-cheng.yu@intel.com>
 <CALCETrVAe8R=crVHoD5QmbN-gAW+V-Rwkwe4kQP7V7zQm9TM=Q@mail.gmail.com>
 <4295b8f786c10c469870a6d9725749ce75dcdaa2.camel@intel.com>
 <CALCETrUKzXYzRrWRdi8Z7AdAF0uZW5Gs7J4s=55dszoyzc29rw@mail.gmail.com>
 <043a17ef-dc9f-56d2-5fba-1a58b7b0fd4d@intel.com> <20181108220054.GP3074@bombadil.infradead.org>
 <ead230ab-a904-50d6-c4cf-46d5804f6151@intel.com> <20181109003225.GQ3074@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181109003225.GQ3074@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@c>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 8, 2018 at 4:32 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Nov 08, 2018 at 03:35:02PM -0800, Dave Hansen wrote:
> > On 11/8/18 2:00 PM, Matthew Wilcox wrote:
> > > struct a {
> > >     char c;
> > >     struct b b;
> > > };
> > >
> > > we want struct b to start at offset 8, but with __packed, it will start
> > > at offset 1.
> >
> > You're talking about how we want the struct laid out in memory if we
> > have control over the layout.  I'm talking about what happens if
> > something *else* tells us the layout, like a hardware specification
> > which is what is in play with the XSAVE instruction dictated layout
> > that's in question here.
> >
> > What I'm concerned about is a structure like this:
> >
> > struct foo {
> >         u32 i1;
> >         u64 i2;
> > };
> >
> > If we leave that to natural alignment, we end up with a 16-byte
> > structure laid out like this:
> >
> >       0-3     i1
> >       3-8     alignment gap
> >       8-15    i2
>
> I know you actually meant:
>
>         0-3     i1
>         4-7     pad
>         8-15    i2
>
> > Which isn't what we want.  We want a 12-byte structure, laid out like this:
> >
> >       0-3     i1
> >       4-11    i2
> >
> > Which we get with:
> >
> > struct foo {
> >         u32 i1;
> >         u64 i2;
> > } __packed;
>
> But we _also_ get pessimised accesses to i1 and i2.  Because gcc can't
> rely on struct foo being aligned to a 4 or even 8 byte boundary (it
> might be embedded in "struct a" from above).
>

In the event we end up with a hardware structure that has
not-really-aligned elements, I suspect we can ask gcc for a new
extension to help.  Or maybe some hack like:

struct foo {
  u32 i1;
  struct {
    u64 i2;
  } __attribute__((packed));
};

would do the trick.
