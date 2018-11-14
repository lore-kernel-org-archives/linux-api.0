From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 17:40:18 +0000
Message-ID: <alpine.DEB.2.21.1811141735070.16571@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <877ehjx447.fsf@oldenburg.str.redhat.com> <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com> <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com> <20181113193859.GJ3505@e103592.cambridge.arm.com> <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <1C1B38FC-1266-4A91-B8F6-20A0C49ED1E2@amacapital.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="-1152306461-174479658-1542217218=:16571"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1C1B38FC-1266-4A91-B8F6-20A0C49ED1E2@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Daniel Colascione <dancol@google.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

---1152306461-174479658-1542217218=:16571
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT

On Wed, 14 Nov 2018, Andy Lutomirski wrote:

> I’m not so sure it’s useless. Historically, POSIX systems have, in 
> practice and almost by definition, been very C focused, but the world is 
> changing. A less crufty library could be useful for newer languages:

Historically, there was once an attempt to rework POSIX into a separate 
language-independent definition and language bindings (for C, Fortran, Ada 
etc.), but I don't think it got anywhere, and it's probably doubtful 
whether the idea was ever very practical.  (See the introduction to 
POSIX.1:1990, for example: "Future revisions are expected to contain 
bindings for other programming languages as well as for the C language.  
This will be accomplished by breaking this part of ISO/IEC 9945 into 
multiple portions---one defining core requirements independent of any 
programming language, and others composed of programming language 
bindings.".)

> > thread internals for syscalls that
> > require coordination between all user created
> > threads (setxid),
> 
> We should just deal with this in the kernel. The current state of 
> affairs is nuts.

Yes, we should have a few new syscalls to set these ids at the process 
level.

-- 
Joseph S. Myers
joseph@codesourcery.com
---1152306461-174479658-1542217218=:16571--
