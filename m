From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Tue, 21 Mar 2017 19:35:59 +1100
Message-ID: <87fui7owls.fsf@concordia.ellerman.id.au>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com> <20161129115552.8148-7-bamvor.zhangjian@huawei.com> <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:

> On Tue, Nov 29, 2016 at 3:55 AM,  <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
>> to another directory by passing O or KBUILD_OUTPUT. And O is high
>> priority than KBUILD_OUTPUT.
>
> Sorry for noticing this late, but this patch
> (a8ba798bc8ec663cf02e80b0dd770324de9bafd9) is really annoying for
> people who *don't* use these fancy options:

Yeah sorry, it wasn't quite ready to go in.

> $ make -C tools/testing/selftests/x86 ldt_gdt_32
> make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
> Makefile:44: warning: overriding recipe for target 'clean'
> ../lib.mk:55: warning: ignoring old recipe for target 'clean'
> make: *** No rule to make target 'ldt_gdt_32'.  Stop.
> make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'
>
> Is there any way that you can make this work again?

There obviously is *a* way, but I'm not sure there's a simple and
obviously correct way that is an easy fix for 4.11.

I see at least 18 Makefile's in tools/testing/selftests that use
$(OUTPUT)/, which would all need to be updated at least to use $(OUTPUT)
(no trailing slash), and then some other changes to not propagate OUTPUT
when the user didn't specify it. But hopefully someone will prove me
wrong.

As a (poor) alternative you can do:

 $ cd tools/testing/selftests/x86; make $PWD/ldt_gdt_32

or just:

 $ make -C tools/testing/selftests/x86

cheers
