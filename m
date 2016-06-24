From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Documenting ptrace access mode checking
Date: Fri, 24 Jun 2016 08:18:30 -0700
Message-ID: <f45383ca-6bdc-bba0-07d0-a8e3cb9c08d2@schaufler-ca.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net>
 <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
 <CAGXu5j+DoWCT=NwZK-yNBmZOu9LdEn=0-gjJvtPVmNJFanWoKA@mail.gmail.com>
 <7eee2029-4269-f9ab-78a7-341556f1350d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7eee2029-4269-f9ab-78a7-341556f1350d@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jann@thejh.net>, James Morris <jmorris@namei.org>, linux-man <linux-man@vger.kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, lkml <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



On 6/24/2016 1:40 AM, Michael Kerrisk (man-pages) wrote:
> On 06/22/2016 11:11 PM, Kees Cook wrote:
>> On Wed, Jun 22, 2016 at 12:21 PM, Michael Kerrisk (man-pages)
>> <mtk.manpages@gmail.com> wrote:
>>> On 06/21/2016 10:55 PM, Jann Horn wrote:
>>>> On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-pag=
es)
>>>> wrote:
>>>>>        5.  The  kernel LSM security_ptrace_access_check() interfa=
ce is
>>>>>            invoked to see if ptrace access is permitted.  The  re=
sults
>>>>>            depend on the LSM.  The implementation of this interfa=
ce in
>>>>>            the default LSM performs the following steps:
>>>>
>>>>
>>>> For people who are unaware of how the LSM API works, it might be g=
ood to
>>>> clarify that the commoncap LSM is *always* invoked; otherwise, it =
might
>>>> give the impression that using another LSM would replace it.
>>>
>>>
>>> As we can see, I am one of those who are unaware of how the LSM API
>>> works :-/.
>>>
>>>> (Also, are there other documents that refer to it as "default LSM"=
? I
>>>> think that that term is slightly confusing.)
>>>
>>>
>>> No, that's a terminological confusion of my own making. Fixed now.
>>>
>>> I changed this text to:
>>>
>>>        Various parts of the kernel-user-space API (not just  ptrace=
(2)
>>>        operations), require so-called "ptrace access mode permissio=
ns"
>>>        which are gated by any enabled Linux Security Module (LSMs)=E2=
=80=94for
>>>        example,  SELinux,  Yama, or Smack=E2=80=94and by the the co=
mmoncap LSM
>>>        (which is always invoked).  Prior to  Linux  2.6.27,  all  s=
uch
>>>        checks  were  of a single type.  Since Linux 2.6.27, two acc=
ess
>>>        mode levels are distinguished:
>>>
>>> BTW, can you point me at the piece(s) of kernel code that show that
>>> "commoncap" is always invoked in addition to any other LSM that has
>>> been installed?
>>
>> It's not entirely obvious, but the bottom of security/commoncap.c sh=
ows:
>>
>> #ifdef CONFIG_SECURITY
>>
>> struct security_hook_list capability_hooks[] =3D {
>>         LSM_HOOK_INIT(capable, cap_capable),
>> ...
>> };
>>
>> void __init capability_add_hooks(void)
>> {
>>         security_add_hooks(capability_hooks, ARRAY_SIZE(capability_h=
ooks));
>> }
>>
>> #endif
>>
>> And security/security.c shows the initialization order of the LSMs:
>>
>> int __init security_init(void)
>> {
>>         pr_info("Security Framework initialized\n");
>>
>>         /*
>>          * Load minor LSMs, with the capability module always first.
>>          */
>>         capability_add_hooks();
>>         yama_add_hooks();
>>         loadpin_add_hooks();
>>
>>         /*
>>          * Load all the remaining security modules.
>>          */
>>         do_security_initcalls();
>>
>>         return 0;
>> }
>
> So, I just want to check my understanding of a couple of points:
>
> 1. The commoncap LSM is invoked first, and if it denies access,
>    then no further LSM is/needs to be called.

Yes. The LSM infrastructure is "bail on fail".

>
> 2. Is it the case that only one of the other LSMs (SELinux, Yama,
>    AppArmor, etc.) is invoked, or can more than one be invoked.
>    I thought only one is invoked, but perhaps I am out of date
>    in my understanding.

All registered modules are invoked, but only one "major"
module can be registered. The "minor" modules show up in
security_init, while the majors come in via do_security_initcalls.

I am in the process of messing that all up with patches
allowing multiple major modules. Stay tuned.

>
> Cheers,
>
> Michael
>
>
