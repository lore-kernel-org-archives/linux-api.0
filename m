From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: General flags to turn things off (getrandom, pid lookup, etc)
Date: Sun, 27 Jul 2014 15:17:15 -0700
Message-ID: <CALCETrXfzOZEC3mOKkm3_GvitvkEu4kAa3LowRv-fjHnzrQnBg@mail.gmail.com>
References: <CALCETrWGvBfrX1W5XaFgJZhKHLf+oac9YrwPR3ppK=deQtu5hA@mail.gmail.com>
 <20140727210617.GY6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140727210617.GY6725@thunk.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-crypto@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Julien Tinnes <jln@google.com>, Theodore Ts'o <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

On Jul 27, 2014 5:06 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:
>
> On Fri, Jul 25, 2014 at 11:30:48AM -0700, Andy Lutomirski wrote:
> >
> > There is recent interest in having a way to turn generally-available
> > kernel features off.  Maybe we should add a good one so we can stop
> > bikeshedding and avoid proliferating dumb interfaces.
>
> I believe the seccomp infrastructure (which is already upstream)
> should be able to do most of what you want, at least with respect to
> features which are exposed via system calls (which was most of your
> list).

Seccomp can't really restrict lookups of non-self pids.  In fact, this
feature idea started out as a response to a patch adding a kind of
nasty seccomp feature to make it sort of possible.

I agree that that seccomp can turn off GRND_RANDOM, but how is it
supposed to do it in such a way that the filtered software will fall
back to something sensible?  -ENOSYS?  -EPERM?  Something else?

I think that -ENOSYS is clearly wrong, but standardizing this would be
nice.  Admittedly, adding something fancy like this for GRND_RANDOM
may not be appropriate.

--Andy

>
> It won't cover x86 specific things like restricting RDTSC or CPUID
> (and as far as I know you can't intercept the CPUID instruction), but
> I'm not sure it matters.  I don't really see the point, myself.
>
>                                          - Ted
