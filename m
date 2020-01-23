From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Wed, 22 Jan 2020 19:02:08 -0800
Message-ID: <CD5EA896-7364-40E2-8709-A014973FFBC8@amacapital.net>
References: <20200123014627.71720-1-bgeffon@google.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200123014627.71720-1-bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Lokesh Gidra <lokeshgidra-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



> On Jan 22, 2020, at 5:46 PM, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> =EF=BB=BFMREMAP_DONTUNMAP is an additional flag that can be used with
> MREMAP_FIXED to move a mapping to a new address. Normally, mremap(2)
> would then tear down the old vma so subsequent accesses to the vma
> cause a segfault. However, with this new flag it will keep the old
> vma with zapping PTEs so any access to the old VMA after that point
> will result in a pagefault.

This needs a vastly better description. Perhaps:

When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is set, th=
e source mapping will not be removed. Instead it will be cleared as if a bra=
nd new anonymous, private mapping had been created atomically as part of the=
 mremap() call.  If a userfaultfd was watching the source, it will continue t=
o watch the new mapping.  For a mapping that is shared or not anonymous, MRE=
MAP_DONTUNMAP will cause the mremap() call to fail.

Or is it something else?

>=20
> This feature will find a use in ChromeOS along with userfaultfd.
> Specifically we will want to register a VMA with userfaultfd and then
> pull it out from under a running process. By using MREMAP_DONTUNMAP we
> don't have to worry about mprotecting and then potentially racing with
> VMA permission changes from a running process.

Does this mean you yank it out but you want to replace it simultaneously?

>=20
> This feature also has a use case in Android, Lokesh Gidra has said
> that "As part of using userfaultfd for GC, We'll have to move the physical=

> pages of the java heap to a separate location. For this purpose mremap
> will be used. Without the MREMAP_DONTUNMAP flag, when I mremap the java
> heap, its virtual mapping will be removed as well. Therefore, we'll
> require performing mmap immediately after. This is not only time consuming=

> but also opens a time window where a native thread may call mmap and
> reserve the java heap's address range for its own usage. This flag
> solves the problem."

Cute.=
