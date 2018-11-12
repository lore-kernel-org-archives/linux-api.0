From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 16:59:54 +0000
Message-ID: <alpine.DEB.2.21.1811121647310.6607@digraph.polyomino.org.uk>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com> <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com> <20181111081725.GA30248@1wt.eu> <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com> <20181111111143.GB4189@1wt.eu>
 <87zhufvntw.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87zhufvntw.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, 11 Nov 2018, Florian Weimer wrote:

> The kernel does not know about TCB layout, so a lot of low-level
> threading aspects are defined by userspace.
> 
> The kernel does not know about POSIX cancellation.  Directly calling
> system calls breaks support for that.

Indeed.  Where cancellation is involved, glibc needs to know exactly what 
instructions might be calling a cancellable syscall and what instructions 
are before or after the syscall (see Adhemerval's patches for bug 12683).

This involves an ABI that is not just specific to a particular libc, but 
specific to a particular libc version.  So it's inherently unsuitable to 
put cancellable syscalls in libc_nonshared.a, as well as unsuitable to put 
them in any kernel-provided library.

The interface for setting errno may also be libc-specific, for any 
syscalls involving setting errno.

Syscalls often involve types in their interfaces such as off_t and struct 
timespec.  libcs may have multiple different variants of those types; the 
variants available, and the ways of selecting them, are libc-specific and 
libc-version-specific.  So for any syscall for which the proper userspace 
interface involves one of those types, wrappers for it are inherently 
specific to a particular libc and libc version.  (See e.g. how preadv2 and 
pwritev2 syscalls also have preadv64v2 and pwritev64v2 APIs in glibc, with 
appropriate redirections hased on __USE_FILE_OFFSET64, which is in turn 
based on _FILE_OFFSET_BITS.)

There are many ABI variants that are relevant to glibc but not to the 
kernel.  Some of these involve ABI tagging of object files to indicate 
which ABI variant an object is built for (and those that don't have such 
tagging ought to have it), to prevent accidental linking of objects for 
different ABIs.  How to build objects for different userspace ABIs is not 
something the kernel should need to know anything about; it's most 
naturally dealt with at the level of building compiler multilibs and libc.

glibc deliberately avoids depending at compile time on the existence of 
libgcc_s.so to facilitate bootstrap builds (a stripped glibc binary built 
with a C-only static-only inhibit_libc GCC that was built without glibc 
should be identical to the result of a longer alternating sequence of GCC 
and glibc builds).  I don't think any kernel-provided library would be any 
better to depend on.

What one might suggest is that when new syscalls are added, kernel 
developers should at least obtain agreement on linux-api from libc people 
about what the userspace interface to the syscall should be.  That means 
the userspace-level types (such as off_t and struct timespec), and the 
choice of error handling (returning error number or setting errno), and 
the name of the header declaring the function, and the name of the 
function, and how the syscall relates to thread cancellation, for example 
- and whatever other issues may be raised.

-- 
Joseph S. Myers
joseph@codesourcery.com
