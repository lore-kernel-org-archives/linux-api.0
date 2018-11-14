From: Paul Eggert <eggert@cs.ucla.edu>
Subject: Re: Official Linux system wrapper library?
Date: Wed, 14 Nov 2018 10:13:08 -0800
Message-ID: <00dc083b-2e56-af27-30b5-1effe5a7c8c4@cs.ucla.edu>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <877ehjx447.fsf@oldenburg.str.redhat.com>
 <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
 <875zx2vhpd.fsf@oldenburg.str.redhat.com>
 <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
 <20181113193859.GJ3505@e103592.cambridge.arm.com>
 <5853c297-9d84-86e5-dede-aa2957562c6b@arm.com>
 <1C1B38FC-1266-4A91-B8F6-20A0C49ED1E2@amacapital.net>
 <alpine.DEB.2.21.1811141735070.16571@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811141735070.16571@digraph.polyomino.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Szabolcs Nagy <Szabolcs.Nagy@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Daniel Colascione <dancol@google.com>, nd <nd@arm.com>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/14/18 9:40 AM, Joseph Myers wrote:
> Historically, there was once an attempt to rework POSIX into a separate
> language-independent definition and language bindings (for C, Fortran, Ada
> etc.), but I don't think it got anywhere, and it's probably doubtful
> whether the idea was ever very practical.

That effort did produce IEEE Std 1003.5-1992 (Ada Bindings to IEEE Std 
1003.1-1990), IEEE 1003.5b-1996 (Ada bindings for realtime extensions), 
and IEEE Std 1003.9-1992 (F77 Bindings to IEEE Std 1003.1-1992). The Ada 
group simply translated the POSIX standard from C into Ada, repeating 
functional text and coming up with a "thick" standard; in contrast the 
Fortran group did a "thin" standard that focused on Fortran mechanics 
and deferred underlying functionality to the main POSIX standard. The 
thin Fortran standard was harder to grok and was less successful in 
practice.

As you write, these efforts were probably not worth the trouble. Non-C 
language systems can provide a standard way to invoke C APIs, and then 
let user-level programmers have at it. The performance advantage of 
having a pure Ada/Fortran/etc. API for POSIX are so minor that it's not 
worth the major hassle of standardizing and using a language-independent 
POSIX API.
