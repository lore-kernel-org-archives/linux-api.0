From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC v1 03/17] selftest/seccomp: Fix the flag name SECCOMP_FILTER_FLAG_TSYNC
Date: Wed, 23 Mar 2016 21:35:40 -0700
Message-ID: <CAGXu5jKArYiYi4EDw=H9Kj3DQYgD0Q51Tfwc85wCTv_TN+X03w@mail.gmail.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
	<1458784008-16277-4-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458784008-16277-4-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk-ASgREoAs3yw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 23, 2016 at 6:46 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod.=
net> wrote:
> Rename SECCOMP_FLAG_FILTER_TSYNC to SECCOMP_FILTER_FLAG_TSYNC to matc=
h
> the UAPI.
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Hah, oops. Thanks! Shuah, can you take this patch into the selftest tre=
e?

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

> ---
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 18 +++++++++--------=
-
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/te=
sting/selftests/seccomp/seccomp_bpf.c
> index b9453b838162..9c1460f277c2 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -1497,8 +1497,8 @@ TEST_F(TRACE_syscall, syscall_dropped)
>  #define SECCOMP_SET_MODE_FILTER 1
>  #endif
>
> -#ifndef SECCOMP_FLAG_FILTER_TSYNC
> -#define SECCOMP_FLAG_FILTER_TSYNC 1
> +#ifndef SECCOMP_FILTER_FLAG_TSYNC
> +#define SECCOMP_FILTER_FLAG_TSYNC 1
>  #endif
>
>  #ifndef seccomp
> @@ -1613,7 +1613,7 @@ TEST(TSYNC_first)
>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!"=
);
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &prog);
>         ASSERT_NE(ENOSYS, errno) {
>                 TH_LOG("Kernel does not support seccomp syscall!");
> @@ -1831,7 +1831,7 @@ TEST_F(TSYNC, two_siblings_with_ancestor)
>                 self->sibling_count++;
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &self->apply_prog);
>         ASSERT_EQ(0, ret) {
>                 TH_LOG("Could install filter on all threads!");
> @@ -1892,7 +1892,7 @@ TEST_F(TSYNC, two_siblings_with_no_filter)
>                 TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!"=
);
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &self->apply_prog);
>         ASSERT_NE(ENOSYS, errno) {
>                 TH_LOG("Kernel does not support seccomp syscall!");
> @@ -1940,7 +1940,7 @@ TEST_F(TSYNC, two_siblings_with_one_divergence)
>                 self->sibling_count++;
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &self->apply_prog);
>         ASSERT_EQ(self->sibling[0].system_tid, ret) {
>                 TH_LOG("Did not fail on diverged sibling.");
> @@ -1992,7 +1992,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>                 TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILT=
ER!");
>         }
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &self->apply_prog);
>         ASSERT_EQ(ret, self->sibling[0].system_tid) {
>                 TH_LOG("Did not fail on diverged sibling.");
> @@ -2021,7 +2021,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>         /* Switch to the remaining sibling */
>         sib =3D !sib;
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &self->apply_prog);
>         ASSERT_EQ(0, ret) {
>                 TH_LOG("Expected the remaining sibling to sync");
> @@ -2044,7 +2044,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
>         while (!kill(self->sibling[sib].system_tid, 0))
>                 sleep(0.1);
>
> -       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_=
TSYNC,
> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_=
TSYNC,
>                       &self->apply_prog);
>         ASSERT_EQ(0, ret);  /* just us chickens */
>  }
> --
> 2.8.0.rc3
>



--=20
Kees Cook
Chrome OS & Brillo Security
