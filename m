From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFC] making uapi/linux/elfcore.h useful again
Date: Tue, 18 Sep 2018 07:21:13 -0700
Message-ID: <CAK8P3a3PViCK9RzhwDkXhO_mJvgnfe0=tbFs5X_7JDRQQMujYA@mail.gmail.com>
References: <20180914113929.953895-1-arnd@arndb.de> <alpine.DEB.2.21.1809171204350.13789@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809171204350.13789@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, David Howells <dhowells@redhat.com>, GNU C Library <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 17, 2018 at 5:05 AM Joseph Myers <joseph@codesourcery.com> wrote:
>
> On Fri, 14 Sep 2018, Arnd Bergmann wrote:
>
> > +typedef unsigned long elf_greg_t;
>
> Does that need to be unsigned long long for x32?  (At least glibc thinks
> so; I've not tested what an x32 core dump actually looks like, but to be
> useful it certainly ought to have 64-bit registers.)

Yes, I think that's right. 'unsigned long' was correct inside of the kernel,
but copying it into a uapi header means we have to use '__kernel_ulong_t'
so it gets interpreted right by x32 user space.

          Arnd
