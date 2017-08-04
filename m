From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 5/6] seccomp: Action to log before allowing
Date: Fri, 4 Aug 2017 17:57:11 -0500
Message-ID: <cc04e6c2-9a8e-c372-903e-df88060ff629@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-6-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+OBvR_r7nkW3e-Ea16UygfqeFfQNm_w51TopLtf7AD6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="BA6BoNc434txts5btbBARL23qK6CCELtP"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+OBvR_r7nkW3e-Ea16UygfqeFfQNm_w51TopLtf7AD6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BA6BoNc434txts5btbBARL23qK6CCELtP
Content-Type: multipart/mixed; boundary="joEoVjewKl1nUQtWsj5L2KAWS1EUixaVA";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <cc04e6c2-9a8e-c372-903e-df88060ff629-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 5/6] seccomp: Action to log before allowing
References: <1501275352-30045-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <1501275352-30045-6-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CAGXu5j+OBvR_r7nkW3e-Ea16UygfqeFfQNm_w51TopLtf7AD6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAGXu5j+OBvR_r7nkW3e-Ea16UygfqeFfQNm_w51TopLtf7AD6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--joEoVjewKl1nUQtWsj5L2KAWS1EUixaVA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/03/2017 11:56 AM, Kees Cook wrote:
> On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wr=
ote:
>> Add a new action, SECCOMP_RET_LOG, that logs a syscall before allowing=

>> the syscall. At the implementation level, this action is identical to
>> the existing SECCOMP_RET_ALLOW action. However, it can be very useful =
when
>> initially developing a seccomp filter for an application. The develope=
r
>> can set the default action to be SECCOMP_RET_LOG, maybe mark any
>> obviously needed syscalls with SECCOMP_RET_ALLOW, and then put the
>> application through its paces. A list of syscalls that triggered the
>> default action (SECCOMP_RET_LOG) can be easily gleaned from the logs a=
nd
>> that list can be used to build the syscall whitelist. Finally, the
>> developer can change the default action to the desired value.
>>
>> This provides a more friendly experience than seeing the application g=
et
>> killed, then updating the filter and rebuilding the app, seeing the
>> application get killed due to a different syscall, then updating the
>> filter and rebuilding the app, etc.
>>
>> The functionality is similar to what's supported by the various LSMs.
>> SELinux has permissive mode, AppArmor has complain mode, SMACK has
>> bring-up mode, etc.
>>
>> SECCOMP_RET_LOG is given a lower value than SECCOMP_RET_ALLOW as allow=

>> while logging is slightly more restrictive than quietly allowing.
>>
>> Unfortunately, the tests added for SECCOMP_RET_LOG are not capable of
>> inspecting the audit log to verify that the syscall was logged.
>>
>> Signed-off-by: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>
>> * Change since v4:
>>   - folded the previously separate selftest patch into this patch
>>   - add TODO to verify that RET_LOG generates log messages in selftest=
s
>>   - adjust for new reStructuredText format
>>
>>  Documentation/userspace-api/seccomp_filter.rst |  6 ++
>>  include/uapi/linux/seccomp.h                   |  1 +
>>  kernel/seccomp.c                               | 17 ++++-
>>  tools/testing/selftests/seccomp/seccomp_bpf.c  | 97 +++++++++++++++++=
++++++++-
>>  4 files changed, 118 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Document=
ation/userspace-api/seccomp_filter.rst
>> index 2d1d8ab..2ece856 100644
>> --- a/Documentation/userspace-api/seccomp_filter.rst
>> +++ b/Documentation/userspace-api/seccomp_filter.rst
>> @@ -141,6 +141,12 @@ In precedence order, they are:
>>         allow use of ptrace, even of other sandboxed processes, withou=
t
>>         extreme care; ptracers can use this mechanism to escape.)
>>
>> +``SECCOMP_RET_LOG``:
>> +       Results in the system call being executed after it is logged. =
This
>> +       should be used by application developers to learn which syscal=
ls their
>> +       application needs without having to iterate through multiple t=
est and
>> +       development cycles to build the list.
>=20
> Perhaps this should note that it'll only be logged if the admin has
> left the default sysctl value alone.
>=20

Good idea. I'll add something about that.

Tyler

>> +
>>  ``SECCOMP_RET_ALLOW``:
>>         Results in the system call being executed.
>>
>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp=
=2Eh
>> index 19a611d..f944332 100644
>> --- a/include/uapi/linux/seccomp.h
>> +++ b/include/uapi/linux/seccomp.h
>> @@ -31,6 +31,7 @@
>>  #define SECCOMP_RET_TRAP       0x00030000U /* disallow and force a SI=
GSYS */
>>  #define SECCOMP_RET_ERRNO      0x00050000U /* returns an errno */
>>  #define SECCOMP_RET_TRACE      0x7ff00000U /* pass to a tracer or dis=
allow */
>> +#define SECCOMP_RET_LOG                0x7ffc0000U /* allow after log=
ging */
>>  #define SECCOMP_RET_ALLOW      0x7fff0000U /* allow */
>>
>>  /* Masks for the return value sections. */
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 03ad3ba..c12d3dd 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -533,10 +533,12 @@ static void seccomp_send_sigsys(int syscall, int=
 reason)
>>  #define SECCOMP_LOG_TRAP               (1 << 2)
>>  #define SECCOMP_LOG_ERRNO              (1 << 3)
>>  #define SECCOMP_LOG_TRACE              (1 << 4)
>> -#define SECCOMP_LOG_ALLOW              (1 << 5)
>> +#define SECCOMP_LOG_LOG                        (1 << 5)
>> +#define SECCOMP_LOG_ALLOW              (1 << 6)
>>
>>  static u32 seccomp_actions_logged =3D SECCOMP_LOG_KILL  | SECCOMP_LOG=
_TRAP  |
>> -                                   SECCOMP_LOG_ERRNO | SECCOMP_LOG_TR=
ACE;
>> +                                   SECCOMP_LOG_ERRNO | SECCOMP_LOG_TR=
ACE |
>> +                                   SECCOMP_LOG_LOG;
>>
>>  static inline void seccomp_log(unsigned long syscall, long signr, u32=
 action,
>>                                bool requested)
>> @@ -554,6 +556,9 @@ static inline void seccomp_log(unsigned long sysca=
ll, long signr, u32 action,
>>                 case SECCOMP_RET_TRACE:
>>                         log =3D seccomp_actions_logged & SECCOMP_LOG_T=
RACE;
>>                         break;
>> +               case SECCOMP_RET_LOG:
>> +                       log =3D seccomp_actions_logged & SECCOMP_LOG_L=
OG;
>> +                       break;
>>                 case SECCOMP_RET_ALLOW:
>>                         log =3D false;
>>                         break;
>> @@ -701,6 +706,10 @@ static int __seccomp_filter(int this_syscall, con=
st struct seccomp_data *sd,
>>
>>                 return 0;
>>
>> +       case SECCOMP_RET_LOG:
>> +               seccomp_log(this_syscall, 0, action, true);
>> +               return 0;
>> +
>>         case SECCOMP_RET_ALLOW:
>>                 return 0;
>>
>> @@ -870,6 +879,7 @@ static long seccomp_get_action_avail(const char __=
user *uaction)
>>         case SECCOMP_RET_TRAP:
>>         case SECCOMP_RET_ERRNO:
>>         case SECCOMP_RET_TRACE:
>> +       case SECCOMP_RET_LOG:
>>         case SECCOMP_RET_ALLOW:
>>                 break;
>>         default:
>> @@ -1020,12 +1030,14 @@ long seccomp_get_filter(struct task_struct *ta=
sk, unsigned long filter_off,
>>  #define SECCOMP_RET_TRAP_NAME          "trap"
>>  #define SECCOMP_RET_ERRNO_NAME         "errno"
>>  #define SECCOMP_RET_TRACE_NAME         "trace"
>> +#define SECCOMP_RET_LOG_NAME           "log"
>>  #define SECCOMP_RET_ALLOW_NAME         "allow"
>>
>>  static const char seccomp_actions_avail[] =3D SECCOMP_RET_KILL_NAME  =
    " "
>>                                             SECCOMP_RET_TRAP_NAME     =
  " "
>>                                             SECCOMP_RET_ERRNO_NAME    =
  " "
>>                                             SECCOMP_RET_TRACE_NAME    =
  " "
>> +                                           SECCOMP_RET_LOG_NAME      =
  " "
>>                                             SECCOMP_RET_ALLOW_NAME;
>>
>>  #define SECCOMP_ACTIONS_AVAIL_LEN      strlen(seccomp_actions_avail)
>> @@ -1040,6 +1052,7 @@ static const struct seccomp_log_name seccomp_log=
_names[] =3D {
>>         { SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
>>         { SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
>>         { SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
>> +       { SECCOMP_LOG_LOG, SECCOMP_RET_LOG_NAME },
>>         { SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
>>         { }
>>  };
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/tes=
ting/selftests/seccomp/seccomp_bpf.c
>> index 8f0872b..040e875 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -87,6 +87,10 @@ struct seccomp_data {
>>  };
>>  #endif
>>
>> +#ifndef SECCOMP_RET_LOG
>> +#define SECCOMP_RET_LOG       0x7ffc0000U /* allow after logging */
>> +#endif
>> +
>>  #if __BYTE_ORDER =3D=3D __LITTLE_ENDIAN
>>  #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
>>  #elif __BYTE_ORDER =3D=3D __BIG_ENDIAN
>> @@ -342,6 +346,28 @@ TEST(empty_prog)
>>         EXPECT_EQ(EINVAL, errno);
>>  }
>>
>> +TEST(log_all)
>> +{
>> +       struct sock_filter filter[] =3D {
>> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_LOG),
>> +       };
>> +       struct sock_fprog prog =3D {
>> +               .len =3D (unsigned short)ARRAY_SIZE(filter),
>> +               .filter =3D filter,
>> +       };
>> +       long ret;
>> +       pid_t parent =3D getppid();
>> +
>> +       ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
>> +       ASSERT_EQ(0, ret);
>> +
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
>> +       ASSERT_EQ(0, ret);
>> +
>> +       /* getppid() should succeed and be logged (no check for loggin=
g) */
>> +       EXPECT_EQ(parent, syscall(__NR_getppid));
>> +}
>> +
>>  TEST_SIGNAL(unknown_ret_is_kill_inside, SIGSYS)
>>  {
>>         struct sock_filter filter[] =3D {
>> @@ -735,6 +761,7 @@ TEST_F(TRAP, handler)
>>
>>  FIXTURE_DATA(precedence) {
>>         struct sock_fprog allow;
>> +       struct sock_fprog log;
>>         struct sock_fprog trace;
>>         struct sock_fprog error;
>>         struct sock_fprog trap;
>> @@ -746,6 +773,13 @@ FIXTURE_SETUP(precedence)
>>         struct sock_filter allow_insns[] =3D {
>>                 BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
>>         };
>> +       struct sock_filter log_insns[] =3D {
>> +               BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
>> +                       offsetof(struct seccomp_data, nr)),
>> +               BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 1, 0),
>> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
>> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_LOG),
>> +       };
>>         struct sock_filter trace_insns[] =3D {
>>                 BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
>>                         offsetof(struct seccomp_data, nr)),
>> @@ -782,6 +816,7 @@ FIXTURE_SETUP(precedence)
>>         memcpy(self->_x.filter, &_x##_insns, sizeof(_x##_insns)); \
>>         self->_x.len =3D (unsigned short)ARRAY_SIZE(_x##_insns)
>>         FILTER_ALLOC(allow);
>> +       FILTER_ALLOC(log);
>>         FILTER_ALLOC(trace);
>>         FILTER_ALLOC(error);
>>         FILTER_ALLOC(trap);
>> @@ -792,6 +827,7 @@ FIXTURE_TEARDOWN(precedence)
>>  {
>>  #define FILTER_FREE(_x) if (self->_x.filter) free(self->_x.filter)
>>         FILTER_FREE(allow);
>> +       FILTER_FREE(log);
>>         FILTER_FREE(trace);
>>         FILTER_FREE(error);
>>         FILTER_FREE(trap);
>> @@ -809,6 +845,8 @@ TEST_F(precedence, allow_ok)
>>
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>> @@ -833,6 +871,8 @@ TEST_F_SIGNAL(precedence, kill_is_highest, SIGSYS)=

>>
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>> @@ -864,6 +904,8 @@ TEST_F_SIGNAL(precedence, kill_is_highest_in_any_o=
rder, SIGSYS)
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap=
);
>> @@ -885,6 +927,8 @@ TEST_F_SIGNAL(precedence, trap_is_second, SIGSYS)
>>
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>> @@ -910,6 +954,8 @@ TEST_F_SIGNAL(precedence, trap_is_second_in_any_or=
der, SIGSYS)
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trap=
);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>> @@ -931,6 +977,8 @@ TEST_F(precedence, errno_is_third)
>>
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>> @@ -949,6 +997,8 @@ TEST_F(precedence, errno_is_third_in_any_order)
>>         ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
>>         ASSERT_EQ(0, ret);
>>
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->erro=
r);
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>> @@ -971,6 +1021,8 @@ TEST_F(precedence, trace_is_fourth)
>>
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->trac=
e);
>>         ASSERT_EQ(0, ret);
>>         /* Should work just fine. */
>> @@ -992,12 +1044,54 @@ TEST_F(precedence, trace_is_fourth_in_any_order=
)
>>         ASSERT_EQ(0, ret);
>>         ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>>         ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>>         /* Should work just fine. */
>>         EXPECT_EQ(parent, syscall(__NR_getppid));
>>         /* No ptracer */
>>         EXPECT_EQ(-1, syscall(__NR_getpid));
>>  }
>>
>> +TEST_F(precedence, log_is_fifth)
>> +{
>> +       pid_t mypid, parent;
>> +       long ret;
>> +
>> +       mypid =3D getpid();
>> +       parent =3D getppid();
>> +       ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
>> +       ASSERT_EQ(0, ret);
>> +
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>> +       ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>> +       /* Should work just fine. */
>> +       EXPECT_EQ(parent, syscall(__NR_getppid));
>> +       /* Should also work just fine */
>> +       EXPECT_EQ(mypid, syscall(__NR_getpid));
>> +}
>> +
>> +TEST_F(precedence, log_is_fifth_in_any_order)
>> +{
>> +       pid_t mypid, parent;
>> +       long ret;
>> +
>> +       mypid =3D getpid();
>> +       parent =3D getppid();
>> +       ret =3D prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
>> +       ASSERT_EQ(0, ret);
>> +
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->log)=
;
>> +       ASSERT_EQ(0, ret);
>> +       ret =3D prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &self->allo=
w);
>> +       ASSERT_EQ(0, ret);
>> +       /* Should work just fine. */
>> +       EXPECT_EQ(parent, syscall(__NR_getppid));
>> +       /* Should also work just fine */
>> +       EXPECT_EQ(mypid, syscall(__NR_getpid));
>> +}
>> +
>>  #ifndef PTRACE_O_TRACESECCOMP
>>  #define PTRACE_O_TRACESECCOMP  0x00000080
>>  #endif
>> @@ -2494,7 +2588,7 @@ TEST(get_action_avail)
>>  {
>>         __u32 actions[] =3D { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
>>                             SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE,
>> -                           SECCOMP_RET_ALLOW };
>> +                           SECCOMP_RET_LOG,   SECCOMP_RET_ALLOW };
>>         __u32 unknown_action =3D 0x10000000U;
>>         int i;
>>         long ret;
>> @@ -2531,6 +2625,7 @@ TEST(get_action_avail)
>>   * - 64-bit arg prodding
>>   * - arch value testing (x86 modes especially)
>>   * - verify that FILTER_FLAG_LOG filters generate log messages
>> + * - verify that RET_LOG generates log messages
>>   * - ...
>>   */
>>
>> --
>> 2.7.4
>>
>=20
> Test updates look great, thanks!
>=20
> -Kees
>=20



--joEoVjewKl1nUQtWsj5L2KAWS1EUixaVA--

--BA6BoNc434txts5btbBARL23qK6CCELtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZhPvHAAoJENaSAD2qAscKb+4QAM8B+bgSPW0kqlmoNfCBl3BJ
/ge3ye19sBHr2DmNhbhBtB9hSXRGDyr16v2RtX0SNoxC2MpOMJ8icOJxLr6umTg9
3y007NgwiLs8NATuDYbFz6yoL82yj6lgRy21AaQMbWiXsIroJmaN5d5UHZpJVWXz
DvoTUhC/pQJcRpv0fmg5mxaO1fU25TprYcT7cUMOvSaQfbqzmOcMtsLdeoc6cLFZ
bPHT7T9mRK8YvjPWDhF6rvlU7gh9SDCShm/zLj+TnFaznmyseCchndQyJPMhTEAj
68uUGa3ZlGzWzvdPVkY8qXzEb+hnujaunI6552tJCokgBt3oJi33mcrsl7lc/wVn
YyfG3bREUbGlREi0v1KPqXc0zvb833UTUptTkGin8XBn/7tVmbtuNHOprYupVHlI
A/CjaeIup5DuVGs1xVY5VNIPBZftzIEt4etwZsFUzJdTYWyUd1ZMWt7cAWtOVUt+
o15VvnCn1iH096DAKJXc576DtcXSQ3f4i5aXbDoeY0o8fPGGeuZma3CsGuiGM1cp
yXCGSblKWK0qtCemI4SGT2KA1OjsrsVKcNihL8T4lTqqzB8W1YK9XQtIZEGdX6ID
foy5osh9w9rudAwpTHtvpCkT2hXnf6XmbN5VQ75oRbaf0IgDZNxlKMSpAK1geCfU
tgavLshuA4v5vlDJPrQE
=/8R8
-----END PGP SIGNATURE-----

--BA6BoNc434txts5btbBARL23qK6CCELtP--
