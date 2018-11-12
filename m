From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 22:34:36 +0000
Message-ID: <alpine.DEB.2.21.1811122223350.18130@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <CAKCAbMiHC9r54h=XeW7CkBZ1Z5eHr9MPH3Rn7KTc9DjoHG=8UA@mail.gmail.com> <CAKOZuev7zqq+xpjyDA2mSdy-zwyNjECCzLsBELF6_v1rwar_mA@mail.gmail.com>
 <87lg5ym7qi.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87lg5ym7qi.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Daniel Colascione <dancol@google.com>, Zack Weinberg <zackw@panix.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Mon, 12 Nov 2018, Florian Weimer wrote:

> For that use case, a machine-readable system call ABI specification is
> the only reasonable approach: Some people want inline system calls,

I also think it's much more likely to be of use to glibc than any syscall 
library provided by the kernel.  I don't think a syscall library provided 
by the kernel is likely to be of use for implementing glibc functions, but 
some kind of textual ABI specification might at least be of use for 
checking that syscall macro calls / syscalls.list entries are consistent 
with what the kernel thinks its ABI is.  (Hopefully there would be 
automated tests on the kernel side as well of some kind of consistency 
between the ABI specification and the kernel.)

strace is indeed a more obvious potential consumer of such a description 
of syscall ABIs.

I'd think a syscall library would more likely be something a few 
applications would use if they want to access a syscall that for whatever 
reason glibc doesn't have a wrapper for yet - not something useful for 
glibc itself to call or link against.

> and for application programmer's sanity, make sure that the kernel adds
> generic system calls in a single version, across all architectures.

That would be strongly desirable for glibc as well - a way of ensuring 
that the kernel rapidly fails CI tests and does not get released if new 
syscalls are only present on some architectures (including e.g. being 
missing from some compat syscall tables, or defined in asm/unistd.h but 
not in the actual syscall table, or vice versa - or some way of making 
sure such inconsistencies cannot occur by eliminating duplicate copies of 
the syscall list information in the sources).

When we have compatibility code in glibc for the absence of some syscall, 
we can only eliminate that code when the oldest kernel version supported 
by glibc is new enough to have the syscall on whichever glibc architecture 
was slowest to introduce the syscall in the kernel - and that can often be 
years after the first architectures gained support for that syscall in the 
kernel.

-- 
Joseph S. Myers
joseph@codesourcery.com
