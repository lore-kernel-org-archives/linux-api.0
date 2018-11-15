From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: Official Linux system wrapper library?
Date: Thu, 15 Nov 2018 10:33:57 +0000
Message-ID: <20181115103357.GM3505@e103592.cambridge.arm.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com>
 <69B07026-5E8B-47FC-9313-E51E899FAFB0@amacapital.net>
 <20181114105449.GK3505@e103592.cambridge.arm.com>
 <877ehfdgzn.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877ehfdgzn.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 14, 2018 at 12:40:44PM +0100, Florian Weimer wrote:
> * Dave Martin:
> 
> > Fair points, though this is rather what I meant by "sane essentials".
> > Because there are strict limits on what can be done in the vDSO, it may
> > be more bloat-resistant and more conservatively maintained.
> >
> > This might provide a way to push some dumb compatibility kludge code
> > that receives little ongoing maintenance outside the privilege wall,
> > whereas it has to sit in the kernel proper today.
> >
> > In theory we could opt to advertise new syscalls only via vDSO entry
> > points, and not maintain __NR_xxx values for them (which may or may
> > not upset ptrace users.)  Anyway, I digress...
> 
> Is the vDSO available across all architectures?  (I don't think we use
> it on all architectures in glibc.)

It's probably not available on all arches.

> If not, a vDSO-based approach would merely lead to even more variance
> between architectures, which can't be a good thing.

That's a fair concern.

Channeling syscalls through the vDSO could allow for a uniform syscall
interface at the ELF linkage level, but only those arches that have a
vDSO.  There may be other issues too.

Also, I don't say that we should definitely do this, just that it's
a possibility.

Cheers
---Dave
