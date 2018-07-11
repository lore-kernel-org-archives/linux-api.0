From: Yu-cheng Yu <yu-cheng.yu@intel.com>
Subject: Re: [RFC PATCH v2 05/27] Documentation/x86: Add CET description
Date: Wed, 11 Jul 2018 07:53:37 -0700
Message-ID: <1531320817.13297.1.camel@intel.com>
References: <20180710222639.8241-1-yu-cheng.yu@intel.com>
         <20180710222639.8241-6-yu-cheng.yu@intel.com>
         <ae3e2013-9c90-af39-f9da-278bf7af6f73@redhat.com>
         <CAMe9rOqo3ZSMuwNZf8HbrL72OY1aQ0S0Huwqj7rsVY9_ZOfF_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMe9rOqo3ZSMuwNZf8HbrL72OY1aQ0S0Huwqj7rsVY9_ZOfF_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H.J. Lu" <hjl.tools@gmail.com>, Florian Weimer <fweimer@redhat.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromiun.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Machek <pavel@ucw.cz>Peter
List-Id: linux-api@vger.kernel.org

On Wed, 2018-07-11 at 06:47 -0700, H.J. Lu wrote:
> On Wed, Jul 11, 2018 at 2:57 AM, Florian Weimer <fweimer@redhat.com>
> wrote:
> > 
> > On 07/11/2018 12:26 AM, Yu-cheng Yu wrote:
> > 
> > > 
> > > +To build a CET-enabled kernel, Binutils v2.30 and GCC v8.1 or
> > > later
> > > +are required.  To build a CET-enabled application, GLIBC v2.29
> > > or
> > > +later is also requried.
> > 
> > Have you given up on getting the required changes into glibc 2.28?
> > 
> This is a typo.  We are still targeting for 2.28.  All pieces are
> there.
> 

Ok, I will fix it.

Yu-cheng
