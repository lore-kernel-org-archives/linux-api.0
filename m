From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 07 Nov 2019 14:23:26 +0100
Message-ID: <87zhh7hlbl.fsf@oldenburg2.str.redhat.com>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
	<0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
	<87zhh7j38y.fsf@oldenburg2.str.redhat.com>
	<CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-106749-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
	(Elichai Turkel's message of "Thu, 7 Nov 2019 15:03:12 +0200")
To: Elichai Turkel <elichai.turkel@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Elichai Turkel:

> Thanks for the response,
> I'm not sure what are you suggesting exactly.
> A rename to the structs/types so they won't collide with libc?

Or use namespaces.  I mean, we have had proper technical solutions for
this issue for more than 20 years now.  I know that this isn't going to
happen, though.

> Prioritizing POSIX conformance in the kernel(I think that ship has long s=
ailed)?

That doesn't really work anyway if userspace has different versions of
the type depending on feature macros.  Examples are struct stat or soon
struct timespec on 32-bit architectures.

> Or just giving up and telling users they can't just directly include
> both libc headers and kernel headers?

That's what I've been telling users if they encounter fringe cases I
can't fix on the glibc side.

It might also help if top-level types for end user use would be in
separate headers.  This is what we started doing internally in glibc, to
disentangle our own headers and eliminate cyclic dependencies.

> (I'm actually not sure how it works now. because there are definitely
> collision and if we are using ifdefs and undefs black magic you still
> end up with a single declaration in the end that might not be
> compatible with both libc and kernel)

Officially, it's supposed to work today.  We have one glibc developer
who says that it's easy to solve, but I disagree strongly.  The fact
that the problems are not fixed promptly suggests that it's anything but
simple.

What I've been doing instead is to include UAPI headers directly from
glibc headers if it's technically feasible.  (It's not possible in POSIX
mode, where we have to manage the set of exported symbols closely, or
generally with old compilers which do not have __has_include.)  See
<bits/statx.h>, <bits/statx-generic.h> etc. in current glibc for an
example.

If you add more type definitions to kernel headers, this might interfere
with such usage of UAPI headers because today, we need to provide our
own definitions for many things not in UAPI headers, and the currently
deployed glibc headers are simply not compatible with such future
changes.

Thanks,
Florian
