From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Fri, 22 Jun 2018 14:51:23 -0700
Message-ID: <CAGXu5jKWQCDzXPdTz=+bxT9+4enaBvgYfMseUiGti+t1KwZT8g@mail.gmail.com>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-2-tycho@tycho.ws>
 <CAG48ez3Ek_KG54ejR=Q=XtW_HDs8hQ+cgFODzn4rQ0nVDVpODg@mail.gmail.com>
 <20180622151514.GM3992@cisco> <E8029AD7-7009-4CBF-911E-186328237176@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E8029AD7-7009-4CBF-911E-186328237176@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tycho Andersen <tycho@tycho.ws>, Jann Horn <jannh@google.com>, kernel list <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 22, 2018 at 11:09 AM, Andy Lutomirski <luto@amacapital.net> wro=
te:
> One possible extra issue: IIRC /proc/.../mem uses FOLL_FORCE, which is no=
t what we want here.
>
> How about just adding an explicit =E2=80=9Cread/write the seccomp-trapped=
 task=E2=80=99s memory=E2=80=9D primitive?  That should be easier than a =
=E2=80=9Copen mem fd=E2=80=9D primitive.

Uuugh. Can we avoid adding another "read/write remote process memory"
interface? The point of this series was to provide a lightweight
approach to what should normally be possible via the existing
seccomp+ptrace interface. I do like Jann's context idea, but I agree
with Andy: it can't be a handle to /proc/$pid/mem, since it's
FOLL_FORCE. Is there any other kind of process context id we can use
for this instead of pid? There was once an idea of pid-fd but it never
landed... This would let us get rid of the "id" in the structure too.
And if that existed, we could make process_vm_*v() safer too (taking a
pid-fd instead of a pid).

-Kees

--=20
Kees Cook
Pixel Security
