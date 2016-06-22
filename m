From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Wed, 22 Jun 2016 14:11:38 -0700
Message-ID: <CAGXu5j+DoWCT=NwZK-yNBmZOu9LdEn=0-gjJvtPVmNJFanWoKA@mail.gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net> <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86486234-d78a-234b-58bb-6ca646881dc6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 22, 2016 at 12:21 PM, Michael Kerrisk (man-pages)
<mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 06/21/2016 10:55 PM, Jann Horn wrote:
>> On Tue, Jun 21, 2016 at 11:41:16AM +0200, Michael Kerrisk (man-pages=
)
>> wrote:
>>>        5.  The  kernel LSM security_ptrace_access_check() interface=
 is
>>>            invoked to see if ptrace access is permitted.  The  resu=
lts
>>>            depend on the LSM.  The implementation of this interface=
 in
>>>            the default LSM performs the following steps:
>>
>>
>> For people who are unaware of how the LSM API works, it might be goo=
d to
>> clarify that the commoncap LSM is *always* invoked; otherwise, it mi=
ght
>> give the impression that using another LSM would replace it.
>
>
> As we can see, I am one of those who are unaware of how the LSM API
> works :-/.
>
>> (Also, are there other documents that refer to it as "default LSM"? =
I
>> think that that term is slightly confusing.)
>
>
> No, that's a terminological confusion of my own making. Fixed now.
>
> I changed this text to:
>
>        Various parts of the kernel-user-space API (not just  ptrace(2=
)
>        operations), require so-called "ptrace access mode permissions=
"
>        which are gated by any enabled Linux Security Module (LSMs)=E2=
=80=94for
>        example,  SELinux,  Yama, or Smack=E2=80=94and by the the comm=
oncap LSM
>        (which is always invoked).  Prior to  Linux  2.6.27,  all  suc=
h
>        checks  were  of a single type.  Since Linux 2.6.27, two acces=
s
>        mode levels are distinguished:
>
> BTW, can you point me at the piece(s) of kernel code that show that
> "commoncap" is always invoked in addition to any other LSM that has
> been installed?

It's not entirely obvious, but the bottom of security/commoncap.c shows=
:

#ifdef CONFIG_SECURITY

struct security_hook_list capability_hooks[] =3D {
        LSM_HOOK_INIT(capable, cap_capable),
=2E..
};

void __init capability_add_hooks(void)
{
        security_add_hooks(capability_hooks, ARRAY_SIZE(capability_hook=
s));
}

#endif

And security/security.c shows the initialization order of the LSMs:

int __init security_init(void)
{
        pr_info("Security Framework initialized\n");

        /*
         * Load minor LSMs, with the capability module always first.
         */
        capability_add_hooks();
        yama_add_hooks();
        loadpin_add_hooks();

        /*
         * Load all the remaining security modules.
         */
        do_security_initcalls();

        return 0;
}


-Kees



--=20
Kees Cook
Chrome OS & Brillo Security
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
