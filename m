From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 resend 1/2] mm: Add an F_SEAL_FUTURE_WRITE seal to memfd
Date: Fri, 9 Nov 2018 15:14:02 -0800
Message-ID: <F8A6A5DC-3BA0-43BD-B7EC-EDE199B33A02@amacapital.net>
References: <20181108041537.39694-1-joel@joelfernandes.org> <CAG48ez1h=v-JYnDw81HaYJzOfrNhwYksxmc2r=cJvdQVgYM+NA@mail.gmail.com> <CAKOZuesw1wG-YynWL7bVb+4BWtYp0Ei62vweWF+mqF1Ln-_2Tg@mail.gmail.com> <BB64C995-F374-49EB-8469-4820231D8152@amacapital.net> <CAKOZuetZrL10zWwn4Jzzg0QL2nd3Fm0JxGtzC79SZAfOK525Ag@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuetZrL10zWwn4Jzzg0QL2nd3Fm0JxGtzC79SZAfOK525Ag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Jann Horn <jannh@google.com>, Joel Fernandes <joel@joelfernandes.org>, kernel list <linux-kernel@vger.kernel.org>, John Reck <jreck@google.com>, John Stultz <john.stultz@linaro.org>, Todd Kjos <tkjos@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Bruce Fields <bfields@fieldses.org>, Jeff Layton <jlayton@kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, Lei.Yang@windriver.com, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, marcandre.lureau@redhat.com, Mike Kravetz <mike.kravetz@oracle.com>, Minchan Kim <minchan@kernel.org>, Shuah Khan <shuah@kernel.org>, valdis.kletnieks@vt
List-Id: linux-api@vger.kernel.org



> On Nov 9, 2018, at 2:42 PM, Daniel Colascione <dancol@google.com> wrote:
>=20
> On Fri, Nov 9, 2018 at 2:37 PM, Andy Lutomirski <luto@amacapital.net> wrot=
e:
>>> Another, more general fix might be to prevent /proc/pid/fd/N opens
>>> from "upgrading" access modes. But that'd be a bigger ABI break.
>>=20
>> I think we should fix that, too.  I consider it a bug fix, not an ABI bre=
ak, personally.
>=20
> Someone, somewhere is probably relying on it though, and that means
> that we probably can't change it unless it's actually causing
> problems.
>=20
> <mumble>spacebar heating</mumble>

I think it has caused problems in the past. It=E2=80=99s certainly extremely=
 surprising behavior.  I=E2=80=99d say it should be fixed and, if needed, a s=
ysctl to unfix it might be okay.

>=20
>>>> That aside: I wonder whether a better API would be something that
>>>> allows you to create a new readonly file descriptor, instead of
>>>> fiddling with the writability of an existing fd.
>>>=20
>>> That doesn't work, unfortunately. The ashmem API we're replacing with
>>> memfd requires file descriptor continuity. I also looked into opening
>>> a new FD and dup2(2)ing atop the old one, but this approach doesn't
>>> work in the case that the old FD has already leaked to some other
>>> context (e.g., another dup, SCM_RIGHTS). See
>>> https://developer.android.com/ndk/reference/group/memory. We can't
>>> break ASharedMemory_setProt.
>>=20
>>=20
>> Hmm.  If we fix the general reopen bug, a way to drop write access from a=
n existing struct file would do what Android needs, right?  I don=E2=80=99t k=
now if there are general VFS issues with that.
>=20
> I also proposed that. :-) Maybe it'd work best as a special case of
> the perennial revoke(2) that people keep proposing. You'd be able to
> selectively revoke all access or just write access.

Sounds good to me, modulo possible races, but that shouldn=E2=80=99t be too h=
ard to deal with.=
