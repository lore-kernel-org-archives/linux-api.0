From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 1/4] seccomp: add a return code to trap to userspace
Date: Mon, 25 Jun 2018 19:00:56 -0700
Message-ID: <24C1FE9E-1BAB-49EC-B62C-942B945A7163@amacapital.net>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180621220416.5412-2-tycho@tycho.ws> <CAG48ez3Ek_KG54ejR=Q=XtW_HDs8hQ+cgFODzn4rQ0nVDVpODg@mail.gmail.com> <20180622151514.GM3992@cisco> <E8029AD7-7009-4CBF-911E-186328237176@amacapital.net> <CAGXu5jKWQCDzXPdTz=+bxT9+4enaBvgYfMseUiGti+t1KwZT8g@mail.gmail.com> <CAG48ez3gobTL5mUnZKjhLedotZx49nGrxYKKud5_7+512PaOFw@mail.gmail.com> <20180626013204.GA7261@cisco.cisco.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180626013204.GA7261@cisco.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org



> On Jun 25, 2018, at 6:32 PM, Tycho Andersen <tycho@tycho.ws> wrote:
>=20
>> On Sat, Jun 23, 2018 at 12:27:43AM +0200, Jann Horn wrote:
>>> On Fri, Jun 22, 2018 at 11:51 PM Kees Cook <keescook@chromium.org> wrote=
:
>>>=20
>>>> On Fri, Jun 22, 2018 at 11:09 AM, Andy Lutomirski <luto@amacapital.net>=
 wrote:
>>>> One possible extra issue: IIRC /proc/.../mem uses FOLL_FORCE, which is n=
ot what we want here.
>>=20
>> Uuugh, I forgot about that.
>>=20
>>>> How about just adding an explicit =E2=80=9Cread/write the seccomp-trapp=
ed task=E2=80=99s memory=E2=80=9D primitive?  That should be easier than a =E2=
=80=9Copen mem fd=E2=80=9D primitive.
>>>=20
>>> Uuugh. Can we avoid adding another "read/write remote process memory"
>>> interface? The point of this series was to provide a lightweight
>>> approach to what should normally be possible via the existing
>>> seccomp+ptrace interface. I do like Jann's context idea, but I agree
>>> with Andy: it can't be a handle to /proc/$pid/mem, since it's
>>> FOLL_FORCE. Is there any other kind of process context id we can use
>>> for this instead of pid? There was once an idea of pid-fd but it never
>>> landed... This would let us get rid of the "id" in the structure too.
>>> And if that existed, we could make process_vm_*v() safer too (taking a
>>> pid-fd instead of a pid).
>>=20
>> Or make a duplicate of /proc/$pid/mem that only differs in whether it
>> sets FOLL_FORCE? The code is basically already there... something like
>> this:
>=20
> But we want more than just memory access, I think. rootfs access, ns
> fds, etc. all seem like they might be useful, and racy to open.
>=20
> I guess I see two options: use the existing id and add something to
> seccomp() to ask if it's still valid or independent of this patchset
> add some kind of pid id :\
>=20

I think we use the existing id / cookie / whatever and ask seccomp, or new s=
yscalls, to do the requested operation. This is because we know the target t=
ask is in a very special stopping point. As a result, a seccomp-specific mec=
hanism can do RCU-less fd modifications against a single-threaded target, ca=
n muck with things like struct cred, etc, while a more general interface can=
=E2=80=99t.

It might be nice to add a syscall with flags such that it could be used on p=
trace-stopped targets later on. Something like:

access_remote_task(int fd, u64 id, u32 type, ...)

Where type is 16 bits of =E2=80=9Cid and fd is from seccomp=E2=80=9D and 16 b=
its of =E2=80=9Cwrite memory=E2=80=9D or such.=
