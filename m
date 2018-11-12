From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 10:14:26 -0800
Message-ID: <a67f4f9c-701f-f607-e708-b8545d80549e@infradead.org>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <20181111081725.GA30248@1wt.eu>
 <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
 <20181111111143.GB4189@1wt.eu> <87zhufvntw.fsf@oldenburg.str.redhat.com>
 <20181111120910.GA4425@1wt.eu>
 <alpine.DEB.2.21.1811121723210.6607@digraph.polyomino.org.uk>
 <20181112175305.GB15484@kroah.com>
 <alpine.DEB.2.21.1811121803520.6607@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1811121803520.6607@digraph.polyomino.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/12/18 10:09 AM, Joseph Myers wrote:
> On Mon, 12 Nov 2018, Greg KH wrote:
> 
>> If there are still problems with this, please let us know and we will be
>> glad to resolve them.
> 
> With headers installed from Linus's latest tree, I retried (for x86_64) 
> the case of a source file containing the single line
> 
> #include <linux/elfcore.h>
> 
> which (as previously discussed, and Arnd had an RFC patch) I want to use 
> in a glibc test of header consistency.  It gives errors "unknown type name 
> 'elf_greg_t'" etc. (for lots more types as well) - but even before getting 
> onto those errors, there's
> 
> asm/signal.h:127:2: error: unknown type name 'size_t'
> 
> from a header included from linux/elfcore.h.  So this doesn't seem to be 
> working as I'd expect yet.


Yes, someone from Google (iirc) and also David Howells had some tests
that would point out all of the problems.  I thought (expected) more follow-up
from them with patches...


-- 
~Randy
