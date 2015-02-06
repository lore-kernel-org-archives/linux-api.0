From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH 2/2] kernel/fork: handle put_user errors for CLONE_PARENT_SETTID
Date: Sat, 7 Feb 2015 00:13:24 +0300
Message-ID: <CALYGNiMv021=WC2uXsjo5zT8JwewweZUDdk0x8FGHh9V5j6bFQ@mail.gmail.com>
References: <20150206162301.18031.32251.stgit@buzz>
	<20150206162303.18031.37408.stgit@buzz>
	<CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Roman Gushchin <klamm@yandex-team.ru>, Nikita Vetoshkin <nekto0n@yandex-team.ru>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 6, 2015 at 11:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Feb 6, 2015 at 8:23 AM, Konstantin Khlebnikov
> <khlebnikov@yandex-team.ru> wrote:
>> Handling of flag CLONE_PARENT_SETTID has the same problem: error returned
>> from put_user() is ignored. Glibc completely relies on that feature and uses
>> value returned from syscall only for error checking.
>
> I'm not seeing the advantage of the error checking part of the pacth
> patch. It generates extra code, possibly changing existing interfaces,
> and it doesn't actually buy us anything.
>
> What's the upside? If somebody passes in a bad pointer, it's their
> problem. For all we know, people used to pass in NULL, even if they
> had the SETTID bit set. This makes it now return EFAULT.

Currently that works fine only because kernel retries 0-order allocations
endlessly. But pagefault_out_of_memory() is never called for non-user PF.
For kernel PF all oom-kills are triggered by buddy-allocator.
If buddy allocator gave up earlier then page-faults from kernel space
could fail without OOM. And in CoW area user-space will see stale data.
So, either we must handle all put_user/copy_to_user errors (which isn't
that bad idea) or kernel must force all PF to success-or-die policy.

First patch is that ugly because kernel has never checked errors
in that place. So, I've tried to find solution which could fix problem
without breaking backward compatibility.

>
> So I don't mind moving things into copy_process(), but I *do* mind the
> new error return thing.
>
> It's actually better in this patch than in 1/2, because 1/2 was just
> insane with the whole "readable vs writable" thing. That I refuse to
> even look at, for fear of going blind.
>
>                       Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
