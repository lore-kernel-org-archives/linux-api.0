From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] selftests/memfd: Run test on all architectures
Date: Wed, 17 Sep 2014 17:39:53 +0200
Message-ID: <CANq1E4QP_=tqGLo6cHp1O8w-gbbu0Gvn-7MuxV2Hq6YXCOzULQ@mail.gmail.com>
References: <1410821984-11160-1-git-send-email-bobby.prani@gmail.com>
	<CANq1E4Q_KfDamkCMatGFYCQ0VPfc6tbd7sWT_z_qDeboiNzgNw@mail.gmail.com>
	<5419AA71.4020506@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5419AA71.4020506-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Phong Tran <tranmanphong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:KERNEL SELFTEST F..." <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Wed, Sep 17, 2014 at 5:36 PM, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org> w=
rote:
> On 09/17/2014 06:28 AM, David Herrmann wrote:
>> Hi
>>
>> On Tue, Sep 16, 2014 at 12:59 AM, Pranith Kumar <bobby.prani@gmail.c=
om> wrote:
>>> Remove the dependence on x86 to run the memfd test. Verfied on 32-b=
it powerpc.
>>>
>>> Signed-off-by: Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Now that most archs have __NR_memfd_create, this is:
>>
>> Reviewed-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>
> Hmm. I am seeing failures on x86_64 on top of Linus's tree
> (without this patch)
>
> make -C tools/testing/selftests/memfd/make: Entering directory
> `/lkml/linus_git_3.14/tools/testing/selftests/memfd'
> gcc -D_FILE_OFFSET_BITS=3D64
> -I../../../../arch/x86/include/generated/uapi/
> -I../../../../arch/x86/include/uapi/ -I../../../../include/uapi/
> -I../../../../include/ memfd_test.c -o memfd_test
> memfd_test.c: In function =E2=80=98sys_memfd_create=E2=80=99:
> memfd_test.c:26:17: error: =E2=80=98__NR_memfd_create=E2=80=99 undecl=
ared (first use in
> this function)
>   return syscall(__NR_memfd_create, name, flags);
>                  ^
> memfd_test.c:26:17: note: each undeclared identifier is reported only
> once for each function it appears in
>
> Could you please look into this?? It appears __NR_memfd_create isn't
> defined on x86_64???

You need the headers installed in your system. By dropping the
arch-includes from the Makefile, we require 3.17 headers in
/usr/include.

Thanks
David
