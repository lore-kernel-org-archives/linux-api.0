From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests/memfd: Run test on all architectures
Date: Wed, 17 Sep 2014 09:36:17 -0600
Message-ID: <5419AA71.4020506@osg.samsung.com>
References: <1410821984-11160-1-git-send-email-bobby.prani@gmail.com> <CANq1E4Q_KfDamkCMatGFYCQ0VPfc6tbd7sWT_z_qDeboiNzgNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANq1E4Q_KfDamkCMatGFYCQ0VPfc6tbd7sWT_z_qDeboiNzgNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Herrmann <dh.herrmann@gmail.com>, Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Phong Tran <tranmanphong@gmail.com>, "open list:KERNEL SELFTEST F..." <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

On 09/17/2014 06:28 AM, David Herrmann wrote:
> Hi
>=20
> On Tue, Sep 16, 2014 at 12:59 AM, Pranith Kumar <bobby.prani@gmail.co=
m> wrote:
>> Remove the dependence on x86 to run the memfd test. Verfied on 32-bi=
t powerpc.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>=20
> Now that most archs have __NR_memfd_create, this is:
>=20
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>=20

Hmm. I am seeing failures on x86_64 on top of Linus's tree
(without this patch)

make -C tools/testing/selftests/memfd/make: Entering directory
`/lkml/linus_git_3.14/tools/testing/selftests/memfd'
gcc -D_FILE_OFFSET_BITS=3D64
-I../../../../arch/x86/include/generated/uapi/
-I../../../../arch/x86/include/uapi/ -I../../../../include/uapi/
-I../../../../include/ memfd_test.c -o memfd_test
memfd_test.c: In function =E2=80=98sys_memfd_create=E2=80=99:
memfd_test.c:26:17: error: =E2=80=98__NR_memfd_create=E2=80=99 undeclar=
ed (first use in
this function)
  return syscall(__NR_memfd_create, name, flags);
                 ^
memfd_test.c:26:17: note: each undeclared identifier is reported only
once for each function it appears in

Could you please look into this?? It appears __NR_memfd_create isn't
defined on x86_64???

thanks,
-- Shuah

--=20
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
