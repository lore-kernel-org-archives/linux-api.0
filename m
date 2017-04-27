From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Thu, 27 Apr 2017 17:17:35 -0500
Message-ID: <0b1a2337-7006-e7cb-f519-dec389ede041@canonical.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
 <ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com>
 <CAGXu5j+qUOpnDeF4TMH2AXXgHZB_WfHHfxe3TBSShmneisR-Lg@mail.gmail.com>
 <a914076f-efb8-d867-f480-69addca4e628@canonical.com>
 <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="MQNEkEbIaauBNlD2x8LuV6jpoDeVQDFL0"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MQNEkEbIaauBNlD2x8LuV6jpoDeVQDFL0
Content-Type: multipart/mixed; boundary="dSLckhQSqU8QTuq75m6q4padCQ6ppDINt";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Paul Moore <paul@paul-moore.com>,
 Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>,
 linux-audit@redhat.com,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <0b1a2337-7006-e7cb-f519-dec389ede041@canonical.com>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
 <ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com>
 <CAGXu5j+qUOpnDeF4TMH2AXXgHZB_WfHHfxe3TBSShmneisR-Lg@mail.gmail.com>
 <a914076f-efb8-d867-f480-69addca4e628@canonical.com>
 <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>

--dSLckhQSqU8QTuq75m6q4padCQ6ppDINt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/10/2017 10:59 PM, Kees Cook wrote:
> On Fri, Apr 7, 2017 at 4:46 PM, Tyler Hicks <tyhicks@canonical.com> wro=
te:
>> On 04/07/2017 05:46 PM, Kees Cook wrote:
>>> Does the app-controlled bitmask apply to the filter, the process, the=

>>> process tree, or something else? e.g. systemd launches an app with a
>>> filter, leaving the defaults alone, then later process installs a
>>> filter and wants everything logged -- will things from the earlier
>>> filter get logged?
>>
>> I think implementation preferences may decide many of these questions.=

>> As I see it, here are the options in order of my preference:
>>
>> A) Claim the MSB of the filter return value and make the app logging
>>    preference per-rule
>>    - If the bit is set, log the rule
>>    - Provides very fine-grained logging control at the "high cost" of
>>      the remaining free bit in the filter return bitmask
>>    - The bit can be ignored in the case of RET_KILL
>>    - Can be synced across all threads in the calling task with the
>>      SECCOMP_FILTER_FLAG_TSYNC filter flag
>>
>> B) Claim a few bits in the filter flags and make the app logging
>>    preference per-filter
>>    - Something like SECCOMP_FILTER_FLAG_LOG_TRAP,
>>      SECCOMP_FILTER_FLAG_LOG_ERRNO, and
>>      SECCOMP_FILTER_FLAG_LOG_TRACE
>>    - Logging for RET_KILL and RET_LOG can't be turned off
>>    - I'd prefer not to waste a bit for RET_ALLOW in this case so it
>>      simply won't be loggable
>>    - Works with the SECCOMP_FILTER_FLAG_TSYNC filter flag
>>    - Doesn't scale well if many new actions are added in the future
>>
>> C) A simplified version of 'B' where only a single mode bit is claimed=

>>    to enable logging for all actions except RET_ALLOW
>>    - Something like SECCOMP_FILTER_FLAG_LOG_ACTIONS
>>    - Filters without this flag only log RET_KILL and RET_LOG
>>    - Scales much better than 'B' at the expense of less flexibility
>>    - Works with the SECCOMP_FILTER_FLAG_TSYNC filter flag
>>
>> D) Claim a bit in the filter mode and make the app logging preference
>>    per-process
>>    - This new SECCOMP_MODE_ENABLE_LOGGING mode would take a bitmask of=

>>      actions that should be logged
>>    - Incurs a small per-task increase in memory footprint in the form
>>      of an additional member in 'struct seccomp'
>>    - Has odd behavior you described above where launchers may set the
>>      logging preference and then launched application may want
>>      something different
>>
>> I think 'A' is the cleanest design but I don't know if highly
>> configurable logging is deserving of the MSB bit in the filter return.=

>> I'd like to hear your thoughts there.
>>
>> I _barely_ prefer 'B' over 'C'. They're essential equal in my use case=
=2E
>>
>> To be honest, I haven't completely wrapped my head around how 'D' woul=
d
>> actually work in practice so I may be writing it off prematurely.
>>
>> Am I missing any more clever options that you can think of? Let me kno=
w
>> what you think of the possibilities.
>=20
> Hmm, so, I think we can just make this a bitmask in the process
> seccomp struct. It'll get inherited across forks, and any filter that
> wants to make sure it never changes again can just blacklist the
> seccomp syscall with that argument. I don't see anything about the
> logging that should be considered private, considering the logs are
> going through syslog or auditd. Since it's already out-of-band, this
> won't change the behavior of ptrace monitors, etc.
>=20
> So, how about seccomp(SECCOMP_SET_LOGGING, flags, user_ptr) and
> ...GET_LOGGING? flags likely 0, and user_ptr can point to:
>=20
> struct seccomp_logging {
>     u32 count;
>     u32 values[];
> };
>=20
> Where each value entry is a filter return value to log. (That way
> bitmasks are just an internal storage detail and we're allowed to add
> new filter returns without breaking a bitmask UAPI.)

Quick update... I finished the move from the high-water mark
log_max_action sysctl to the bitmask based actions_logged sysctl.

Unfortunately, I've just realized that SECCOMP_SET_LOGGING, or any
process-wide logging configuration mechanism, will not work. It is fine
for the situation where two unrelated processes set up seccomp filters
that should be logged differently. However, it fails when two closely
related processes, such as parent and child, need to set up seccomp
filters that should be logged differently. Imagine a launcher that sets
up an application sandbox (including a seccomp filter) and then launches
an electron app which will have its own seccomp filter for sandboxing
untrusted code that it runs. Unless the launcher and app completely
agree on actions that should be logged, the logging won't work as
intended for both processes.

I think this needs to be configured at the filter level.

Tyler


--dSLckhQSqU8QTuq75m6q4padCQ6ppDINt--

--MQNEkEbIaauBNlD2x8LuV6jpoDeVQDFL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZAm4EAAoJENaSAD2qAscKSnEQALwsX8hs1R7uSqvy9yISHumV
eB2+ys23lXg7odAORK3cg9rXxX0+fNNKpsj3dQCuhFm/Ck6ZlrjumEvy8yYM5iEv
UKbYkw3MLr9fMOVbxi4tjx+iAly7ZBdHpKtQcrZ0gJlrN8jbWCE/jxbSEC11qi07
UkLAd8A4kmSofHzk/QLMnL1oKfDKlvXtelX/nzUE83jYTgwXt52Kh/qqj33zCD+N
QGe157GZzRdlQU1BjVaKoxnbJ70oNii/54aomIRGgSiaVlVFuQdERd4YQxjL1gT1
orsGnyRmKQk2fnfcuL6WAY75k15XhzdD8upjJplKWknU3daX8X3MycFN8TaIYpxc
SKyTcMTYO2St/tn/S3zKmF3tRWRBWxjD7bvSMaP0bOGBH32PK/SpTEO2GJXH6vJq
2GjgCo5YGBkdHL6Ea9EkqJNy8A4jYj+OWi9CAyKxNucVao8LEdP4Trwyi+BD4kPX
pckJPI2pe8irSa+ejsVEF0CgwHAeat3lKGWqxRMaTfIk3Y/NHpe00zS0SoizlHZ1
1TTp/vH284qt3WOsvsudnbJQz8MEs3TSRRConjMbkDEkN+yMGb6OCMzZArdQUG0F
ucpjmNpZeSy9FM82DNLzo7rnGJhZgeH6dSOdGkxcefw/Rq10Anjbfh0UVeXkiWHn
dirWvvqqFIg6uw2wjGv8
=Zl4u
-----END PGP SIGNATURE-----

--MQNEkEbIaauBNlD2x8LuV6jpoDeVQDFL0--
