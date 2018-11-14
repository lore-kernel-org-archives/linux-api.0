From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 09:15:34 -0800
Message-ID: <CAK8P3a1S65QSRruig+hg_03XbcNges1oR0YWivypvcp7r79Lew@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <fb340c72-c484-7f55-a2bd-71e072d7f1f5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fb340c72-c484-7f55-a2bd-71e072d7f1f5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: carlos@redhat.com
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave Martin <Dave.Martin@arm.com>, dancol@google.com, nd@arm.com, Florian Weimer <fweimer@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, GNU C Library <libc-alpha@sourceware.org>, Firoz Khan <firoz.khan@linaro.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 14, 2018 at 6:58 AM Carlos O'Donell <carlos@redhat.com> wrote:
> On 11/14/18 6:58 AM, Szabolcs Nagy wrote:
> > an actual proposal in the thread that i think is
> > worth considering is to make the linux syscall
> > design process involve libc devs so the c api is
> > designed together with the syscall abi.
>
> * Programmatic / Machine readable description of syscalls.
>   This way the kernel gives users the ability to autogenerate
>   all the wrappers *if they want to* in a consistent way that
>   matches this syscall description format.

Firoz Khan is in the process of doing part of this, by changing the
in-kernel per-architecture unistd.h and syscall.S files into a
architecture independent machine-readable format that is used to
generate the existing files. The format will be similar to what
we have on arm/s390/x86 in the syscall.tbl files already.

This is of course only part of the picture, it answers the question
of which syscalls are implemented on an architecture, which number
they have and (ideally) whether they use a standard implementation
or a custom one, but it does not yet relate to the prototype.

Once this work is merged, we can follow up by coming up with a
way to add prototypes and enforcing that the user space wrapper
uses the same argument types as the in-kernel entry point.

      Arnd
