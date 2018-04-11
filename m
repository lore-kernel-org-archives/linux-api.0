From: Justin Forbes <jmforbes@linuxtx.org>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running
 kernel image
Date: Wed, 11 Apr 2018 13:35:29 -0500
Message-ID: <CAFxkdApe5gFJC2RZi-aQ0jTMDabi3QR5AnJde5QT7aVfTvzoNQ@mail.gmail.com>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk> <CA+55aFzPo-dip8dgyo0U+g5qai9SAJU+D1c+AFJ0zV9_PBAB8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzPo-dip8dgyo0U+g5qai9SAJU+D1c+AFJ0zV9_PBAB8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 11, 2018 at 1:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 11, 2018 at 9:24 AM, David Howells <dhowells@redhat.com> wrote:
>> Provide a single call to allow kernel code to determine whether the system
>> should be locked down, thereby disallowing various accesses that might
>> allow the running kernel image to be changed, including:
>>
>>  - /dev/mem and similar
>>  - Loading of unauthorised modules
>>  - Fiddling with MSR registers
>>  - Suspend to disk managed by the kernel
>>  - Use of device DMA
>
> So what I stlll absolutely detest about  this series is that I think
> many of these things should simply be done as separate config options.
>
> For example, if the distro is sure that it doesn't need /dev/mem, then
> why the hell is  this tied to "lockdown" that then may have to be
> disabled because *other* changes may not be acceptable (eg people may
> need that device DMA, or whatever).
>
> If that /dev/mem access prevention was just instead done as an even
> stricter mode of the existing CONFIG_STRICT_DEVMEM, it could just be
> enabled unconditionally.
>
> So none of these patches raise my hackles per se. But what continues
> to makes me very very uncomfortable is how this is all tied together.
>
> Why is this one magical mode that then - because it has such a big
> impact - has to be enabled/disabled as a single magical mode and with
> very odd rules?
>
> I think a lot of people would be happier if this wasn't so incestuous
> and mixing together independent things under one name, and one flag.
>
> I think a lot of the secure boot problems were exacerbated by that mixup.
>
> So I would seriously ask that the distros that have been using these
> patches look at which parts of lockdown they could make unconditional
> (because it doesn't break machines), and which ones need that escape
> clause.
>

Optionally, it might make sense to add separate config options for
each of these pieces which can be unconditionally enabled, and a
separate option for secure boot which selects all of them? As much as
I hate select, it might make sense here.  Of course the flip side to
that, is users no longer have one big switch "turn off secure boot"
which turns it all off in case of trouble.

Justin
