From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
 safely defining new mmap flags
Date: Thu, 31 Aug 2017 14:31:38 -0700
Message-ID: <CAPcyv4g3J10brmUAw8UV4cOP+Yn6wHD2N_OHe1YdaczUZZmN0g@mail.gmail.com>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzo4oV87tVjEzx+cHVxfihm=31+fWtsdWow3AmfsdzJJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzo4oV87tVjEzx+cHVxfihm=31+fWtsdWow3AmfsdzJJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 31, 2017 at 9:49 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> This patch strikes me as insane.
>
> On Wed, Aug 30, 2017 at 4:08 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>                 switch (flags & MAP_TYPE) {
>> +               case (MAP_SHARED|MAP_VALIDATE):
>> +                       /* TODO: new map flags */
>> +                       return -EINVAL;
>>                 case MAP_SHARED:
>>                         if ((prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE))
>>                                 return -EACCES;
>
> So you "add" support for MAP_SHARED|MAP_VALIDATE, but then error out on it.
>
> And you don't add support for MAP_PRIVATE|MAP_VALIDATE at all, so that
> errors out too.
>
> Which makes me think that you actually only want MAP:_VALIDATE support
> for shared mappings.
>
> Which in turn means that all your blathering about how this cannot
> work on HP-UX is just complete garbage, because you might as well just
> realize that MAP_TYPE isn't a mask of _bitmasks_, it's a mask of
> values.
>
> So just make MAP_VALIDATE be 0x3. Which works for everybody. Make it
> mean the same as MAP_SHARED with flag validation. End of story.
>
> None of these stupid games that are complete and utter garbage, and
> make people think that the MAP_TYPE bits are somehow a bitmask. They
> aren't. The bitmasks are all the *other* bits that aren't in
> MAP_TYTPE.
>
> Yes, yes, I see why you *think* you want a bitmap. You think you want
> a bitmap because you want to make MAP_VALIDATE be part of MAP_SYNC
> etc, so that people can do
>
>     ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED |
> MAP_SYNC, fd, 0);
>
> and "know" that MAP_SYNC actually takes.
>
> And I'm saying that whole wish is bogus. You're fundamentally
> depending on special semantics, just make it explicit. It's already
> not portable, so don't try to make it so.
>
> Rename that MAP_VALIDATE as MAP_SHARED_VALIDATE, make it have a valud
> of 0x3, and make people do
>
>    ret = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED_VALIDATE
> | MAP_SYNC, fd, 0);

Yeah, we originally had MAP_VALIDATE defined as
(MAP_SHARED|MAP_PRIVATE), but Kirill was concerned that would make
something like MAP_PRIVATE|MAP_SYNC silently provide MAP_SHARED
semantics. MAP_SHARED_VALIDATE solves that problem.

> and then the kernel side is easier too (none of that random garbage
> playing games with looking at the "MAP_VALIDATE bit", but just another
> case statement in that map type thing.
>
> Boom. Done.

Looks good to me.
