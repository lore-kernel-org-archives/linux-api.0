From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Review of ptrace Yama ptrace_scope description
Date: Wed, 29 Jun 2016 07:05:08 +0200
Message-ID: <b1769b73-41ce-1896-306a-bb15902503e0@gmail.com>
References: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c@gmail.com>
 <20160625143006.GA24730@pc.thejh.net>
 <0017835d-c672-02fe-dab8-d1b11c100c24@gmail.com>
 <CAGXu5jJJFL1YtwEvqhTz2RrVSbszUF32QhN6BH92aWqqpPyNew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJJFL1YtwEvqhTz2RrVSbszUF32QhN6BH92aWqqpPyNew@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: mtk.manpages@gmail.com, Jann Horn <jann@thejh.net>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>
List-Id: linux-api@vger.kernel.org

Hi Kees,

On 06/28/2016 10:55 PM, Kees Cook wrote:
> On Mon, Jun 27, 2016 at 11:11 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>> Hi Jann,
>>
>>
>> On 06/25/2016 04:30 PM, Jann Horn wrote:
>>>
>>> On Sat, Jun 25, 2016 at 09:30:43AM +0200, Michael Kerrisk (man-page=
s)
>>> wrote:
>>>>
>>>> Hi Kees,
>>>>
>>>> So, last year, I added some documentation to ptrace(2) to describe
>>>> the Yama ptrace_scope file. I don't think I asked you for review
>>>> at the time, but in the light of other changes to the ptrace(2)
>>>> page, it occurred to me that it might be a good idea to ask you
>>>> to check the text below to see if anything is missing or could be
>>>> improved. Might you have a moment for that?
>>>>
>>>>    /proc/sys/kernel/yama/ptrace_scope
>>>>        On systems with the Yama Linux Security Module (LSM)  insta=
lled
>>>>        (i.e.,  the  kernel  was configured with CONFIG_SECURITY_YA=
MA),
>>>>        the /proc/sys/kernel/yama/ptrace_scope  file  (available  s=
ince
>>>>        Linux  3.4)  can  be  used  to  restrict the ability to tra=
ce a
>>>>        process with ptrace(2) (and thus also the ability to use  t=
ools
>>>>        such  as  strace(1) and gdb(1)).  The goal of such restrict=
ions
>>>>        is to prevent attack escalation whereby a  compromised  pro=
cess
>>>>        can  ptrace-attach  to  other  sensitive processes (e.g., a=
 GPG
>>>>        agent or an SSH session) owned by the user  in  order  to  =
gain
>>>>        additional credentials and thus expand the scope of the att=
ack.
>
> Maybe clarify "additional credentials that may exist in memory only a=
nd thus..."

Done.

>>>>
>>>>        More precisely, the Yama LSM limits two types of operations=
:
>>>>
>>>>        *  Any   operation   that   performs   a   ptrace  access  =
mode
>>>>           PTRACE_MODE_ATTACH     check=E2=80=94for      example,  =
    ptrace()
>>>>           PTRACE_ATTACH.   (See the "Ptrace access mode checking" =
dis=E2=80=90
>>>>           cussion above.)
>>>>
>>>>        *  ptrace() PTRACE_TRACEME.
>>>>
>>>>        A process that has the CAP_SYS_PTRACE capability can update=
 the
>>>>        /proc/sys/kernel/yama/ptrace_scope file with one of the fol=
low=E2=80=90
>>>>        ing values:
>>>>
>>>>        0 ("classic ptrace permissions")
>>>>               No additional restrictions on  operations  that  per=
form
>>>>               PTRACE_MODE_ATTACH  checks  (beyond those imposed by=
 the
>>>>               commoncap and other LSMs).
>>>>
>>>>               The use of PTRACE_TRACEME is unchanged.
>>>>
>>>>        1 ("restricted ptrace") [default value]
>>>>               When   performing   an   operation   that   requires=
   a
>>>>               PTRACE_MODE_ATTACH  check, the calling process must =
have
>>>>               a predefined relationship with the target  process. =
  By
>>>>               default,  the predefined relationship is that the ta=
rget
>>>>               process must be a child of the caller.
>>>>
>>>>               A target process can employ the prctl(2)  PR_SET_PTR=
ACER
>>>>               operation  to declare a different PID that is allowe=
d to
>>>>               perform PTRACE_MODE_ATTACH  operations  on  the  tar=
get.
>>>>               See   the   kernel   source   file   Documentation/s=
ecu=E2=80=90
>>>>               rity/Yama.txt for further details.
>>>>
>>>>               The use of PTRACE_TRACEME is unchanged.
>>>
>>>
>>> (namespaced) CAP_SYS_PTRACE is also sufficient here.
>>>
>>>
>>> Both here and in the "admin-only attach" case, it is IMO important =
to
>>> note that creating a user namespace effectively removes the Yama
>>> protection because the owner of a namespace, when accessing its
>>> contents from outside, is relatively capable.
>>>
>>> This means that when a process tries to use namespaces to sandbox
>>> itself, it inadvertently makes itself more accessible.
>>>
>>> (This could probably be worked around in the kernel, but such a
>>> workaround would likely not be default, but rather opt-in via a new
>>> flag for clone() and unshare() or so.)
>>
>>
>> Tanks for catching this!
>>
>> So I've made that section of text:
>>
>>        A  process  that  has the CAP_SYS_PTRACE capability can updat=
e the
>>        /proc/sys/kernel/yama/ptrace_scope file with one of the  foll=
owing
>>        values:
>>
>>        0 ("classic ptrace permissions")
>>               No  additional  restrictions  on  operations  that  pe=
rform
>>               PTRACE_MODE_ATTACH checks (beyond those imposed by the=
 com=E2=80=90
>>               moncap and other LSMs).
>>
>>               The use of PTRACE_TRACEME is unchanged.
>>
>>        1 ("restricted ptrace") [default value]
>>               When    performing    an    operation   that   require=
s   a
>>               PTRACE_MODE_ATTACH check, the calling process  must  e=
ither
>>               have the CAP_SYS_PTRACE capability in the user namespa=
ce of
>>               the target process or it  have  a  predefined  relatio=
nship
>>               with  the target process.  By default, the predefined =
rela=E2=80=90
>>               tionship is that the target process must be a child of=
  the
>>               caller.
>
> More accurately, must be a descendant of the caller (grand child is f=
ine, etc).

Thanks, Fixed.

>
>>
>>               A  target  process  can  employ the prctl(2) PR_SET_PT=
RACER
>>               operation to declare a different PID  that  is  allowe=
d  to
>>               perform  PTRACE_MODE_ATTACH  operations on the target.=
  See
>>               the kernel source file Documentation/security/Yama.txt=
  for
>>               further details.
>
> I would say "additional" pid to perform... since its ancestors can
> still ptrace it too.

Ahhh -- thanks. I'd not understood that to be the case. Fixed now.

>>               The use of PTRACE_TRACEME is unchanged.
>>
>>        2 ("admin-only attach")
>>               Only  processes  with  the CAP_SYS_PTRACE capability i=
n the
>>               user  namespace  of  the   target   process   may   pe=
rform
>>               PTRACE_MODE_ATTACH operations or trace children that e=
mploy
>>               PTRACE_TRACEME.
>>
>>        3 ("no attach")
>>               No process may  perform  PTRACE_MODE_ATTACH  operation=
s  or
>>               trace children that employ PTRACE_TRACEME.
>>
>>               Once  this value has been written to the file, it cann=
ot be
>>               changed.
>>
>>        With respect to values 1 and 2, note that creating a  user  n=
ames=E2=80=90
>>        pace effectively removes the Yama protection, because the own=
er of
>>        a  namespace,  when  accessing  its  members  from  outside, =
  has
>>        CAP_SYS_PTRACE  within  the  namespace.   This  means  that w=
hen a
>>        process tries to use namespaces to  sandbox  itself,  it  ina=
dver=E2=80=90
>>        tently weakens the protections offered by the Yama LSM.
>
> Perhaps clarify "has CAP_SYS_PTRACE within all its namespaces, so the
> ancestry rule is bypassed"?

So, I've reworked that last piece somewhat to something
I hope is a little clearer:

        With respect to values 1 and 2, note  that  creating  a  new  u=
ser
        namespace  effectively  removes  the  protection  offered by Ya=
ma.
        This is because a process  in  the  parent  user  namespace  wh=
ose
        effective  UID matches the UID of the creator of a child namesp=
ace
        has all capabilities (including  CAP_SYS_PTRACE)  when  perform=
ing
        operations  within  the  child user namespace (and further-remo=
ved
        descendants of that  namespace).   Consequently,  when  a  proc=
ess
        tries  to  use user namespaces to sandbox itself, it inadverten=
tly
        weakens the protections offered by the Yama LSM.

> Otherwise it looks great, thanks for writing it up!

No problem. Thanks for reviewing!

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
