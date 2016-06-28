From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Review of ptrace Yama ptrace_scope description
Date: Tue, 28 Jun 2016 08:11:36 +0200
Message-ID: <0017835d-c672-02fe-dab8-d1b11c100c24@gmail.com>
References: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c@gmail.com>
 <20160625143006.GA24730@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160625143006.GA24730@pc.thejh.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jann@thejh.net>
Cc: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>
List-Id: linux-api@vger.kernel.org

Hi Jann,

On 06/25/2016 04:30 PM, Jann Horn wrote:
> On Sat, Jun 25, 2016 at 09:30:43AM +0200, Michael Kerrisk (man-pages)=
 wrote:
>> Hi Kees,
>>
>> So, last year, I added some documentation to ptrace(2) to describe
>> the Yama ptrace_scope file. I don't think I asked you for review
>> at the time, but in the light of other changes to the ptrace(2)
>> page, it occurred to me that it might be a good idea to ask you
>> to check the text below to see if anything is missing or could be
>> improved. Might you have a moment for that?
>>
>>    /proc/sys/kernel/yama/ptrace_scope
>>        On systems with the Yama Linux Security Module (LSM)  install=
ed
>>        (i.e.,  the  kernel  was configured with CONFIG_SECURITY_YAMA=
),
>>        the /proc/sys/kernel/yama/ptrace_scope  file  (available  sin=
ce
>>        Linux  3.4)  can  be  used  to  restrict the ability to trace=
 a
>>        process with ptrace(2) (and thus also the ability to use  too=
ls
>>        such  as  strace(1) and gdb(1)).  The goal of such restrictio=
ns
>>        is to prevent attack escalation whereby a  compromised  proce=
ss
>>        can  ptrace-attach  to  other  sensitive processes (e.g., a G=
PG
>>        agent or an SSH session) owned by the user  in  order  to  ga=
in
>>        additional credentials and thus expand the scope of the attac=
k.
>>
>>        More precisely, the Yama LSM limits two types of operations:
>>
>>        *  Any   operation   that   performs   a   ptrace  access  mo=
de
>>           PTRACE_MODE_ATTACH     check=E2=80=94for      example,    =
  ptrace()
>>           PTRACE_ATTACH.   (See the "Ptrace access mode checking" di=
s=E2=80=90
>>           cussion above.)
>>
>>        *  ptrace() PTRACE_TRACEME.
>>
>>        A process that has the CAP_SYS_PTRACE capability can update t=
he
>>        /proc/sys/kernel/yama/ptrace_scope file with one of the follo=
w=E2=80=90
>>        ing values:
>>
>>        0 ("classic ptrace permissions")
>>               No additional restrictions on  operations  that  perfo=
rm
>>               PTRACE_MODE_ATTACH  checks  (beyond those imposed by t=
he
>>               commoncap and other LSMs).
>>
>>               The use of PTRACE_TRACEME is unchanged.
>>
>>        1 ("restricted ptrace") [default value]
>>               When   performing   an   operation   that   requires  =
 a
>>               PTRACE_MODE_ATTACH  check, the calling process must ha=
ve
>>               a predefined relationship with the target  process.   =
By
>>               default,  the predefined relationship is that the targ=
et
>>               process must be a child of the caller.
>>
>>               A target process can employ the prctl(2)  PR_SET_PTRAC=
ER
>>               operation  to declare a different PID that is allowed =
to
>>               perform PTRACE_MODE_ATTACH  operations  on  the  targe=
t.
>>               See   the   kernel   source   file   Documentation/sec=
u=E2=80=90
>>               rity/Yama.txt for further details.
>>
>>               The use of PTRACE_TRACEME is unchanged.
>
> (namespaced) CAP_SYS_PTRACE is also sufficient here.
>
>
> Both here and in the "admin-only attach" case, it is IMO important to
> note that creating a user namespace effectively removes the Yama
> protection because the owner of a namespace, when accessing its
> contents from outside, is relatively capable.
>
> This means that when a process tries to use namespaces to sandbox
> itself, it inadvertently makes itself more accessible.
>
> (This could probably be worked around in the kernel, but such a
> workaround would likely not be default, but rather opt-in via a new
> flag for clone() and unshare() or so.)

Tanks for catching this!

So I've made that section of text:

        A  process  that  has the CAP_SYS_PTRACE capability can update =
the
        /proc/sys/kernel/yama/ptrace_scope file with one of the  follow=
ing
        values:

        0 ("classic ptrace permissions")
               No  additional  restrictions  on  operations  that  perf=
orm
               PTRACE_MODE_ATTACH checks (beyond those imposed by the c=
om=E2=80=90
               moncap and other LSMs).

               The use of PTRACE_TRACEME is unchanged.

        1 ("restricted ptrace") [default value]
               When    performing    an    operation   that   requires =
  a
               PTRACE_MODE_ATTACH check, the calling process  must  eit=
her
               have the CAP_SYS_PTRACE capability in the user namespace=
 of
               the target process or it  have  a  predefined  relations=
hip
               with  the target process.  By default, the predefined re=
la=E2=80=90
               tionship is that the target process must be a child of  =
the
               caller.

               A  target  process  can  employ the prctl(2) PR_SET_PTRA=
CER
               operation to declare a different PID  that  is  allowed =
 to
               perform  PTRACE_MODE_ATTACH  operations on the target.  =
See
               the kernel source file Documentation/security/Yama.txt  =
for
               further details.

               The use of PTRACE_TRACEME is unchanged.

        2 ("admin-only attach")
               Only  processes  with  the CAP_SYS_PTRACE capability in =
the
               user  namespace  of  the   target   process   may   perf=
orm
               PTRACE_MODE_ATTACH operations or trace children that emp=
loy
               PTRACE_TRACEME.

        3 ("no attach")
               No process may  perform  PTRACE_MODE_ATTACH  operations =
 or
               trace children that employ PTRACE_TRACEME.

               Once  this value has been written to the file, it cannot=
 be
               changed.

        With respect to values 1 and 2, note that creating a  user  nam=
es=E2=80=90
        pace effectively removes the Yama protection, because the owner=
 of
        a  namespace,  when  accessing  its  members  from  outside,   =
has
        CAP_SYS_PTRACE  within  the  namespace.   This  means  that whe=
n a
        process tries to use namespaces to  sandbox  itself,  it  inadv=
er=E2=80=90
        tently weakens the protections offered by the Yama LSM.


Okay?

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
