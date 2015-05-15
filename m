From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH v2 1/3] pagemap: add mmap-exclusive bit for marking pages
 mapped only here
Date: Fri, 15 May 2015 12:39:05 +0300
Message-ID: <5555BEB9.6000905@yandex-team.ru>
References: <20150512090156.24768.2521.stgit@buzz>	<20150512094303.24768.10282.stgit@buzz>	<CAEVpBaLm9eicuFPmyRLa7GddLwtBJh3XzHT=fxj-h0YwwmXQOg@mail.gmail.com>	<55532CB0.6070400@yandex-team.ru> <CAEVpBa+r6AuB7hnCnTm8YKHzaj172q7Wy89yT=P_F6GQG-3-1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEVpBa+r6AuB7hnCnTm8YKHzaj172q7Wy89yT=P_F6GQG-3-1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14.05.2015 21:50, Mark Williamson wrote:
> Hi Konstantin,
>
> On Wed, May 13, 2015 at 11:51 AM, Konstantin Khlebnikov
> <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
>> On 12.05.2015 15:05, Mark Williamson wrote:
> <snip>
>>>    1. I was hoping we'd be able to backport a compatible fix to older
>>> kernels that might adopt the pagemap permissions change.  Using the V2
>>> format flags rules out doing this for kernels that are too old to have
>>> soft-dirty, I think.
>>>
>>>    2. From our software's PoV, I feel it's worth noting that it doesn't
>>> strictly fix ABI compatibility, though I realise that's probably not
>>> your primary concern here.  We'll need to modify our code to write the
>>> clear_refs file but that change is OK for us if it's the preferred
>>> solution.
> <snip>
>> I prefer to backport v2 format (except soft-dirty bit and clear_refs)
>> into older kernels. Page-shift bits are barely used so nobody will see
>> the difference.
>
> My concern was whether a change to format would be acceptable to
> include in the various -stable kernels; they are already including the
> additional protections on pagemap, so we're starting to need our
> fallback mode in distributions.  Do you think that such a patch would
> be acceptable there?
>
> (As an application vendor we're likely to be particularly stuck with
> what the commercial distributions decide to ship, which is why I'm
> trying to keep an eye on this)
>
> I appreciate that this is a slightly administrative concern!  I
> definitely like the technical approach of this code and it seems to
> work fine for us.

I cannot guarantee that v2 format will be accepted into stable kernels
and into distributives. I'm not the gate keeper.

As a fallback probably you should invent some kind of suid helper
which gives you access to required information without exposing pfn.
For example: it gets pids and memory ranges as arguments and prints
bitmap of CoWed pages into stdout.

-- 
Konstantin
