From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 21:46:13 -0800
Message-ID: <CALCETrWuW3f=c5V0W2CaLGD63MbbsYAeDwz04B+n7iRyQn7vQw@mail.gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <20181110192027.GA29892@kroah.com> <cd4717c4-4950-7513-726d-2e1873aeceb5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cd4717c4-4950-7513-726d-2e1873aeceb5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Colascione <dancol@google.com>, LKML <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 11, 2018 at 6:24 PM Carlos O'Donell <carlos@redhat.com> wrote:
>
> On 11/10/18 2:20 PM, Greg KH wrote:
> > Also, what about the basic work of making sure our uapi header files can
> > actually be used untouched by a libc?  That isn't the case these days as
> > the bionic maintainers like to keep reminding me.  That might be a good
> > thing to do _before_ trying to add new things like syscall wrappers.
> I agree completely. There are many steps in the checklist to writing
> a new syscall, heck we should probably have a checklist!
>
> Socially the issue is difficult because the various communities only
> marginally share the same network of developers, care about different
> features, or the same features with different priorities.
>
> That doesn't mean we shouldn't try to integrate better. As was pointed
> out, various people from the userspace and toolchain communities are
> going to LPC to do just this.
>

if you all want my two cents, I think that we should approach this all
quite differently than trying to get glibc to add a wrapper for each
syscall.  I think the kernel should contain a list or list of syscalls
along with parameter names, types, and numbers, and this should get
processed during the kernel build to produce a few different
artifacts:

 - A machine-readable version of the same data in a stable format.
Tools like strace should be able to consume it.

 - A library called, perhaps, libinux, or maybe a header-only library.
It should have a wrapper for *every* syscall, and they should be
namespaced.  Instead of renameat2(), it should expose
linux_renameat2().  Ideally it would use the UAPI header types, but
void * wouldn't be so bad for pointers.

P.S. Does gcc even *have* the correct asm constraints to express
typeless syscalls?  Ideally we'd want syscalls to have exactly the
same pointer escaping semantics as ordinary functions, so, if I do:

struct timeval tv;
/* typed expansion of linux_gettimeofday(&tv, NULL); */
asm volatile ("whatever" : "+m" (tv) : "D" (&tv));

it works.  But if I want to use a generic wrapper that doesn't know
that the argument is a pointer, I do:

asm volatile ("whatever" :: "D" (&tv));

then gcc seems to not actually understand that the value pointed to by
&tv is modified by the syscall.  glibc's syscall() function works
AFAICT because it's an external function, and gcc considers &tv to
have escaped and can't see the body of the syscall() function.
