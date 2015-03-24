From: Aliaksey Kandratsenka <alkondratenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mremap: add MREMAP_NOHOLE flag --resend
Date: Mon, 23 Mar 2015 21:36:32 -0700
Message-ID: <CADpJO7wP+dvXyxP7SW7F12jra_cWrEba7orRXMJGytvgOJfHkA@mail.gmail.com>
References: <deaa4139de6e6422a0cec1e3282553aed3495e94.1426626497.git.shli@fb.com>
	<20150318153100.5658b741277f3717b52e42d9@linux-foundation.org>
	<550A5FF8.90504@gmail.com>
	<CADpJO7zBLhjecbiQeTubnTReiicVLr0-K43KbB4uCL5w_dyqJg@mail.gmail.com>
	<550E6D9D.1060507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550E6D9D.1060507-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mel-wPRd99KPJ+uzQB+pC5nmwQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <google-perftools-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi.

First of all, I'd like to apologize for messing up formatting of my
past email. I've learned my lesson.

On Sun, Mar 22, 2015 at 12:22 AM, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> My initial thinking was that we'd likely use mremap in all cases where
>> we know
>> that touching destination would cause minor page faults (i.e. when
>> destination
>> chunk was MADV_DONTNEED-ed or is brand new mapping). And then also
>> always when
>> size is large enough, i.e. because "teleporting" large count of pages is
>> likely
>> to be faster than copying them.
>>
>> But now I realize that it is more interesting than that. I.e. because as
>> Daniel
>> pointed out, mremap holds mmap_sem exclusively, while page faults are
>> holding it
>> for read. That could be optimized of course. Either by separate
>> "teleport ptes"
>> syscall (again, as noted by Daniel), or by having mremap drop mmap_sem
>> for write
>> and retaking it for read for "moving pages" part of work. Being not really
>> familiar with kernel code I have no idea if that's doable or not. But it
>> looks
>> like it might be quite important.
>
> I think it's doable but it would pessimize the case where the dest VMA
> isn't reusable. It would need to optimistically take the reader lock to
> find out and then drop it. However, userspace knows when this is surely
> going to work and could give it a hint.
>
> I have a good idea about what the *ideal* API for the jemalloc/tcmalloc
> case would be. It would be extremely specific though... they want the
> kernel to move pages from a source VMA to a destination VMA where both
> are anon/private with identical flags so only the reader lock is
> necessary. On top of that, they really want to keep around as many
> destination pages as possible, maybe by swapping as many as possible
> back to the source.
>
> That's *extremely* specific though and I now think the best way to get
> there is by landing this feature and then extending it as necessary down
> the road. An allocator may actually want to manage other kinds of
> mappings itself and it would want the mmap_sem optimization to be an
> optional hint.

Interesting. But what might be other users of MREMAP_NOHOLE/MREMAP_RETAIN ?

I believe it can be argued that "exchange vmas/pages" as separate
syscall is actually more general and thus possibly more useful thing
to have. Regardless of locking. And MREMAP_NOHOLE/MREMAP_RETAIN
functionality can be built on top of that syscall in userspace if
needed (with more than one syscall naturally, but maybe still with
relatively small overhead).

I'm not saying this is good idea, but just asking.

And here is another observation just to make sure that more options
are considered.

Given that mremap is holding mmap_sem exclusively, how about userspace
malloc implementation taking some exclusive malloc lock and doing
normal mremap followed by mmap with MAP_FIXED to fill the hole ? It
might end up having largely same overhead. Well, modulo some extra TLB
flushing. But arguably, reducing TLB flushes for sequence of page
table updates could be usefully addressed separately (e.g. maybe by
matching those syscalls, maybe via syslets).
