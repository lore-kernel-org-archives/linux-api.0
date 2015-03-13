From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 10:58:04 -0700
Message-ID: <CALCETrXcUfbqfm7av9crrxQ5nCBYpdJO8gRo4ZhRA97g27B2iw@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
 <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
 <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
 <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
 <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com> <alpine.DEB.2.11.1503131049150.13899@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1503131049150.13899-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 9:06 AM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, 13 Mar 2015, Andrew G. Morgan wrote:
>
>> > prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_SYS_ADMIN);
>> > system("/bin/bash");
>>
>> Let's call the above two lines [a] and [b]. With this patch, you are
>> encouraging folk to write programs that contain a line like [a]
>> already. So, yes, I am saying that you are creating an exploitable
>> path in these programs that says if someone can inject
>> system("/bin/bash") into these programs they can get a new (because of
>> this patch) privilege escalation.
>
> Well this is what one naively expects capabilities to give you. An ability
> to avoid full superuser binaries by segmenting off capabilities. Often
> there is really no other choice. If you do not provide this mode then
> the system will be even less secure since people run stuff as root.
>
> This looks to many like the design of capabilties is inherent flawed since
> it does not give you what you need. You experience a go around that leads
> nowhere and just wastes your time.
>
>> In the prevailing model, this kind of privilege escalation (resulting
>> from naive inheritance) is designed out. I recognize that you want to
>> add it back in, but I am concerned that you are not allowing for the
>> possibility that some folk might still want to still be able to
>> prevent it.
>
> The functionalty here depends on CAP_SETPCAP. That was intended as some
> point to be off by default? You can have distros/kernels with that being
> off.

Not in my version.  I don't want to further encourage people to hand
out CAP_SETPCAP.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
