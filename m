From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v2 6/6] selftests: enable O and KBUILD_OUTPUT
Date: Wed, 22 Mar 2017 22:46:11 +1100
Message-ID: <87a88dcz5o.fsf@concordia.ellerman.id.au>
References: <20161129115552.8148-1-bamvor.zhangjian@huawei.com> <20161129115552.8148-7-bamvor.zhangjian@huawei.com> <CALCETrUCbGC5tmzKzYn0qE5w8omk6ZRDj4p9qz5-Ho92+W5McA@mail.gmail.com> <87fui7owls.fsf@concordia.ellerman.id.au> <CAFy1USRoKJ7G9ewLGBa1yy9V5UA+g=jo7O+eU1wV_rjKDYtJWg@mail.gmail.com> <5daf0b79-a000-2adb-0b1e-f528d66ff6df@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5daf0b79-a000-2adb-0b1e-f528d66ff6df-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Zhang Jian <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Zhangjian (Bamvor)" <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kevin Hilman <khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> writes:

> On 03/21/2017 03:00 AM, Bamvor Zhang Jian wrote:
>> On 21 March 2017 at 16:35, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>>> On Tue, Nov 29, 2016 at 3:55 AM,  <bamvor.zhangjian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>>>> From: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>
>>>>> Enable O and KBUILD_OUTPUT for kselftest. User could compile kselftest
>>>>> to another directory by passing O or KBUILD_OUTPUT. And O is high
>>>>> priority than KBUILD_OUTPUT.
>>>>
>>>> Sorry for noticing this late, but this patch
>>>> (a8ba798bc8ec663cf02e80b0dd770324de9bafd9) is really annoying for
>>>> people who *don't* use these fancy options:
>>>
>>> Yeah sorry, it wasn't quite ready to go in.
>
> Bamovar,
>
> Please give me heads up and ask me to not commit the patch,
> if you think it isn't ready.

That was me who wrote that above.

>> Do we really need "make -C tools/testing/selftests/x86 ldt_gdt_32"?
>> It is useful but it will skip the top level Makefile of selftests.
>
> Being able to build individual tests is an important use-case.

Then it needs to be tested before changes are merged.

cheers
