From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 17:36:11 +0000
Message-ID: <alpine.DEB.2.21.1811121723210.6607@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <20181111081725.GA30248@1wt.eu> <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com> <20181111111143.GB4189@1wt.eu>
 <87zhufvntw.fsf@oldenburg.str.redhat.com> <20181111120910.GA4425@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111120910.GA4425@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: Florian Weimer <fweimer@redhat.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, 11 Nov 2018, Willy Tarreau wrote:

> > The kernel developers care not, and the result is that we
> > copy definitions and declarations from the kernel header files, creating
> > additional problems.
> 
> Probably that these standard compatibility issues should be addressed at
> their root in the kernel header definitions in fact. Working around issues
> always leads to a stall at some point, and it encourages the process not
> to change.

But it's not a bug in the Linux kernel header files.  The set of feature 
test macros supported is libc-specific and libc-version-specific.  The 
internal macros defined as a result of the feature test macros, that 
determine what features to expose, are also libc-specific and 
libc-version-specific.  (The __USE_* macros in glibc are not a stable API.  
For example, we might move to using __GLIBC_USE for more features in place 
of the defined/undefined __USE_* internal macros.)

If a feature is Linux-specific, and the userspace header for it is also 
Linux-specific (as opposed to constants in standard headers such as 
sys/mman.h, where you get all the namespace issues), that userspace header 
*can* include uapi headers in many cases to get constants and structures - 
if those uapi headers actually work in userspace without defining things 
conflicting with libc types.  E.g. <sys/fanotify.h> includes 
<linux/fanotify.h>.

What *is*, in my view, a bug in the uapi headers is that some of them 
don't work when included on their own.  I'd expect #include 
<linux/whatever.h> or #include <asm/whatever.h>, for any such header 
installed by make headers_install, to compile on its own in userspace 
without needing any other headers to be included first, unless some header 
is specifically defined as being an internal part of another header which 
is the one that should be included.

In glibc we have scripts/check-installed-headers.sh which verifies that 
installed headers work when included like that in various language 
standard and feature test macro modes - and with my bots running 
build-many-glibcs.py, this property is effectively verified every few 
hours for (currently) 79 different glibc configurations covering all 
supported glibc ABIs.  If the uapi headers are fixed to work on their own, 
there should be similar continuous integration to make sure that this 
continues to be the case in future.

Simply having uapi headers that reliably work when included on their own 
would help with adding further test automation in glibc to verify 
consistency of constant and structure definitions between glibc and uapi 
headers.  We have a few such checks (e.g. for signal numbers), but now 
that we require Python 3 to build glibc I hope to convert those into more 
general infrastructure for extracting information from headers and running 
checks on the extracted information.

-- 
Joseph S. Myers
joseph@codesourcery.com
