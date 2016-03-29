From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [RFC v1 03/17] selftest/seccomp: Fix the flag name
 SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 29 Mar 2016 09:35:40 -0600
Message-ID: <56FAA0CC.2050201@osg.samsung.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458784008-16277-4-git-send-email-mic@digikod.net>
 <CAGXu5jKArYiYi4EDw=H9Kj3DQYgD0Q51Tfwc85wCTv_TN+X03w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKArYiYi4EDw=H9Kj3DQYgD0Q51Tfwc85wCTv_TN+X03w@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Shuah Khan <shuahkh@osg.samsung>
List-Id: linux-api@vger.kernel.org

On 03/23/2016 10:35 PM, Kees Cook wrote:
> On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>> Rename SECCOMP_FLAG_FILTER_TSYNC to SECCOMP_FILTER_FLAG_TSYNC to mat=
ch
>> the UAPI.
>>
>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Will Drewry <wad@chromium.org>
>=20
> Hah, oops. Thanks! Shuah, can you take this patch into the selftest t=
ree?
>=20
> Acked-by: Kees Cook <keescook@chromium.org>
>=20

Hi Michael,

Could you please send me the patch. I can't find it in my Inbox. I can =
get
this into rc-2 with Kees Cook's ack.

thanks,
-- Shuah
>=20
>> ---
>>  tools/testing/selftests/seccomp/seccomp_bpf.c | 18 +++++++++-------=
--
>>  1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/t=
esting/selftests/seccomp/seccomp_bpf.c
>> index b9453b838162..9c1460f277c2 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -1497,8 +1497,8 @@ TEST_F(TRACE_syscall, syscall_dropped)
>>  #define SECCOMP_SET_MODE_FILTER 1
>>  #endif
>>
>> -#ifndef SECCOMP_FLAG_FILTER_TSYNC
>> -#define SECCOMP_FLAG_FILTER_TSYNC 1
>> +#ifndef SECCOMP_FILTER_FLAG_TSYNC
>> +#define SECCOMP_FILTER_FLAG_TSYNC 1
>>  #endif
>>
>>  #ifndef seccomp
>> @@ -1613,7 +1613,7 @@ TEST(TSYNC_first)
>>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!=
");
>>         }
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &prog);
>>         ASSERT_NE(ENOSYS, errno) {
>>                 TH_LOG("Kernel does not support seccomp syscall!");
>> @@ -1831,7 +1831,7 @@ TEST_F(TSYNC, two_siblings_with_ancestor)
>>                 self->sibling_count++;
>>         }
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &self->apply_prog);
>>         ASSERT_EQ(0, ret) {
>>                 TH_LOG("Could install filter on all threads!");
>> @@ -1892,7 +1892,7 @@ TEST_F(TSYNC, two_siblings_with_no_filter)
>>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!=
");
>>         }
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &self->apply_prog);
>>         ASSERT_NE(ENOSYS, errno) {
>>                 TH_LOG("Kernel does not support seccomp syscall!");
>> @@ -1940,7 +1940,7 @@ TEST_F(TSYNC, two_siblings_with_one_divergence=
)
>>                 self->sibling_count++;
>>         }
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &self->apply_prog);
>>         ASSERT_EQ(self->sibling[0].system_tid, ret) {
>>                 TH_LOG("Did not fail on diverged sibling.");
>> @@ -1992,7 +1992,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>>                 TH_LOG("Kernel does not support SECCOMP_SET_MODE_FIL=
TER!");
>>         }
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &self->apply_prog);
>>         ASSERT_EQ(ret, self->sibling[0].system_tid) {
>>                 TH_LOG("Did not fail on diverged sibling.");
>> @@ -2021,7 +2021,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>>         /* Switch to the remaining sibling */
>>         sib =3D !sib;
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &self->apply_prog);
>>         ASSERT_EQ(0, ret) {
>>                 TH_LOG("Expected the remaining sibling to sync");
>> @@ -2044,7 +2044,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>>         while (!kill(self->sibling[sib].system_tid, 0))
>>                 sleep(0.1);
>>
>> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER=
_TSYNC,
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG=
_TSYNC,
>>                       &self->apply_prog);
>>         ASSERT_EQ(0, ret);  /* just us chickens */
>>  }
>> --
>> 2.8.0.rc3
>>
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
