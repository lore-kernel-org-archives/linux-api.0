From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Mon, 10 Apr 2017 14:22:28 -0500
Message-ID: <087fa5ee-ce6d-456d-610f-2a0855cdd50b@canonical.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
 <ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com>
 <CALCETrXJKtnXmzRHs=7mEXN7FVAYjzxKb=jwrqwXQoXB0dHHPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="IBw2d1gRR4jdqfbLSqNKelqb83oP6qUS0"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXJKtnXmzRHs=7mEXN7FVAYjzxKb=jwrqwXQoXB0dHHPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IBw2d1gRR4jdqfbLSqNKelqb83oP6qUS0
Content-Type: multipart/mixed; boundary="RU86GLwT9mELkRKPq40mi5o3Ube5Jprfe";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>,
 Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <087fa5ee-ce6d-456d-610f-2a0855cdd50b-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
References: <1487043928-5982-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <ac79529e-f6b6-690c-e597-5adeb75b0f25-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CALCETrXJKtnXmzRHs=7mEXN7FVAYjzxKb=jwrqwXQoXB0dHHPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CALCETrXJKtnXmzRHs=7mEXN7FVAYjzxKb=jwrqwXQoXB0dHHPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--RU86GLwT9mELkRKPq40mi5o3Ube5Jprfe
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/10/2017 10:57 AM, Andy Lutomirski wrote:
> On Fri, Apr 7, 2017 at 3:16 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wro=
te:
>> On 02/22/2017 12:46 PM, Kees Cook wrote:
>>> On Thu, Feb 16, 2017 at 3:29 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wr=
ote:
>>>> On Wed, Feb 15, 2017 at 7:24 PM, Andy Lutomirski <luto-kltTT9wpgjKXcx/E+B78Qg@public.gmane.org=
t> wrote:
>>>>> On Mon, Feb 13, 2017 at 7:45 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org=
> wrote:
>>>>>> This patch set is the third revision of the following two previous=
ly
>>>>>> submitted patch sets:
>>>>>>
>>>>>> v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyh=
icks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>>>> v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyh=
icks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>>>>
>>>>>> v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyh=
icks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>>>>
>>>>>> The patch set aims to address some known deficiencies in seccomp's=
 current
>>>>>> logging capabilities:
>>>>>>
>>>>>>   1. Inability to log all filter actions.
>>>>>>   2. Inability to selectively enable filtering; e.g. devs want noi=
sy logging,
>>>>>>      users want relative quiet.
>>>>>>   3. Consistent behavior with audit enabled and disabled.
>>>>>>   4. Inability to easily develop a filter due to the lack of a
>>>>>>      permissive/complain mode.
>>>>>
>>>>> I think I dislike this, but I think my dislikes may be fixable with=

>>>>> minor changes.
>>>>>
>>>>> What I dislike is that this mixes app-specific built-in configurati=
on
>>>>> (seccomp) with global privileged stuff (audit).  The result is a
>>>>> potentially difficult to use situation in which you need to modify =
an
>>>>> app to make it loggable (using RET_LOG) and then fiddle with
>>>>> privileged config (auditctl, etc) to actually see the logs.
>>>>
>>>> You make a good point about RET_LOG vs log_max_action. I think makin=
g
>>>> RET_LOG the default value would work for 99% of the cases.
>>>
>>> Actually, I take this back: making "log" the default means that
>>> everything else gets logged too, include "expected" return values lik=
e
>>> errno, trap, etc. I think that would be extremely noisy as a default
>>> (for upstream or Ubuntu).
>>>
>>> Perhaps RET_LOG should unconditionally log? Or maybe the logged
>>> actions should be a bit field instead of a single value? Then the
>>> default could be "RET_KILL and RET_LOG", but an admin could switch it=

>>> to just RET_KILL, or even nothing at all? Hmmm...
>>
>> Hi Kees - my apologies for going quiet on this topic after we spoke
>> about it more in IRC. I needed to tend to other work but now I'm able =
to
>> return to this seccomp logging patch set.
>>
>> To summarize what we discussed in IRC, the Chrome browser makes
>> extensive use of RET_ERRNO, RET_TRACE, etc., to sandbox code that may
>> not ever be adjusted to keep from bump into the sandbox walls.
>> Therefore, it is unreasonable to enable logging of something like
>> RET_ERRNO on a system-wide level where Chrome browser is in use.
>>
>> In contrast, snapd wants to set up "noisier" sandboxes for application=
s
>> to make it clear to the developers and the users that the sandboxed
>> application is bumping into the sandbox walls. Developers will know wh=
y
>> their code may not be working as intended and users will know that the=

>> application is doing things that the platform doesn't agree with. Thes=
e
>> sandboxes will end up using RET_ERRNO in the majority of cases.
>>
>> This means that with the current design of this patch set, Chrome
>> browser will either be unintentionally spamming the logs or snapd's
>> sandboxes will be helplessly silent when both Chrome and snapd is
>> installed at the same time, depending on the admin's preferences.
>>
>> To bring it back up a level, two applications may have a very differen=
t
>> outlook on how acceptable a given seccomp action is and they may
>> disagree on whether or not the user/administrator should be informed.
>>
>> I've been giving thought to the idea of providing a way for the
>> application setting up the filter to opt into logging of certain
>> actions. Here's a high level breakdown:
>=20
> At the risk of overcomplicating things, I think this issue may be a
> decent argument for doing something more like what I suggested
> earlier: let seccomp users emit loggable things and let their parents
> (optionally) catch and handle those things.  Then we get real scoping
> rather than fiddling with bitmasks and hoping we get what we want to
> see without generating massive log spam.

Hi Andy - I remembered your proposal and considered it when I was
writing up mine. I still feel like it is easier to get the logging
bitmask right, if you even need to adjust the default bitmask, than to
force parent processes to act as a relay for log messages.

The logging bitmasks can easily be adjusted in debug builds or when a
user specifies a runtime option to enable seccomp logging in a program
that sets up filters.

Another potential issue with the parent process handling the logging is
that it isn't always possible when audit is in use.
audit_log_user_message() requires CAP_AUDIT_WRITE (seems like
CAP_AUDIT_CONTROL might also be required but I can't remember why) so
unprivileged processes would have to divert their log messages elsewhere.=


Tyler



--RU86GLwT9mELkRKPq40mi5o3Ube5Jprfe--

--IBw2d1gRR4jdqfbLSqNKelqb83oP6qUS0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY69t8AAoJENaSAD2qAscKXucQAMVP2VwnRaE1uKnrbQg2HHV4
9231wr7VmujMfC3slDuzJVoj19i9ZIKbzDIujc9YbWC17pJlTeooLQM5UnRJjDPW
TGU7WRmmzUI+o7igw5afMMlr6riLDjlJPp2ZIzvaCjwzwLvwxh2pJXsYIbesLcW7
ESlq/3PavChZChSB1M1WLUavJX6EtNSVYuAHwmuqZVXhyyzWDE9Vy9HbaCyTDG7l
mPZSPmBaZ2aPX9SfY8nnAV+y5EHT84S4oAV3wOqZ7W9d1RvPwlOabPYFvQNTfmE7
E10fKgXNerwSsmjULPHoSldrjKLmFZi4MZJA+n3cc7wbICOD3yGk2C1y4O6omNsT
ur/hpuBOr4dTCBGNKZtBlSC289Y6m1xuc7VMwIL7JFigMoD6OAWmM4A+NMjMlQMS
xLYsaxx9rJkgSefjoNAnRCuUwfThcUUooIqq7um7zUcVRcGgEc8JXwlD7aYecNnN
/cNeKckubd0GxMY2OygOz31KVPOHkah8f4o1QD/lCbm8EsNj/QkjmUDCG28fcZXu
dB3eYir898UATV/ZNGRbYBWOkdpyTAqlcV/9je7R1MimgRXQoJviCLcYHMjzGOaK
bJ3DqtbIMp10+aVR2VdCmLbBSgzSV8H5eOcDp+sjRYy52NW2h9A4Fst7+foxLdqV
OlDxrUQHzbr800nM3UNR
=lIWm
-----END PGP SIGNATURE-----

--IBw2d1gRR4jdqfbLSqNKelqb83oP6qUS0--
