From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via USER_NOTIF
Date: Wed, 19 Sep 2018 07:19:56 -0700
Message-ID: <C1406292-7496-459F-A76A-20C9EFBB12D6@amacapital.net>
References: <20180906152859.7810-1-tycho@tycho.ws> <20180906152859.7810-5-tycho@tycho.ws> <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com> <20180919095536.GM4672@cisco>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919095536.GM4672@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org



> On Sep 19, 2018, at 2:55 AM, Tycho Andersen <tycho@tycho.ws> wrote:
>=20
>> On Wed, Sep 12, 2018 at 04:52:38PM -0700, Andy Lutomirski wrote:
>>> On Thu, Sep 6, 2018 at 8:28 AM, Tycho Andersen <tycho@tycho.ws> wrote:
>>> The idea here is that the userspace handler should be able to pass an fd=

>>> back to the trapped task, for example so it can be returned from socket(=
).
>>>=20
>>> I've proposed one API here, but I'm open to other options. In particular=
,
>>> this only lets you return an fd from a syscall, which may not be enough i=
n
>>> all cases. For example, if an fd is written to an output parameter inste=
ad
>>> of returned, the current API can't handle this. Another case is that
>>> netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
>>> ever decides to install an fd and output it, we wouldn't be able to hand=
le
>>> this either.
>>=20
>> An alternative could be to have an API (an ioctl on the listener,
>> perhaps) that just copies an fd into the tracee.  There would be the
>> obvious set of options: do we replace an existing fd or allocate a new
>> one, and is it CLOEXEC.  Then the tracer could add an fd and then
>> return it just like it's a regular number.
>>=20
>> I feel like this would be more flexible and conceptually simpler, but
>> maybe a little slower for the common cases.  What do you think?
>=20
> I'm just implementing this now, and there's one question: when do we
> actually do the fd install? Should we do it when the user calls
> SECCOMP_NOTIF_PUT_FD, or when the actual response is sent? It feels
> like we should do it when the response is sent, instead of doing it
> right when SECCOMP_NOTIF_PUT_FD is called, since if there's a
> subsequent signal and the tracer decides to discard the response,
> we'll have to implement some delete mechanism to delete the fd, but it
> would have already been visible to the process, etc. So I'll go
> forward with this unless there are strong objections, but I thought
> I'd point it out just to avoid another round trip.
>=20
>=20

Can you do that non-racily?  That is, you need to commit to an fd *number* r=
ight away, but what if another thread uses the number before you actually in=
stall the fd?

Do we really allow non-=E2=80=9Ckill=E2=80=9D signals to interrupt the whole=
 process?  It might be the case that we don=E2=80=99t really need to clean u=
p from signals if there=E2=80=99s a guarantee that the thread dies.=
