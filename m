From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Fri, 7 Apr 2017 17:16:08 -0500
Message-ID: <ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="p8ju3UH5Af5GlqXNnIcCIX9WJuILqKxQb"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--p8ju3UH5Af5GlqXNnIcCIX9WJuILqKxQb
Content-Type: multipart/mixed; boundary="TBSLhDpXJWp71HgNgClKLjgI17ruwKs7a";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>,
 Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <ac79529e-f6b6-690c-e597-5adeb75b0f25-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
References: <1487043928-5982-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--TBSLhDpXJWp71HgNgClKLjgI17ruwKs7a
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/22/2017 12:46 PM, Kees Cook wrote:
> On Thu, Feb 16, 2017 at 3:29 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrot=
e:
>> On Wed, Feb 15, 2017 at 7:24 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>=
 wrote:
>>> On Mon, Feb 13, 2017 at 7:45 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> =
wrote:
>>>> This patch set is the third revision of the following two previously=

>>>> submitted patch sets:
>>>>
>>>> v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyhic=
ks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>> v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyhic=
ks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>>
>>>> v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyhic=
ks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>>>>
>>>> The patch set aims to address some known deficiencies in seccomp's c=
urrent
>>>> logging capabilities:
>>>>
>>>>   1. Inability to log all filter actions.
>>>>   2. Inability to selectively enable filtering; e.g. devs want noisy=
 logging,
>>>>      users want relative quiet.
>>>>   3. Consistent behavior with audit enabled and disabled.
>>>>   4. Inability to easily develop a filter due to the lack of a
>>>>      permissive/complain mode.
>>>
>>> I think I dislike this, but I think my dislikes may be fixable with
>>> minor changes.
>>>
>>> What I dislike is that this mixes app-specific built-in configuration=

>>> (seccomp) with global privileged stuff (audit).  The result is a
>>> potentially difficult to use situation in which you need to modify an=

>>> app to make it loggable (using RET_LOG) and then fiddle with
>>> privileged config (auditctl, etc) to actually see the logs.
>>
>> You make a good point about RET_LOG vs log_max_action. I think making
>> RET_LOG the default value would work for 99% of the cases.
>=20
> Actually, I take this back: making "log" the default means that
> everything else gets logged too, include "expected" return values like
> errno, trap, etc. I think that would be extremely noisy as a default
> (for upstream or Ubuntu).
>=20
> Perhaps RET_LOG should unconditionally log? Or maybe the logged
> actions should be a bit field instead of a single value? Then the
> default could be "RET_KILL and RET_LOG", but an admin could switch it
> to just RET_KILL, or even nothing at all? Hmmm...

Hi Kees - my apologies for going quiet on this topic after we spoke
about it more in IRC. I needed to tend to other work but now I'm able to
return to this seccomp logging patch set.

To summarize what we discussed in IRC, the Chrome browser makes
extensive use of RET_ERRNO, RET_TRACE, etc., to sandbox code that may
not ever be adjusted to keep from bump into the sandbox walls.
Therefore, it is unreasonable to enable logging of something like
RET_ERRNO on a system-wide level where Chrome browser is in use.

In contrast, snapd wants to set up "noisier" sandboxes for applications
to make it clear to the developers and the users that the sandboxed
application is bumping into the sandbox walls. Developers will know why
their code may not be working as intended and users will know that the
application is doing things that the platform doesn't agree with. These
sandboxes will end up using RET_ERRNO in the majority of cases.

This means that with the current design of this patch set, Chrome
browser will either be unintentionally spamming the logs or snapd's
sandboxes will be helplessly silent when both Chrome and snapd is
installed at the same time, depending on the admin's preferences.

To bring it back up a level, two applications may have a very different
outlook on how acceptable a given seccomp action is and they may
disagree on whether or not the user/administrator should be informed.

I've been giving thought to the idea of providing a way for the
application setting up the filter to opt into logging of certain
actions. Here's a high level breakdown:

 - The administrator will have control of system-wide seccomp logging
   and the application will have control of how its seccomp actions are
   logged
 - Both the administrator's and application's logging preferences are
   bitmasks of actions that should be logged
 - The default administrator bitmask is set to log all actions except
   RET_ALLOW
   + Configurable via a sysctl
   + Very similar to the log_max_action syscall that was proposed in
     this patch set but a bitmask instead of a max action
 - The default application bitmask is set to log only RET_KILL and
   RET_LOG
   + Configurable via the seccomp(2) syscall (details TBD)
 - Actions are only logged when the application has requested the
   action to be logged and the administrator has allowed the action to
   be logged
   + By default, this is only RET_KILL and RET_LOG actions

Let me know what you think about this and I can turn out another patch
set next week if it sounds reasonable.

Tyler


--TBSLhDpXJWp71HgNgClKLjgI17ruwKs7a--

--p8ju3UH5Af5GlqXNnIcCIX9WJuILqKxQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJY6A+oAAoJENaSAD2qAscKkHAP/jfuAlBWmCSLAEcvdz/cu8Yl
RXaGcXTyKx1Hw5Ks5CPtnpL/eEVr4JnmlpbLvMttPIJ7B6yW3DsbQhjehyOO5gkN
Lh9vkyqMOqmOTvs2ItNvWtmwMqwj2fy+qF7KcxRoolOrAYcxAf5NfZwBym9dL1Cf
wyVLXueY+qrK0CtW56LJfSExXwRhAoHrmPjQ2wf6bnmQzWOkHNUFCh2NTuIpZQMS
qcqKO6zAJ0pDuwoSQ0m2uYwItWGngcwee0T3g3LuBrI4GMR1egI4g/Cq6i1yQzqT
LE5Scb7EA9MXG1Bsq9bmSKJrDQK3vNDjSD8SnP/c8wGyEdjeOfT3YBh90p4VB1Ud
FbnsXTue4gNf/tiZ2wLy2m3IxZwyEKiBshUTQEwTCb9vPeNOlgXAu+80n18aUpm3
vqnNqeV2jAlO5fZEjJWF1UxrqDwqVL52W00jSXFXB1of0vsAKc+qCoQyPVPpqD07
FO0VTu5aMnqeymPjzloQwZNqDZd7TIjjkatdHDwwjwA6JCTKl2Omy65vbF3VA88+
d3/DGMgUOLg1smZ7y1IumXdPbTKjPHuMUPb39xMLxZqNQgLYaNfZRsdEglM9S+D8
dwjWHR8+rWN8D76bqP2f8UopBrEK1yBaz6V9a5CNKcvpr4uRPrXyTN3ieNLppTCc
ygljpjhaJCWSxm/25WAt
=5cgY
-----END PGP SIGNATURE-----

--p8ju3UH5Af5GlqXNnIcCIX9WJuILqKxQb--
