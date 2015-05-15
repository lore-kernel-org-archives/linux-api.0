From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Fri, 15 May 2015 05:03:27 -0700
Message-ID: <CALCETrUGivM6Jafp5npznsoUZQX04vzS+xr4HED5J4EbYD2OwQ@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
 <1431689523.1769.1.camel@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431689523.1769.1.camel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 15, 2015 at 4:32 AM, Lukasz Pawelczyk
<l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
> On czw, 2015-05-14 at 23:39 -0700, Andy Lutomirski wrote:
>> @@ -696,10 +729,18 @@ static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
>>            uid_eq(old->suid, root_uid)) &&
>>           (!uid_eq(new->uid, root_uid) &&
>>            !uid_eq(new->euid, root_uid) &&
>> -          !uid_eq(new->suid, root_uid)) &&
>> -         !issecure(SECURE_KEEP_CAPS)) {
>> -             cap_clear(new->cap_permitted);
>> -             cap_clear(new->cap_effective);
>> +          !uid_eq(new->suid, root_uid))) {
>> +             if (!issecure(SECURE_KEEP_CAPS)) {
>> +                     cap_clear(new->cap_permitted);
>> +                     cap_clear(new->cap_effective);
>> +             }
>> +
>> +             /*
>> +              * Pre-ambient programs except setresuid to nonroot followed
>
> I think you meant "expect". This typo changes the meaning of the
> sentence.

Good catch.  I'll fix that for v3.

--Andy
