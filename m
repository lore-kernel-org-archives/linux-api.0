From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 18:30:27 +0000
Message-ID: <alpine.DEB.2.21.1811141825210.16571@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com> <fb340c72-c484-7f55-a2bd-71e072d7f1f5@redhat.com>
 <CAK8P3a1S65QSRruig+hg_03XbcNges1oR0YWivypvcp7r79Lew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1S65QSRruig+hg_03XbcNges1oR0YWivypvcp7r79Lew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: carlos@redhat.com, Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave Martin <Dave.Martin@arm.com>, dancol@google.com, nd@arm.com, Florian Weimer <fweimer@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, GNU C Library <libc-alpha@sourceware.org>, Firoz Khan <firoz.khan@linaro.org>
List-Id: linux-api@vger.kernel.org

On Wed, 14 Nov 2018, Arnd Bergmann wrote:

> Firoz Khan is in the process of doing part of this, by changing the
> in-kernel per-architecture unistd.h and syscall.S files into a
> architecture independent machine-readable format that is used to
> generate the existing files. The format will be similar to what
> we have on arm/s390/x86 in the syscall.tbl files already.

Will this also mean the following are unable to occur in future (both have 
occurred in the past):

* A syscall added to unistd.h for an architecture, but not added to the 
syscall table until sometime later?

* A syscall added to the native syscall table for some ABI (e.g. 32-bit 
x86 or arm) but not added to the corresponding compat syscall table (e.g. 
32-bit x86 binaries running on x86_64, 32-bit arm binaries running on 
arm64) until sometime later?

Avoiding both of those complications is beneficial to libc (as is a third 
thing, avoiding a syscall being added to different architectures in 
different versions).

-- 
Joseph S. Myers
joseph@codesourcery.com
