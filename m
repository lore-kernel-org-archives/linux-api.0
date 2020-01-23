From: Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Thu, 23 Jan 2020 11:03:44 -0800
Message-ID: <CADyq12zvTnCtkBjDZjj_dQHapFYuTh=W=KXCEa9Hy5M9DXpugg@mail.gmail.com>
References: <20200123014627.71720-1-bgeffon@google.com> <CD5EA896-7364-40E2-8709-A014973FFBC8@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CD5EA896-7364-40E2-8709-A014973FFBC8@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Michael S . Tsirkin" <mst@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Sonny Rao <sonnyrao@google.com>, Minchan Kim <minchan@kernel.org>, Joel Fernandes <joel@joelfernandes.org>, Lokesh Gidra <lokeshgidra@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Yu Zhao <yuzhao@google.com>, Jesse Barnes <jsbarnes@google.com>
List-Id: linux-api@vger.kernel.org

Andy,

Thanks, yes, that's a much clearer description of the feature. I'll
make sure to update the description with subsequent patches and with
later man page updates.

Brian

On Wed, Jan 22, 2020 at 7:02 PM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
>
>
> > On Jan 22, 2020, at 5:46 PM, Brian Geffon <bgeffon@google.com> wrote:
> >
> > =EF=BB=BFMREMAP_DONTUNMAP is an additional flag that can be used with
> > MREMAP_FIXED to move a mapping to a new address. Normally, mremap(2)
> > would then tear down the old vma so subsequent accesses to the vma
> > cause a segfault. However, with this new flag it will keep the old
> > vma with zapping PTEs so any access to the old VMA after that point
> > will result in a pagefault.
>
> This needs a vastly better description. Perhaps:
>
> When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is set,=
 the source mapping will not be removed. Instead it will be cleared as if a=
 brand new anonymous, private mapping had been created atomically as part o=
f the mremap() call.  If a userfaultfd was watching the source, it will con=
tinue to watch the new mapping.  For a mapping that is shared or not anonym=
ous, MREMAP_DONTUNMAP will cause the mremap() call to fail.
>
> Or is it something else?
>
> >
> > This feature will find a use in ChromeOS along with userfaultfd.
> > Specifically we will want to register a VMA with userfaultfd and then
> > pull it out from under a running process. By using MREMAP_DONTUNMAP we
> > don't have to worry about mprotecting and then potentially racing with
> > VMA permission changes from a running process.
>
> Does this mean you yank it out but you want to replace it simultaneously?
>
> >
> > This feature also has a use case in Android, Lokesh Gidra has said
> > that "As part of using userfaultfd for GC, We'll have to move the physi=
cal
> > pages of the java heap to a separate location. For this purpose mremap
> > will be used. Without the MREMAP_DONTUNMAP flag, when I mremap the java
> > heap, its virtual mapping will be removed as well. Therefore, we'll
> > require performing mmap immediately after. This is not only time consum=
ing
> > but also opens a time window where a native thread may call mmap and
> > reserve the java heap's address range for its own usage. This flag
> > solves the problem."
>
> Cute.
