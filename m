From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 0/4] seccomp trap to userspace
Date: Mon, 6 Aug 2018 19:57:16 -0700
Message-ID: <62CE9671-DECD-415B-8F57-9FCCE7922990@amacapital.net>
References: <20180621220416.5412-1-tycho@tycho.ws> <20180807024442.GA12274@cisco.lan>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807024442.GA12274@cisco.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, "Tobin C . Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org


> On Aug 6, 2018, at 7:44 PM, Tycho Andersen <tycho@tycho.ws> wrote:
>=20
> Hi all,
>=20
> Dinesh Subhraveti has claimed that some part of this series might be
> patented. While he has not furnished me with anything to confirm this
> claim, I'll put this series on hold.

That... is utterly ridiculous. Does LF have a mechanism to figure out wtf an=
d deal with it by, for example, filing for ex parte review.

Every microkernel ever should strongly resemble prior art.

>=20
> Tycho
>=20
>> On Thu, Jun 21, 2018 at 04:04:12PM -0600, Tycho Andersen wrote:
>> Hi all,
>>=20
>> Here's v4 of the seccomp trap to userspace series. v3 is here:
>> https://lkml.org/lkml/2018/5/31/527
>>=20
>> I believe we've addressed the two burning questions I had about v3: 1.
>> it seems ok not to use netlink, since there's not a great way to re-use
>> the API without a lot of unnecessary code and 2. only having return
>> capability for fds seems fine with people. Or at least I haven't heard
>> any strong objections.
>>=20
>> I've re-worked a bunch of things in this version based on feedback from
>> the last series. See patch notes for details. At this point I'm not
>> aware of anything that needs to be addressed, but of course that is
>> subject to change :)
>>=20
>> Tycho
>>=20
>> Tycho Andersen (4):
>>  seccomp: add a return code to trap to userspace
>>  seccomp: make get_nth_filter available outside of CHECKPOINT_RESTORE
>>  seccomp: add a way to get a listener fd from ptrace
>>  seccomp: add support for passing fds via USER_NOTIF
>>=20
>> .../userspace-api/seccomp_filter.rst          |  79 +++
>> arch/Kconfig                                  |   7 +
>> include/linux/seccomp.h                       |  18 +-
>> include/uapi/linux/ptrace.h                   |   2 +
>> include/uapi/linux/seccomp.h                  |  23 +-
>> kernel/ptrace.c                               |   4 +
>> kernel/seccomp.c                              | 491 ++++++++++++++-
>> tools/testing/selftests/seccomp/seccomp_bpf.c | 560 +++++++++++++++++-
>> 8 files changed, 1172 insertions(+), 12 deletions(-)
>>=20
>> --=20
>> 2.17.1
>>=20
