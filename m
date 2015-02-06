From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/2] kernel/fork: handle put_user errors for CLONE_PARENT_SETTID
Date: Fri, 6 Feb 2015 13:55:04 -0800
Message-ID: <CALCETrXRn76TTe8BWtBiwMP2Nted-KWxWQjZEeGFyJmJEODiyQ@mail.gmail.com>
References: <20150206162301.18031.32251.stgit@buzz> <20150206162303.18031.37408.stgit@buzz>
 <CA+55aFxBuf-0UkoYCrwH_vNsWFnUkFOz5c9O_Mswe_w0BTkqbQ@mail.gmail.com> <CALYGNiMv021=WC2uXsjo5zT8JwewweZUDdk0x8FGHh9V5j6bFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALYGNiMv021=WC2uXsjo5zT8JwewweZUDdk0x8FGHh9V5j6bFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Roman Gushchin <klamm@yandex-team.ru>, Nikita Vetoshkin <nekto0n@yandex-team.ru>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 6, 2015 at 1:13 PM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> On Fri, Feb 6, 2015 at 11:49 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Fri, Feb 6, 2015 at 8:23 AM, Konstantin Khlebnikov
>> <khlebnikov@yandex-team.ru> wrote:
>>> Handling of flag CLONE_PARENT_SETTID has the same problem: error returned
>>> from put_user() is ignored. Glibc completely relies on that feature and uses
>>> value returned from syscall only for error checking.
>>
>> I'm not seeing the advantage of the error checking part of the pacth
>> patch. It generates extra code, possibly changing existing interfaces,
>> and it doesn't actually buy us anything.
>>
>> What's the upside? If somebody passes in a bad pointer, it's their
>> problem. For all we know, people used to pass in NULL, even if they
>> had the SETTID bit set. This makes it now return EFAULT.
>
> Currently that works fine only because kernel retries 0-order allocations
> endlessly. But pagefault_out_of_memory() is never called for non-user PF.
> For kernel PF all oom-kills are triggered by buddy-allocator.
> If buddy allocator gave up earlier then page-faults from kernel space
> could fail without OOM. And in CoW area user-space will see stale data.
> So, either we must handle all put_user/copy_to_user errors (which isn't
> that bad idea) or kernel must force all PF to success-or-die policy.
>
> First patch is that ugly because kernel has never checked errors
> in that place. So, I've tried to find solution which could fix problem
> without breaking backward compatibility.

If you're really worried about compatibility, it would be possible, if
really really ugly, to check whether there's a vma at all at the
requested address and to return -EFAULT only in the case where there
is a vma but put_user still failed.

A less awful approach might be to accept put_user failures if the
address is NULL.

--Andy
