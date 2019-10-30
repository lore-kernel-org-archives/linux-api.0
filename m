From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [RFC PATCH 04/10] pipe: Use head and tail pointers for the ring,
 not cursor and length [ver #2]
Date: Wed, 30 Oct 2019 23:16:23 +0100
Message-ID: <CAOi1vP9paV2-2_S0NgfbZDE6+5kqHXVc9xabHVC-2Ss1MmXkCg@mail.gmail.com>
References: <157186182463.3995.13922458878706311997.stgit@warthog.procyon.org.uk>
 <157186186167.3995.7568100174393739543.stgit@warthog.procyon.org.uk>
 <CAOi1vP97DMX8zweOLfBDOFstrjC78=6RgxK3PPj_mehCOSeoaw@mail.gmail.com> <4892d186-8eb0-a282-e7e6-e79958431a54@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4892d186-8eb0-a282-e7e6-e79958431a54@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: David Howells <dhowells@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block <linux-block@vger.kernel.org>, linux-security-module@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 30, 2019 at 9:35 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> On 30/10/2019 17.19, Ilya Dryomov wrote:
> > On Thu, Oct 24, 2019 at 11:49 AM David Howells <dhowells@redhat.com> wrote:
> >>  /*
> >> - * We use a start+len construction, which provides full use of the
> >> - * allocated memory.
> >> - * -- Florian Coosmann (FGC)
> >> - *
> >> + * We use head and tail indices that aren't masked off, except at the point of
> >> + * dereference, but rather they're allowed to wrap naturally.  This means there
> >> + * isn't a dead spot in the buffer, provided the ring size < INT_MAX.
> >> + * -- David Howells 2019-09-23.
> >
> > Hi David,
> >
> > Is "ring size < INT_MAX" constraint correct?
>
> No. As long as one always uses a[idx % size] to access the array, the
> only requirement is that size is representable in an unsigned int. Then
> because one also wants to do the % using simple bitmasking, that further
> restricts one to sizes that are a power of 2, so the end result is that
> the max size is 2^31 (aka INT_MAX+1).

I think the fact that indices are free running and wrap at a power of
two already restricts you to sizes the are a power of two, independent
of how you do masking.  If you switch to a[idx % size], size still has
to be a power of two for things to work when idx wraps.  Consider:

  size = 6
  head = tail = 4294967292, empty buffer

  push  4294967292 % 6 = 0
  push  4294967293 % 6 = 1
  push  4294967294 % 6 = 2
  push  4294967295 % 6 = 3
  push           0 % 6 = 0  <-- expected 4, overwrote a[0]

>
> > I've never had to implement this free running indices scheme, but
> > the way I've always visualized it is that the top bit of the index is
> > used as a lap (as in a race) indicator, leaving 31 bits to work with
> > (in case of unsigned ints).  Should that be
> >
> >   ring size <= 2^31
> >
> > or more precisely
> >
> >   ring size is a power of two <= 2^31
>
> Exactly. But it's kind of moot since the ring size would never be
> allowed to grow anywhere near that.

Thanks for confirming.  Even if it's kind of moot, I think it should be
corrected to avoid confusion.

                Ilya
