From: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests/mount: output error messages when mount test
 fail
Date: Fri, 3 Apr 2015 09:17:28 +0800
Message-ID: <551DEA28.6040509@huawei.com>
References: <1427957214-40367-1-git-send-email-zhenzhang.zhang@huawei.com> <551CE72E.3050303@huawei.com> <87r3s2qrzc.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r3s2qrzc.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2015/4/3 2:56, Eric W. Biederman wrote:
> Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> writes:
>=20
>> Without this patch, if /proc/self/uid_map is not exist,
>> the mount test case will fail and no any prompting.
>=20
> The intent was not to fail if /proc/self/uid_map is missing but to sk=
ip
> the test because it is not applicable.
>=20
> Making this an error seems wrong.  Even if I did mess up the shell
> script error propagation and made it an error by accident.
>=20
Ok=EF=BC=8C modify the output messages as follows=EF=BC=9A
WARN: No /proc/self/uid_map exist, test skipped.

Do you think this modification right?

Best regards!
>> After applied this patch, the case will prompt why it fail.
>> Just as follows:
>> root@kernel-host:/opt/kernel> make -C tools/testing/selftests TARGET=
S=3Dmount run_tests
>> make: Entering directory `/opt/kernel/tools/testing/selftests'
>> for TARGET in mount; do \
>>                 make -C $TARGET; \
>>         done;
>> make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mou=
nt'
>> make[1]: Nothing to be done for `all'.
>> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/moun=
t'
>> for TARGET in mount; do \
>>                 make -C $TARGET run_tests; \
>>         done;
>> make[1]: Entering directory `/opt/kernel/tools/testing/selftests/mou=
nt'
>> ERROR: No /proc/self/uid_map exist
>> make[1]: Leaving directory `/opt/kernel/tools/testing/selftests/moun=
t'
>> make: Leaving directory `/opt/kernel/tools/testing/selftests'
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  tools/testing/selftests/mount/Makefile | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/=
selftests/mount/Makefile
>> index a5b367f..b3266db 100644
>> --- a/tools/testing/selftests/mount/Makefile
>> +++ b/tools/testing/selftests/mount/Makefile
>> @@ -8,7 +8,12 @@ unprivileged-remount-test: unprivileged-remount-tes=
t.c
>>  include ../lib.mk
>>
>>  TEST_PROGS :=3D unprivileged-remount-test
>> -override RUN_TESTS :=3D if [ -f /proc/self/uid_map ] ; then ./unpri=
vileged-remount-test ; fi
>> +override RUN_TESTS :=3D  @if [ -f /proc/self/uid_map ] ; \
>> +			then	\
>> +				./unprivileged-remount-test ; \
>> +			else	\
>> +				echo "ERROR: No /proc/self/uid_map exist" ; \
>> +			fi
>>  override EMIT_TESTS :=3D echo "$(RUN_TESTS)"
>>
>>  clean:
>=20
>=20
