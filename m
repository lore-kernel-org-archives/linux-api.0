From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Review of ptrace Yama ptrace_scope description
Date: Wed, 29 Jun 2016 06:49:47 +0200
Message-ID: <0a832f69-71fc-0b3e-bdc6-4c17f5ceadf6@gmail.com>
References: <a80772d7-f52a-0943-de24-a0cf8d6b2f7c@gmail.com>
 <20160625143006.GA24730@pc.thejh.net>
 <0017835d-c672-02fe-dab8-d1b11c100c24@gmail.com>
 <20160628205007.GA1419@pc.thejh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160628205007.GA1419-J1fxOzX/cBvk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Jann,
=2E..

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
>>               with  the target process.
>
> Nit: The grammar in this sentence seems wrong to me.
> s/or it have/or it must have/?

Yep, thanks for catching that. Fixed now.

Cheers,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
