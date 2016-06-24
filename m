From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Documenting ptrace access mode checking
Date: Fri, 24 Jun 2016 13:07:13 -0700
Message-ID: <CAGXu5jJT2m0z-bDXjGb8dSmy=Qy1=1D8smdMBgKdJxRzwk327A@mail.gmail.com>
References: <e335a243-2199-2185-c7b3-fb1c898e9ab4@gmail.com>
 <20160621205550.GA5191@pc.thejh.net> <86486234-d78a-234b-58bb-6ca646881dc6@gmail.com>
 <CAGXu5j+DoWCT=NwZK-yNBmZOu9LdEn=0-gjJvtPVmNJFanWoKA@mail.gmail.com>
 <7eee2029-4269-f9ab-78a7-341556f1350d@gmail.com> <f45383ca-6bdc-bba0-07d0-a8e3cb9c08d2@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f45383ca-6bdc-bba0-07d0-a8e3cb9c08d2-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 24, 2016 at 8:18 AM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
> On 6/24/2016 1:40 AM, Michael Kerrisk (man-pages) wrote:
>> So, I just want to check my understanding of a couple of points:
>>
>> 1. The commoncap LSM is invoked first, and if it denies access,
>>    then no further LSM is/needs to be called.
>
> Yes. The LSM infrastructure is "bail on fail".
>
>>
>> 2. Is it the case that only one of the other LSMs (SELinux, Yama,
>>    AppArmor, etc.) is invoked, or can more than one be invoked.
>>    I thought only one is invoked, but perhaps I am out of date
>>    in my understanding.
>
> All registered modules are invoked, but only one "major"
> module can be registered. The "minor" modules show up in
> security_init, while the majors come in via do_security_initcalls.

Just to fill in the history: prior the the recent LSM stacking changes
(v4.2), commoncap (which is effectively an LSM) was hard-coded to be
stacked with the single selected primary LSM. Then Yama got hard-coded
stacked with the primary LSM too, and then Casey saved us from total
insanity by providing a proper way to stack LSMs.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
