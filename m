From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Seccomp implications for glibc wrapper function changes
Date: Mon, 13 Nov 2017 14:44:26 -0800
Message-ID: <CAGXu5jJwgavx5jNpMGdR5D4rAv4GxtrERgGgi-FQDaROOTocLw@mail.gmail.com>
References: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
 <0049d6a8-de25-ff02-31ef-38a7db05b878@redhat.com> <CAKgNAkhLsBNVO9axSxwH8VNxBW1QPWjaEOS_ubu-nUZ7_gsn7w@mail.gmail.com>
 <CAKgNAkjAbRN7gVuErpmBZ2YtkYfRSAdnWVdRR1B34BvszRZ0-g@mail.gmail.com>
 <c2965313-404b-71fb-0686-bd13fde2b975@redhat.com> <CAKgNAki9m460sOw8KP9unnBU_ANctXj4H=gUEiRgRhUHFGjDbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAki9m460sOw8KP9unnBU_ANctXj4H=gUEiRgRhUHFGjDbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Adhemerval Zanella <adhemerval.zanella-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 9, 2017 at 5:37 AM, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Florian,
>
> On 9 November 2017 at 13:02, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 11/09/2017 12:58 PM, Michael Kerrisk (man-pages) wrote:
>>>
>>> [CC +=3D Kees, in case he has some comments]
>>>
>>> On 9 November 2017 at 08:17, Michael Kerrisk (man-pages)
>>> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>> Hi Florian,
>>>>
>>>> On 8 November 2017 at 07:24, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
>>>>>
>>>>> On 11/07/2017 09:35 PM, Michael Kerrisk (man-pages) wrote:
>>>>>>
>>>>>>
>>>>>> This change broke my code that was doing seccomp filtering for the
>>>>>> open() system call number (__NR_open). The breakage in question is n=
ot
>>>>>> serious, since this was really just demonstration code. However, I
>>>>>> want to raise awareness that these sorts of changes have the potenti=
al
>>>>>> to possibly cause breakages for some code using seccomp, and note th=
at
>>>>>> I think such changes should not be made lightly or gratuitously.
>>>>>
>>>>>
>>>>>
>>>>> I have the opposite view: We should make such changes as often as
>>>>> possible,
>>>>> to remind people that seccomp filters (and certain SELinux and AppArm=
or
>>>>> policies) are incompatible with the GNU/Linux model, where everything=
 is
>>>>> developed separately and not maintained within a single source tree
>>>>> (unlike
>>>>> say OpenBSD).  This means that you really can't deviate from the
>>>>> upstream
>>>>> Linux userspace ABI (in the broadest possible sense) and still expect
>>>>> things
>>>>> to work.
>>>>>
>>>>> I know that people like to slap seccomp filters on everything today, =
but
>>>>> without careful examination, that is likely to introduce bugs
>>>>> (particularly
>>>>> on rarely used code paths).  It can also cause the process to switch =
to
>>>>> legacy interfaces with known issues (e.g., reading from /dev/urandom
>>>>> instead
>>>>> of getrandom, without waiting for the kernel to signal initialization=
 of
>>>>> the
>>>>> pool).
>>>>
>>>>
>>>> Thanks. The above is a good summary of the counterpoints to my initial
>>>> argument.
>>>
>>>
>>> Florian, taking your and Adhemerval's useful comments into account, I
>>> added the following text to the seccomp(2) manual page:
>>>
>>> [[
>>>     Caveats
>>>         There  are  various  subtleties  to consider when applying secc=
omp
>>>         filters to a program, including the following:
>>>
>>>         *  Some traditional system calls have  user-space  implementati=
ons
>>>            in the vdso(7) on many architectures.  Notable examples incl=
ude
>>>            clock_gettime(2), gettimeofday(2), and time(2).  On such arc=
hi=E2=80=90
>>>            tectures, seccomp filtering for these system calls will have=
 no
>>>            effect.
>>
>>
>> I think the situation is more complicated for many of those because they=
 can
>> still perform system calls on their fallback paths.  So it's one more ca=
se
>> where seccomp can give you unpredictable failures.
>
> Good point. I added the following text:
>
>           (However,  there are cases where the vdso(7) implemen=E2=80=90
>           tations may fall back  to  invoking  the  true  system
>           call, in which case seccomp filters would see the sys=E2=80=90
>           tem call.)
>
>> Rest looks good to me.  Thanks for the writeup.
>
> Thanks for the review!

Agreed, this looks good. Thanks for clarifying it. :)

-Kees

--=20
Kees Cook
Pixel Security
