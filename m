From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 13:54:03 -0800
Message-ID: <CAHk-=wgrSKyN23yp-npq6+J-4pGqbzxb3mJ183PryjHw7PWDyA@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <CAHk-=wicks2BEwm1BhdvEj_P3yawmvQuG3NOnjhdrUDEtTGizw@mail.gmail.com>
 <nycvar.YFH.7.76.1901052108390.16954@cbobk.fhfr.pm> <CAHk-=whGmE4QVr6NbgHnrVGVENfM3s1y6GNbsfh8PcOg=6bpqw@mail.gmail.com>
 <nycvar.YFH.7.76.1901052131480.16954@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1901052131480.16954@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>, Masatake YAMATO <yamato@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jan 5, 2019 at 12:43 PM Jiri Kosina <jikos@kernel.org> wrote:
>
> > Who actually _uses_ mincore()? That's probably the best guide to what
> > we should do. Maybe they open the file read-only even if they are the
> > owner, and we really should look at file ownership instead.
>
> Yeah, well
>
>         https://codesearch.debian.net/search?q=mincore
>
> is a bit too much mess to get some idea quickly I am afraid.

Yeah, heh.

And the first hit is 'fincore', which probably nobody cares about
anyway, but it does

    fd = open (name, O_RDONLY)
    ..
    mmap(window, len, PROT_NONE, MAP_PRIVATE, ..

so if we want to keep that working, we'd really need to actually check
file ownership rather than just looking at f_mode.

But I don't know if anybody *uses* and cares about fincore, and it's
particularly questionable for non-root users.

And the Android go runtime code seems to oddly use mincore to figure
out page size:

  // try using mincore to detect the physical page size.
  // mincore should return EINVAL when address is not a multiple of
system page size.

which is all kinds of odd, but whatever.. Why mincore, rather than
something sane and obvious like mmap? Don't ask me...

Anyway, the Debian code search just results in mostly non-present
stuff. It's sad that google code search is no more. It was great for
exactly these kinds of questions.

The mono runtime seems to have some mono_pages_not_faulted() function,
but I don't know if people use it for file mappings, and I couldn't
find any interesting users of it.

I didn't find anything that seems to really care, but I gave up after
a few pages of really boring stuff.

                    Linus
