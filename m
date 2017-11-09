From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Seccomp implications for glibc wrapper function changes
Date: Thu, 9 Nov 2017 18:27:33 +0100
Message-ID: <CAKgNAkgNdv7xy00k-hk1kbodJ9vbO_YFTSQj2jgfeJYkRsKf2A@mail.gmail.com>
References: <CAKgNAkixA6T7J_1Gs=5+riq6i=dr9XP4ZCGu67YVcuDNg3cT4g@mail.gmail.com>
 <0049d6a8-de25-ff02-31ef-38a7db05b878@redhat.com> <CAKgNAkhLsBNVO9axSxwH8VNxBW1QPWjaEOS_ubu-nUZ7_gsn7w@mail.gmail.com>
 <CAKgNAkjAbRN7gVuErpmBZ2YtkYfRSAdnWVdRR1B34BvszRZ0-g@mail.gmail.com>
 <c2965313-404b-71fb-0686-bd13fde2b975@redhat.com> <690547e9-b67f-d106-0782-ed6f3ca2eb18@linaro.org>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="f403045c26daae56cf055d901e11"
Return-path: <libc-alpha-return-86949-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <690547e9-b67f-d106-0782-ed6f3ca2eb18@linaro.org>
To: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Cc: Florian Weimer <fweimer@redhat.com>, libc-alpha@sourceware.org, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

--f403045c26daae56cf055d901e11
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On 9 November 2017 at 13:14, Adhemerval Zanella <
adhemerval.zanella@linaro.org> wrote:
>
>
> On 09/11/2017 10:02, Florian Weimer wrote:
>> On 11/09/2017 12:58 PM, Michael Kerrisk (man-pages) wrote:
>>> [CC +=3D Kees, in case he has some comments]
>>>
>>> On 9 November 2017 at 08:17, Michael Kerrisk (man-pages)
>>> <mtk.manpages@gmail.com> wrote:
>>>> Hi Florian,
>>>>
>>>> On 8 November 2017 at 07:24, Florian Weimer <fweimer@redhat.com> wrote=
:
>>>>> On 11/07/2017 09:35 PM, Michael Kerrisk (man-pages) wrote:
>>>>>>
>>>>>> This change broke my code that was doing seccomp filtering for the
>>>>>> open() system call number (__NR_open). The breakage in question is
not
>>>>>> serious, since this was really just demonstration code. However, I
>>>>>> want to raise awareness that these sorts of changes have the
potential
>>>>>> to possibly cause breakages for some code using seccomp, and note
that
>>>>>> I think such changes should not be made lightly or gratuitously.
>>>>>
>>>>>
>>>>> I have the opposite view: We should make such changes as often as
possible,
>>>>> to remind people that seccomp filters (and certain SELinux and
AppArmor
>>>>> policies) are incompatible with the GNU/Linux model, where everything
is
>>>>> developed separately and not maintained within a single source tree
(unlike
>>>>> say OpenBSD). This means that you really can't deviate from the
upstream
>>>>> Linux userspace ABI (in the broadest possible sense) and still expect
things
>>>>> to work.
>>>>>
>>>>> I know that people like to slap seccomp filters on everything today,
but
>>>>> without careful examination, that is likely to introduce bugs
(particularly
>>>>> on rarely used code paths). It can also cause the process to switch t=
o
>>>>> legacy interfaces with known issues (e.g., reading from /dev/urandom
instead
>>>>> of getrandom, without waiting for the kernel to signal initialization
of the
>>>>> pool).
>>>>
>>>> Thanks. The above is a good summary of the counterpoints to my initial
argument.
>>>
>>> Florian, taking your and Adhemerval's useful comments into account, I
>>> added the following text to the seccomp(2) manual page:
>>>
>>> [[
>>> Caveats
>>> There are various subtleties to consider when applying seccomp
>>> filters to a program, including the following:
>>>
>>> * Some traditional system calls have user-space implementations
>>> in the vdso(7) on many architectures. Notable examples include
>>> clock_gettime(2), gettimeofday(2), and time(2). On such archi=E2=80=90
>>> tectures, seccomp filtering for these system calls will have no
>>> effect.
>>
>> I think the situation is more complicated for many of those because they
can still perform system calls on their fallback paths. So it's one more
case where seccomp can give you unpredictable failures.
>>
>> Rest looks good to me. Thanks for the writeup.
>>
>> Florian
>
> Looks good to me as well.

Thanks for the review, Adhemerval!

Cheers,

Michael

--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

--f403045c26daae56cf055d901e11
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">On 9 November 2017 at 13:14, Adhemerval Zanella &lt;<a hr=
ef=3D"mailto:adhemerval.zanella@linaro.org">adhemerval.zanella@linaro.org</=
a>&gt; wrote:<br>&gt;<br>&gt;<br>&gt; On 09/11/2017 10:02, Florian Weimer w=
rote:<br>&gt;&gt; On 11/09/2017 12:58 PM, Michael Kerrisk (man-pages) wrote=
:<br>&gt;&gt;&gt; [CC +=3D Kees, in case he has some comments]<br>&gt;&gt;&=
gt;<br>&gt;&gt;&gt; On 9 November 2017 at 08:17, Michael Kerrisk (man-pages=
)<br>&gt;&gt;&gt; &lt;<a href=3D"mailto:mtk.manpages@gmail.com">mtk.manpage=
s@gmail.com</a>&gt; wrote:<br>&gt;&gt;&gt;&gt; Hi Florian,<br>&gt;&gt;&gt;&=
gt;<br>&gt;&gt;&gt;&gt; On 8 November 2017 at 07:24, Florian Weimer &lt;<a =
href=3D"mailto:fweimer@redhat.com">fweimer@redhat.com</a>&gt; wrote:<br>&gt=
;&gt;&gt;&gt;&gt; On 11/07/2017 09:35 PM, Michael Kerrisk (man-pages) wrote=
:<br>&gt;&gt;&gt;&gt;&gt;&gt;<br>&gt;&gt;&gt;&gt;&gt;&gt; This change broke=
 my code that was doing seccomp filtering for the<br>&gt;&gt;&gt;&gt;&gt;&g=
t; open() system call number (__NR_open). The breakage in question is not<b=
r>&gt;&gt;&gt;&gt;&gt;&gt; serious, since this was really just demonstratio=
n code. However, I<br>&gt;&gt;&gt;&gt;&gt;&gt; want to raise awareness that=
 these sorts of changes have the potential<br>&gt;&gt;&gt;&gt;&gt;&gt; to p=
ossibly cause breakages for some code using seccomp, and note that<br>&gt;&=
gt;&gt;&gt;&gt;&gt; I think such changes should not be made lightly or grat=
uitously.<br>&gt;&gt;&gt;&gt;&gt;<br>&gt;&gt;&gt;&gt;&gt;<br>&gt;&gt;&gt;&g=
t;&gt; I have the opposite view: We should make such changes as often as po=
ssible,<br>&gt;&gt;&gt;&gt;&gt; to remind people that seccomp filters (and =
certain SELinux and AppArmor<br>&gt;&gt;&gt;&gt;&gt; policies) are incompat=
ible with the GNU/Linux model, where everything is<br>&gt;&gt;&gt;&gt;&gt; =
developed separately and not maintained within a single source tree (unlike=
<br>&gt;&gt;&gt;&gt;&gt; say OpenBSD).  This means that you really can&#39;=
t deviate from the upstream<br>&gt;&gt;&gt;&gt;&gt; Linux userspace ABI (in=
 the broadest possible sense) and still expect things<br>&gt;&gt;&gt;&gt;&g=
t; to work.<br>&gt;&gt;&gt;&gt;&gt;<br>&gt;&gt;&gt;&gt;&gt; I know that peo=
ple like to slap seccomp filters on everything today, but<br>&gt;&gt;&gt;&g=
t;&gt; without careful examination, that is likely to introduce bugs (parti=
cularly<br>&gt;&gt;&gt;&gt;&gt; on rarely used code paths).  It can also ca=
use the process to switch to<br>&gt;&gt;&gt;&gt;&gt; legacy interfaces with=
 known issues (e.g., reading from /dev/urandom instead<br>&gt;&gt;&gt;&gt;&=
gt; of getrandom, without waiting for the kernel to signal initialization o=
f the<br>&gt;&gt;&gt;&gt;&gt; pool).<br>&gt;&gt;&gt;&gt;<br>&gt;&gt;&gt;&gt=
; Thanks. The above is a good summary of the counterpoints to my initial ar=
gument.<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; Florian, taking your and Adhemerval=
&#39;s useful comments into account, I<br>&gt;&gt;&gt; added the following =
text to the seccomp(2) manual page:<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; [[<br>&=
gt;&gt;&gt;     Caveats<br>&gt;&gt;&gt;         There  are  various  subtle=
ties  to consider when applying seccomp<br>&gt;&gt;&gt;         filters to =
a program, including the following:<br>&gt;&gt;&gt;<br>&gt;&gt;&gt;        =
 *  Some traditional system calls have  user-space  implementations<br>&gt;=
&gt;&gt;            in the vdso(7) on many architectures.  Notable examples=
 include<br>&gt;&gt;&gt;            clock_gettime(2), gettimeofday(2), and =
time(2).  On such archi=E2=80=90<br>&gt;&gt;&gt;            tectures, secco=
mp filtering for these system calls will have no<br>&gt;&gt;&gt;           =
 effect.<br>&gt;&gt;<br>&gt;&gt; I think the situation is more complicated =
for many of those because they can still perform system calls on their fall=
back paths.  So it&#39;s one more case where seccomp can give you unpredict=
able failures.<br>&gt;&gt;<br>&gt;&gt; Rest looks good to me.  Thanks for t=
he writeup.<br>&gt;&gt;<br>&gt;&gt; Florian<br>&gt;<br>&gt; Looks good to m=
e as well.<br><br>Thanks for the review, Adhemerval!<br><br>Cheers,<br><br>=
Michael<br><br>-- <br>Michael Kerrisk<br>Linux man-pages maintainer; <a hre=
f=3D"http://www.kernel.org/doc/man-pages/">http://www.kernel.org/doc/man-pa=
ges/</a><br>Linux/UNIX System Programming Training: <a href=3D"http://man7.=
org/training/">http://man7.org/training/</a></div>

--f403045c26daae56cf055d901e11--
