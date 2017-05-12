From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 12:30:02 -0700
Message-ID: <CAGXu5j+xmyJ6RhtPw9rUgs7k3sZ1KKWffvyGGG--oPfu9W42ng@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com> <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com> <20170509111007.GA14702@kroah.com>
 <CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
 <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com>
 <20170512072802.5a686f23@mschwideX1> <CAGXu5j+EatK=DYONRkgovwLgytAnbG8jnAZaMSLckZFNVj3gig@mail.gmail.com>
 <20170512075458.09a3a1ce@mschwideX1> <CAGXu5jL9vUrn4kpjO+qa4cHmWBypeqP17OGbrMs=5Nz0YpQMZw@mail.gmail.com>
 <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzbiBqsYb7vwO=+L4Vp_GOgPu+DBOrq4fBnyzq5DbBehg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo
List-Id: linux-api@vger.kernel.org

On Fri, May 12, 2017 at 12:08 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Fri, May 12, 2017 at 12:01 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> Yeah, the risk for "corrupted addr_limit" is mainly a concern for
>> archs with addr_limit on the kernel stack. If I'm reading things
>> correctly, that means, from the archs I've been paying closer
>> attention to, it's an issue for arm, mips, and powerpc:
>
> I don't understand why people are looking at addr_limit as some kind
> of special thing.
>
> If somebody is smashing the stack and corrupting thread info data, the
> game is over. addr_limit is the *least* of your problems, and it's not
> even all that likely that it will be increasing (it's much more likely
> that it would be overwritten with a smaller value).
>
> Quite frankly, this kind of idiotic discussion just makes me question
> the whole idea of the patch.
>
> Any "security" that is this specific is not real security, it's just
> masturbatory garbage.
>
> It may be worth checking that people use "set_fs()" properly. But stop
> this idiotic crap. It just makes the kernel security people look like
> the crazies.
>
> There are enough incompetent crazy security people, don't go there.
> The kinds of things it is worth protecting against are the big class
> of generic issues, not the kind of "oh, but imagine if a cosmic ray
> flips this particular word in memory" kind of crap that ignores all
> the other words of memory.
>
> Seriously, Kees. You are just making security people look bad. Stop it.

I'm clearly not explaining things well enough. I shouldn't say
"corruption", I should say "malicious manipulation". The methodology
of attacks against the stack are quite different from the other kinds
of attacks like use-after-free, heap overflow, etc. Being able to
exhaust the kernel stack (either due to deep recursion or unbounded
alloca()) means attackers can control a write to addr_limit, and then
leverage that into an actual arbitrary write via subsequent calls to
copy_to_user() pointed at kernel memory. This isn't theoretical, this
is how those attacks are performed. It may sound crazy, but it's real.

With thread_info off the stack, the whole problem goes away. It's
wonderful that this has happened for x86, arm64, and s390. There are
always going to be new methods of attack for everything, but while we
slowly address the design weakness (set_fs()), we can fix the low
hanging fruit too.

-Kees

-- 
Kees Cook
Pixel Security
