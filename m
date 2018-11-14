From: Daniel Colascione <dancol@google.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 10:35:42 -0800
Message-ID: <CAKOZuetCGCfNdJ2QM0phu3_3Q29f5Yeh=NHiM_A9MhHsCjK48A@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <CAKOZuesta_V=doXsVLc2E6WCQvywdur3F+u2pFKaPN+CEQd+ZQ@mail.gmail.com> <alpine.DEB.2.21.1811141741000.16571@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811141741000.16571@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 14, 2018 at 10:15 AM, Joseph Myers <joseph@codesourcery.com> wrote:
> Any
> feature (e.g. syscall library) with a design coming solely from the kernel
> rather than a cooperative process is also likely to have an unsuitable
> design meaning it doesn't get used.

Is that so? membarrier came directly from the kernel. It gets used and
appears to have a suitable design. That something isn't used by libc
doesn't mean that it doesn't get used in general.

>  Once we have sufficient communication
> to design suitable interfaces *together*, "avoiding the need to
> communicate" becomes irrelevant as a design criterion anyway.

If that approach is going to go work, the libc maintainership needs to
be more pragmatic, less idealistic, and less likely to block work on
purity grounds, e.g., we shouldn't do X because the dynamic linker
really should be out-of-process, we can't do Y because nobody should
be using signals, and we can't do Z because the kernel uses IDs that
have such-and-such ugly properties.

A good demonstration of a new commitment to pragmatism would be
merging the trivial wrappers for gettid(2).
