From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
Date: Mon, 17 Nov 2014 14:22:59 -0800
Message-ID: <CALCETrWXC5dMOXTTBOiq4Cv+yjqbA_UdmAN-TDmNAJUo+ABxtg@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org> <20141116034005.GC5507@thunk.org>
 <20141116045232.GB18880@thin> <20141117113734.396798e6@lxorguk.ukuu.org.uk>
 <CALCETrXi1qHyu4_U7cbROB74n461nBZ9R7=0kfhR8-VFAwOF1w@mail.gmail.com> <0b65fd07-48ea-483b-8fd5-fd84d0bff881@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0b65fd07-48ea-483b-8fd5-fd84d0bff881-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W.Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 17, 2014 at 2:11 PM, Eric W.Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
>
> On November 17, 2014 1:07:30 PM EST, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>On Nov 17, 2014 3:37 AM, "One Thousand Gnomes"
>><gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:
>>>
>>> > optional), I can do that too.  The security model of "having a
>>group
>>> > gives you less privilege than not having it" seems crazy, but
>>> > nonetheless I can see a couple of easy ways that we can avoid
>>breaking
>>>
>>> It's an old pattern of use that makes complete sense in a traditional
>>> Unix permission world because it's the only way to do "exclude
>>{list}"
>>> nicely. Our default IMHO shouldn't break this.
>>>
>>> > that pattern, no_new_privs being one of them.  I'd like to make
>>sure
>>> > that nobody sees any other real-world corner case that unprivileged
>>> > setgroups would break.
>>>
>>> Barring the usual risk of people doing improper error checking I
>>don't
>>> see one immediately.
>>>
>>> For containers I think it actually makes sense that the sysctl can be
>>> applied per container anyway.
>>
>>We'll probably need per container sysctls some day.
>
> We already have a mess of per network namespace sysctls,
> as well as few for other namespaces.
>
> We have the infrastructure it is just a matter of using it for whatever purpose we need.
>

A list of group id ranges that it's permissible to drop would do the
trick, both for setgroups and for unshare.  The downside would be that
users in those groups (i.e. everyone by default) would not be able to
unshare their user ns.

Better ideas welcome.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
