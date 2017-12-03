From: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mmap.2: MAP_FIXED is no longer discouraged
Date: Sat, 2 Dec 2017 20:06:17 -0800
Message-ID: <d654b75e-e20b-b8ed-4564-abb1d210a921@nvidia.com>
References: <20171202021626.26478-1-jhubbard@nvidia.com>
 <20171202150554.GA30203@bombadil.infradead.org>
 <CAG48ez2u3fjBDCMH4x3EUhG6ZD6VUa=A1p441P9fg=wUdzwHNQ@mail.gmail.com>
 <20171202221910.GA8228@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171202221910.GA8228-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/02/2017 02:19 PM, Matthew Wilcox wrote:
> On Sat, Dec 02, 2017 at 07:49:20PM +0100, Jann Horn wrote:
>> On Sat, Dec 2, 2017 at 4:05 PM, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> On Fri, Dec 01, 2017 at 06:16:26PM -0800, john.hubbard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
[...]
> 
> Maybe that should be up front rather than buried at the end of the sentence.
> 
> "In a multi-threaded process, the address space can change in response to
> virtually any library call.  This is because almost any library call may be
> implemented by using dlopen(3) to load another shared library, which will be
> mapped into the process's address space.  The PAM libraries are an excellent
> example, as well as more obvious examples like brk(2), malloc(3) and even
> pthread_create(3)."
> 
> What do you think?
> 

Hi Matthew,

Here is a new version, based on your and Jann's comments. I also added a
reference to MAP_FIXED_SAFE. If it looks close, I'll send a v2 with proper
formatting applied.

I did wonder briefly if your ATM reference was a oblique commentary about
security, but then realized...you probably just needed some cash. :)

-----

This option is extremely hazardous (when used on its own) and moderately
non-portable.

On portability: a process's memory map may change significantly from one
run to the next, depending on library versions, kernel versions and ran‐
dom numbers.

On hazards: this option forcibly removes pre-existing  mappings,  making
it easy for a multi-threaded process to corrupt its own address space.

For  example,  thread  A  looks  through /proc/<pid>/maps and locates an
available address range, while thread B simultaneously acquires part  or
all  of  that  same  address range. Thread A then calls mmap(MAP_FIXED),
effectively overwriting thread B's mapping.

Thread B need not create a mapping directly;  simply  making  a  library
call that, internally, uses dlopen(3) to load some other shared library,
will suffice. The dlopen(3) call will map the library into the process's
address  space.  Furthermore, almost any library call may be implemented
using this technique.  Examples include brk(2), malloc(3),  pthread_cre‐
ate(3), and the PAM libraries (http://www.linux-pam.org).

Given the above limitations, one of the very few ways to use this option
safely is: mmap() a region, without specifying MAP_FIXED.  Then,  within
that  region,  call  mmap(MAP_FIXED) to suballocate regions. This avoids
both the portability problem (because the first mmap call lets the  ker‐
nel pick the address), and the address space corruption problem (because
the region being overwritten is already owned by the calling thread).

Newer kernels (Linux 4.16 and later) have a MAP_FIXED_SAFE  option  that
avoids  the  corruption  problem; if available, MAP_FIXED_SAFE should be
preferred over MAP_FIXED.


thanks,
John Hubbard
NVIDIA
