From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Documenting ptrace access mode checking
Date: Fri, 24 Jun 2016 11:57:43 +0200
Message-ID: <fb9bbc54-857a-5187-7932-add65f45c179@gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <87ziqewc3r.fsf@x220.int.ebiederm.org>
 <4c6a338f-619b-9e99-9fd8-1cf6d86ecfed@gmail.com>
 <87por7hgl0.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87por7hgl0.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Jann Horn <jann@thejh.net>, James Morris <jmorris@namei.org>, linux-man <linux-man@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, lkml <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

Hi Eric,

On 06/23/2016 09:04 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> Hi Eric,
>>
>> On 06/21/2016 09:55 PM, Eric W. Biederman wrote:
>>> Hmm.
>>>
>>> When I gave this level of detail about the user namespace permissio=
n
>>> checks you gave me some flack, because it was not particularly
>>> comprehensible to the end users.  I think you deserve the same feed=
back.
>>>
>>> How do we say this in a way that does not describes a useful way to
>>> think about it.  I read this and I know a lot of what is going on a=
nd my
>>> mind goes numb.
>>>
>>> How about something like this:
>>>
>>>    If the callers uid and gid are the same as a processes uids and =
gids
>>>    and the processes is configured to allow core dumps (aka it was =
never
>>>    setuid or setgid) then the caller is allowed to ptrace a process=
=2E
>>>
>>>    Otherwise the caller must have CAP_SYS_PTRACE.
>>>
>>>    Linux security modules impose additional restrictions.
>>>
>>>    For consistency access to various process attributes are guarded=
 with
>>>    the same security checks as the ptrace system call itself.  As t=
hey are
>>>    all methods to get information about a process.
>>>
>>> We certainly need something that gives a high level view so people
>>> reading the man page can know what to expect.   If you get down int=
o the
>>> weeds we run the danger of people beginning to think they can depen=
d
>>> upon bugs in the implementation.
>>
>> Thanks for the feedback, but I think more detail is required than yo=
u
>> suggest. (And I added all of that detail somewhat reluctantly.)
>> See my other replies for my rationale.
>
> What I saw badly missing from your description is not the level of
> detail but bring things into a form that ordinary mortals can
> understand.
>
> For an explanation to be clear I think we very much need the high lev=
el
> overview first.  Then we can expand that description with the very
> detailed view.
>
> I very much think we need to describe things in such a way that peopl=
e
> understand the principles behind the permission checks, and not just
> have the documentation echo the code, so that people can know what we=
ird
> things LSMs like yama are likely to do, and how these checks are like=
ly
> to evolve in the future.

So, I completely agree with you, and I agree that this could be better.
At first, I understood your meaning to be that I should avoid all of th=
e
detail, and just limit the man page to some very high level text as
you proposed. So, I think it's worth prefixing the details with some
attempt at a high-level picture. How about this as an introductory
paragraph:

        Various parts of the kernel-user-space API (not just  ptrace(2)
        operations),  require  so-called  "ptrace  access mode" checks,
        whose outcome determines whether an operation is permitted (or,
        in  a  few cases, causes a "read" operation to return sanitized
        data).  These checks are performed in cases where  one  process
        can  inspect sensitive information about, or in some cases mod=E2=
=80=90
        ify the state of, another process.  The  checks  are  based  on
        factors  such  as  the  credentials and capabilities of the two
        processes, whether or not the "target" process is dumpable, and
        the  results  of checks performed by any enabled Linux Security
        Module (LSM)=E2=80=94for example, SELinux, Yama, or  Smack=E2=80=
=94and  by  the
        commoncap LSM (which is always invoked).

?

> Because one thing is clear to me.  The evolution of these details is
> clearly not done, and will continue to change in the future.

Maybe people will even write man page patches when that happens :-).

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
