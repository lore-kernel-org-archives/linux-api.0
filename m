From: Willy Tarreau <w@1wt.eu>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 12:11:43 +0100
Message-ID: <20181111111143.GB4189@1wt.eu>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <20181111081725.GA30248@1wt.eu>
 <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97138-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 11, 2018 at 11:53:54AM +0100, Michael Kerrisk (man-pages) wrote:
> I'm not sure I'd view the glibc position quite so harshly (although 
> it is disappointing to me that bug 6399 remains open). I think they
> are simply short of people to work on this task.

I think so as well and really have great respect for this limitation,
which differs from the technical arguments on the bugzilla trying to
find every single good reason why using this syscall was wrong.

(...)
> A converse question that one could ask is: why did a culture
> evolve whereby kernel developers don't take responsibility for
> working with the major libc to ensure that wrappers are added as
> part of the job of adding each new system call? Yes, I know, there
> are some historical reasons (and even today, IMO, they do 
> themselves no favors by requiring a CLA), but glibc really is 
> a different place today, compared to where it was a few years 
> ago.

I think the issue is a bit more complex :
  - linux doesn't support a single libc
  - glibc doesn't support a single OS

In practice we all know (believe?) that both statements above are
true but in practice 99% of the time there's a 1:1 relation between
these two components. What we'd really need would be to have the libc
interface as part of the operating system itself. I'm perfectly fine
with glibc providing all the "high-level" stuff like strcpy(), FILE*
operations etc, and all this probably is mostly system-independent.
But the system interface could possibly be handled easier in the
system itself, which would also provide a smoother adoption of new
syscalls and API updates. It would also limit the hassle required to
provide new syscalls, as if you start to have to contribute to two
projects at once for a single syscall, it becomes really painful.

But I don't know what changes that would require and it could really
turn out that in the end I'm totally wrong about the expected benefits.

Cheers,
Willy
