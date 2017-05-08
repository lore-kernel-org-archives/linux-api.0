From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v9 1/4] syscalls: Verify address limit before returning to user-mode
Date: Mon, 8 May 2017 08:24:43 -0700
Message-ID: <CAGXu5jJ4iY7QZ9wRu5dmm7RHtLh_V6TQh4huWwLCYPKOr63aiA@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <CAGXu5jKZRESgGhZ6GEoO784Q1G8V0DPcwM1T2PpyTqvEAsrUdg@mail.gmail.com>
 <20170508140230.23kxf2kfeazeo4zr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170508140230.23kxf2kfeazeo4zr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe@redhat.>
List-Id: linux-api@vger.kernel.org

On Mon, May 8, 2017 at 7:02 AM, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>
>> > And yes, I realize that there were other such bugs and that such bugs might
>> > occur in the future - but why not push the overhead of the security check to
>> > the kernel build phase? I.e. I'm wondering how well we could do static
>> > analysis during kernel build - would a limited mode of Sparse be good enough
>> > for that? Or we could add a new static checker to tools/, built from first
>> > principles and used primarily for extended syntactical checking.
>>
>> Static analysis is just not going to cover all cases. We've had vulnerabilities
>> where interrupt handlers left KERNEL_DS set, for example. [...]
>
> Got any commit ID of that bug - was it because a function executed by the
> interrupt handler leaked KERNEL_DS?

Ah, it was an exception handler, but the one I was thinking of was this:
https://lwn.net/Articles/419141/

>> [...] If there are performance concerns, let's put this behind a CONFIG. 2-5
>> instructions is not an issue for most people that want this coverage.
>
> That doesn't really _solve_ the performance concerns, it just forces most people
> to enable it by creating a 'security or performance' false dichotomy ...

That's fair, but what I'm trying to say is that many people will want
this, so rejecting it because it's 2 more instructions seems
unreasonable. We have had much more invasive changes added to the
kernel.

>> [...] and it still won't catch everything. Bug-finding is different from making
>> a bug class just unexploitable at all. As we've done before, it's the difference
>> between trying to find format string attacks vs just removing %n from the format
>> parser.
>
> No, it does not make it unexploitable, it could still be exploitable if the
> runtime check is buggy or if there's kernel execution outside of the regular
> system call paths - there's plenty of such hardware functionality on x86 for
> example.

Fine, but this is splitting hairs. This does protect a specific
situation, and it does so very cheaply. The real fix would be to
remove set_fs() entirely. :P

-Kees

-- 
Kees Cook
Pixel Security
