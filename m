From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH v2 1/3] pagemap: add mmap-exclusive bit for marking pages
 mapped only here
Date: Wed, 13 May 2015 13:51:28 +0300
Message-ID: <55532CB0.6070400@yandex-team.ru>
References: <20150512090156.24768.2521.stgit@buzz>	<20150512094303.24768.10282.stgit@buzz> <CAEVpBaLm9eicuFPmyRLa7GddLwtBJh3XzHT=fxj-h0YwwmXQOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEVpBaLm9eicuFPmyRLa7GddLwtBJh3XzHT=fxj-h0YwwmXQOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Mark Seaborn <mseaborn-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel James <djames-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>, Finn Grimwood <fgrimwood-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12.05.2015 15:05, Mark Williamson wrote:
> Hi Konstantin,
>
> I hope you won't mind me thinking out loud here on the idea of adding
> a flag to the v2 pagemap fields...  From a kernel PoV, I agree that
> this seems like the cleanest approach.  However, with my application
> developer hat on:
>
>   1. I was hoping we'd be able to backport a compatible fix to older
> kernels that might adopt the pagemap permissions change.  Using the V2
> format flags rules out doing this for kernels that are too old to have
> soft-dirty, I think.
 >
>   2. From our software's PoV, I feel it's worth noting that it doesn't
> strictly fix ABI compatibility, though I realise that's probably not
> your primary concern here.  We'll need to modify our code to write the
> clear_refs file but that change is OK for us if it's the preferred
> solution.
>
> In the patches I've been playing with, I was considering putting the
> Exclusive flag in the now-unused PFN field of the pagemap entries.
> Since we're specifically trying to work around for the lack of PFN
> information, would there be any appetite for mirroring this flag
> unconditionally into the now-empty PFN field (i.e. whether using v1 or
> v2 flags) when accessed by an unprivileged process?
>
> I realise it's ugly from a kernel PoV and I feel a little bad for
> suggesting it - but it would address points 1 and 2 for us (our
> existing code just looks for changes in the pagemap entry, so sticking
> the flag in there would cause it to do the right thing).
>
> I'm sorry to raise application-specific issues at this point; I
> appreciate that your primary concern is to improve the kernel and
> technically I like the approach that you've taken!  I'll try and
> provide more code-oriented feedback once I've tried out the changes.

I prefer to backport v2 format (except soft-dirty bit and clear_refs)
into older kernels. Page-shift bits are barely used so nobody will see
the difference.

-- 
Konstantin
