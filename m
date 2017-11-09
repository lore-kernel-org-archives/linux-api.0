From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Seccomp implications for glibc wrapper function changes
Date: Thu, 9 Nov 2017 12:58:47 +0100
Message-ID: <CAKgNAkjAbRN7gVuErpmBZ2YtkYfRSAdnWVdRR1B34BvszRZ0-g@mail.gmail.com>
References: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
 <0049d6a8-de25-ff02-31ef-38a7db05b878@redhat.com> <CAKgNAkhLsBNVO9axSxwH8VNxBW1QPWjaEOS_ubu-nUZ7_gsn7w@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkhLsBNVO9axSxwH8VNxBW1QPWjaEOS_ubu-nUZ7_gsn7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC +=3D Kees, in case he has some comments]

On 9 November 2017 at 08:17, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Florian,
>
> On 8 November 2017 at 07:24, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 11/07/2017 09:35 PM, Michael Kerrisk (man-pages) wrote:
>>>
>>> This change broke my code that was doing seccomp filtering for the
>>> open() system call number (__NR_open). The breakage in question is not
>>> serious, since this was really just demonstration code. However, I
>>> want to raise awareness that these sorts of changes have the potential
>>> to possibly cause breakages for some code using seccomp, and note that
>>> I think such changes should not be made lightly or gratuitously.
>>
>>
>> I have the opposite view: We should make such changes as often as possib=
le,
>> to remind people that seccomp filters (and certain SELinux and AppArmor
>> policies) are incompatible with the GNU/Linux model, where everything is
>> developed separately and not maintained within a single source tree (unl=
ike
>> say OpenBSD).  This means that you really can't deviate from the upstrea=
m
>> Linux userspace ABI (in the broadest possible sense) and still expect th=
ings
>> to work.
>>
>> I know that people like to slap seccomp filters on everything today, but
>> without careful examination, that is likely to introduce bugs (particula=
rly
>> on rarely used code paths).  It can also cause the process to switch to
>> legacy interfaces with known issues (e.g., reading from /dev/urandom ins=
tead
>> of getrandom, without waiting for the kernel to signal initialization of=
 the
>> pool).
>
> Thanks. The above is a good summary of the counterpoints to my initial ar=
gument.

Florian, taking your and Adhemerval's useful comments into account, I
added the following text to the seccomp(2) manual page:

[[
   Caveats
       There  are  various  subtleties  to consider when applying seccomp
       filters to a program, including the following:

       *  Some traditional system calls have  user-space  implementations
          in the vdso(7) on many architectures.  Notable examples include
          clock_gettime(2), gettimeofday(2), and time(2).  On such archi=E2=
=80=90
          tectures, seccomp filtering for these system calls will have no
          effect.

       *  Seccomp filtering is based on system  call  numbers.   However,
          applications typically do not directly invoke system calls, but
          instead call wrapper functions in the C library which  in  turn
          invoke  the  system  calls.  Consequently, one must be aware of
          the following:

          =C2=B7  The glibc wrappers for some  traditional  system  calls  =
may
             actually  employ  system  calls  with different names in the
             kernel.  For example, the exit(2) wrapper function  actually
             employs the exit_group(2) system call, and the fork(2) wrap=E2=
=80=90
             per function actually calls clone(2).

          =C2=B7  The behavior of wrapper functions may vary across  archit=
ec=E2=80=90
             tures,  according  to  the range of system calls provided on
             those architectures.  In other words, the same wrapper func=E2=
=80=90
             tion  may  invoke different system calls on different archi=E2=
=80=90
             tectures.

          =C2=B7  Finally, the behavior of wrapper functions can change acr=
oss
             glibc  versions.   For example, in older versions, the glibc
             wrapper function for open(2) invoked the system call of  the
             same  name,  but  starting in glibc 2.26, the implementation
             switched to calling openat(2) on all architectures.

       The consequence of the above points is that may  be  necessary  to
       filter  for  a  system call other than might be expected.  Various
       manual pages in Section 2 provide helpful details about  the  dif=E2=
=80=90
       ferences between wrapper functions and the underlying system calls
       in subsections entitled C library/kernel differences.

       Furthermore, note that the application  of  seccomp  filters  even
       risks causing bugs in an application, when the filters cause unex=E2=
=80=90
       pected failures for legitimate  operations  that  the  application
       might  need  to  perform.   Such bugs may not easily be discovered
       when testing the seccomp filters if the bugs occur in rarely  used
       application code paths.
]]

Cheers,

Michael
