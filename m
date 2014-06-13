From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v3 0/7] File Sealing & memfd_create()
Date: Fri, 13 Jun 2014 08:17:54 -0700
Message-ID: <CALCETrU8N9EbnJ3=oQ1WQCG9Vunn3nR9Ba=J48wJm0SuH0YB4A@mail.gmail.com>
References: <1402655819-14325-1-git-send-email-dh.herrmann@gmail.com>
 <CALCETrVoE+JO2rLsBUHAOJdvescEEjxikj8iQ339Nxfopfc7pw@mail.gmail.com> <CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4SaWLD=hNEc-CDJbNnrGfXE_PkxZFBhpW4tbK7wor7xPA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 13, 2014 at 8:15 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi
>
> On Fri, Jun 13, 2014 at 5:10 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Fri, Jun 13, 2014 at 3:36 AM, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Hi
>>>
>>> This is v3 of the File-Sealing and memfd_create() patches. You can find v1 with
>>> a longer introduction at gmane:
>>>   http://thread.gmane.org/gmane.comp.video.dri.devel/102241
>>> An LWN article about memfd+sealing is available, too:
>>>   https://lwn.net/Articles/593918/
>>> v2 with some more discussions can be found here:
>>>   http://thread.gmane.org/gmane.linux.kernel.mm/115713
>>>
>>> This series introduces two new APIs:
>>>   memfd_create(): Think of this syscall as malloc() but it returns a
>>>                   file-descriptor instead of a pointer. That file-descriptor is
>>>                   backed by anon-memory and can be memory-mapped for access.
>>>   sealing: The sealing API can be used to prevent a specific set of operations
>>>            on a file-descriptor. You 'seal' the file and give thus the
>>>            guarantee, that it cannot be modified in the specific ways.
>>>
>>> A short high-level introduction is also available here:
>>>   http://dvdhrm.wordpress.com/2014/06/10/memfd_create2/
>>
>> Potentially silly question: is it guaranteed that mmapping and reading
>> a SEAL_SHRINKed fd within size bounds will not SIGBUS?  If so, should
>> this be documented?  (The particular issue here would be reading
>> holes.  It should work by using the zero page, but, if so, we should
>> probably make it a real documented guarantee.)
>
> No, this is not guaranteed. See the previous discussion in v2 on Patch
> 2/4 between Hugh and me.
>
> Summary is: If you want mmap-reads to not fail, use mlock(). There are
> many situations where a fault might fail (think: OOM) and sealing is
> not meant to protect against that. Btw., holes are automatically
> filled with fresh pages by shmem. So a read only fails in OOM
> situations (or memcg limits, etc.).
>

Isn't the point of SEAL_SHRINK to allow servers to mmap and read
safely without worrying about SIGBUS?

--Andy

> Thanks
> David



-- 
Andy Lutomirski
AMA Capital Management, LLC
