From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Mon, 20 Mar 2017 14:39:36 -0700
Message-ID: <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com> <20161129115552.8148-7-bamvor.zhangjian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129115552.8148-7-bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 29, 2016 at 3:55 AM,  <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
> to another directory by passing O or KBUILD_OUTPUT. And O is high
> priority than KBUILD_OUTPUT.

Sorry for noticing this late, but this patch
(a8ba798bc8ec663cf02e80b0dd770324de9bafd9) is really annoying for
people who *don't* use these fancy options:

$ make -C tools/testing/selftests/x86 ldt_gdt_32
make: Entering directory '/home/luto/apps/linux/tools/testing/selftests/x86'
Makefile:44: warning: overriding recipe for target 'clean'
../lib.mk:55: warning: ignoring old recipe for target 'clean'
make: *** No rule to make target 'ldt_gdt_32'.  Stop.
make: Leaving directory '/home/luto/apps/linux/tools/testing/selftests/x86'

Is there any way that you can make this work again?

--Andy
