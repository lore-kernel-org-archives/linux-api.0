From: Dominique Martinet <asmadeus@codewreck.org>
Subject: statx struct's stx_size pointer compatibility with uint64_t/size_t
Date: Tue, 17 Dec 2019 16:21:54 +0100
Message-ID: <20191217152154.GB25518@nautica>
References: <87r213aykv.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-108142-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <87r213aykv.fsf@oldenburg2.str.redhat.com>
To: linux-api@vger.kernel.org, libc-alpha@sourceware.org
Cc: Quentin Bouget <quentin.bouget@cea.fr>, Jeff Layton <jlayton@kernel.org>, David Howells <dhowells@redhat.com>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org


I originally asked this on libc-help@, Florian redirected me to
linux-api@ and libc-alpha@; resending my first mail and quoting his
reply at the end.


A coworker ran into an incompatible-pointer-type compiler warning when
trying to pass &statxbuf.stx_size to a function expecting a size_t *,
which boils down to this:
-------------
#define _GNU_SOURCE
#include <stdint.h>
#include <sys/stat.h>

static void test(uint64_t *size) {   
    (void)size;
}

int main() {   
    struct statx statxbuf;

    test(&statxbuf.stx_size);
    return 0;
}
-------------
Giving this warning:
-------------
t.c: In function ‘main’:
t.c:12:10: warning: passing argument 1 of ‘test’ from incompatible
pointer type [-Wincompatible-pointer-types]
   12 |     test(&statxbuf.stx_size);
      |          ^~~~~~~~~~~~~~~~~~
      |          |
      |          __u64 * {aka long long unsigned int *}
t.c:5:28: note: expected ‘uint64_t *’ {aka ‘long unsigned int *’} but
argument is of type ‘__u64 *’ {aka ‘long long unsigned int *’}
    5 | static void test(uint64_t *size) {
      |                  ~~~~~~~~~~^~~~
-------------
(same happens with size_t)

The final warning is probably some standard defining long and long long
cannot be treated as compatible even on archs where it is, but it's a
bit of a shame that manipulating __u64 and uint64_t yield such errors
when passing pointers around -- the types pretty much guarantee they
have to be compatible and it is just an arbitrary choice that made one
be long and the other long long on x86_64 unless I misunderstood
something?


I'm a bit at loss of what to advise here.
We need to pass the value as a pointer because it can be updated, our
use case is that the symlink size can be wrong in /proc/x/fd/ and we
will want the correct value back in a statx struct here[1].

What would be the "recommended" way of doing this?
Any chance the field could change to be uint64_t-compatible in the
future? Not sure what that implies regarding e.g. backwards
compatibility though...


[1] https://github.com/cea-hpc/robinhood/blob/1ed74893c088d78783acd2e25e8009a483510ff7/src/backends/posix.c#L248


Florian Weimer wrote on Tue, Dec 17, 2019:
> * Dominique Martinet:
> > What would be the "recommended" way of doing this?
> > Any chance the field could change to be uint64_t-compatible in the
> > future? Not sure what that implies regarding e.g. backwards
> > compatibility though...
> 
> This is a tricky subject.  We already have a copy of the type with
> uint64_t fields in the installed glibc headers, but this is only used
> if the kernel definition is not available.
> 
> We do not want to duplicate kernel headers too much because it causes
> problems if both glibc headers and kernel headers are included in the
> same translation unit.  That in turn makes it difficult to use new
> kernel features by only updating the kernel headers.
> 
> I do not know why the kernel definition of __u64 does not follow that
> of uint64_t in <stdint.h> (or why we even have that __u64 type), and
> whether the kernel definition can be changed at this point.  We can
> fix this issue with preprocessor magic, but I am not entirely sure if
> this is a good idea.


Thanks,
-- 
Dominique
