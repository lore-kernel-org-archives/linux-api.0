From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFC] making uapi/linux/elfcore.h useful again
Date: Fri, 14 Sep 2018 21:55:21 +0200
Message-ID: <CAK8P3a03qF4+yGBNVLymrSRN7QjDGjnpduoPwnprwv+kfHZ0Cg@mail.gmail.com>
References: <20180914113929.953895-1-arnd@arndb.de> <20180914174528.GA35000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180914174528.GA35000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Joseph Myers <joseph@codesourcery.com>, David Howells <dhowells@redhat.com>, GNU C Library <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 14, 2018 at 7:45 PM Ingo Molnar <mingo@kernel.org> wrote:
> * Arnd Bergmann <arnd@arndb.de> wrote:
> > - Move required data from the private x86 asm/elf.h file into
> >   a new uapi/asm/elf.h. Some other architectures already do that,
> >   but most of them do not. Before applying the patch, we have
> >   to do this for all architectures
>
> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

> I suspect this wants to go through -mm, or do you want to carry it?

-mm is probably best. For now, I just want to see if there are any
concerns about this, and then I'd have to do the full version that
changes all architectures.

     Arnd
