From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v3 0/4] seccomp: Add SECCOMP_FILTER_FLAG_KILL_PROCESS
Date: Wed, 9 Aug 2017 15:33:28 -0500
Message-ID: <a0bddc6f-686e-2a5a-4833-acf04a10722f@canonical.com>
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
 <20170809202230.ivyv2cdeknb4tyn7@smitten>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="iPwxKXFt3etTNUMKI3qVXv2i4RttEPQ7j"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170809202230.ivyv2cdeknb4tyn7@smitten>
Sender: owner-linux-security-module@vger.kernel.org
To: Tycho Andersen <tycho@docker.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Fabricio Voznika <fvoznika@google.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iPwxKXFt3etTNUMKI3qVXv2i4RttEPQ7j
Content-Type: multipart/mixed; boundary="peTf77wmCW3fHb6HavI2SwNJsIAMbQWsF";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Tycho Andersen <tycho@docker.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Fabricio Voznika <fvoznika@google.com>,
 Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
 Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Message-ID: <a0bddc6f-686e-2a5a-4833-acf04a10722f@canonical.com>
Subject: Re: [PATCH v3 0/4] seccomp: Add SECCOMP_FILTER_FLAG_KILL_PROCESS
References: <1502305317-85052-1-git-send-email-keescook@chromium.org>
 <20170809202230.ivyv2cdeknb4tyn7@smitten>
In-Reply-To: <20170809202230.ivyv2cdeknb4tyn7@smitten>

--peTf77wmCW3fHb6HavI2SwNJsIAMbQWsF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hey Tycho!

On 08/09/2017 03:22 PM, Tycho Andersen wrote:
> On Wed, Aug 09, 2017 at 12:01:53PM -0700, Kees Cook wrote:
>> This series is the result of Fabricio and I going around a few times
>> on possible solutions for finding a way to enhance RET_KILL to kill
>> the process group. There's a lot of ways this could be done, but I
>> wanted something that felt cleanest. As it happens, Tyler's recent
>> patch series for logging improvement also needs to know a litte bit
>> more during filter runs, and the solution for both is to pass back
>> the matched filter. This lets us examine it here for RET_KILL and
>> in the future for logging changes.
>>
>> The filter passing is patch 1, the new flag for RET_KILL is patch 2.
>> Some test refactoring is in patch 3 for the RET_DATA ordering, and
>> patch 4 is the test for the new RET_KILL flag.
>>
>> One thing missing is that CRIU will likely need to be updated, since
>> saving/restoring seccomp filter _rules_ will not include the filter
>> _flags_ for a process. This can be addressed separately.
>=20
> Thanks for the heads up, I suppose PTRACE_SECCOMP_GET_FLAGS similar to
> how PTRACE_SECCOMP_GET_FILTER works will be fine for this. One
> question is: would we then also need to keep track of the TSYNC flag?
> I don't think CRIU needs this to be correct, and we can grab the
> KILL_PROCESS flag from filter->kill_process, so perhaps it's moot.

Note that the logging changes that I'm working on also introduce a new
filter flag (as Kees mentioned above). My filter flag is a lot like the
KILL_PROCESS filter flag in that it is stored as a member of the
seccomp_filter struct.

I would think that you'd want to be able to do something like
PTRACE_SECCOMP_GET_FILTER to (hopefully) future proof CRIU against all
newly added filter flags.

I'll also mention that I have a libseccomp branch in the making that
allows libseccomp to query the kernel to see if it supports a given
filter flag. I haven't done a PR on that yet because I'm waiting to see
how my related kernel patches play out (they seem to be getting close to
being acceptable).

Tyler

>=20
> Anyway, happy to do this and the userspace part when this lands.
>=20
> Cheers,
>=20
> Tycho
>=20
>> Please take a look!
>>
>> Thanks,
>>
>> -Kees
>>
>> v3:
>> - adjust seccomp_run_filters() to avoid later filters from masking
>>   kill-process RET_KILL actions (drewry)
>> - add test for masked RET_KILL.
>>
>> v2:
>> - moved kill_process bool into struct padding gap (tyhicks)
>> - improved comments/docs in various places for clarify (tyhicks)
>> - use ASSERT_TRUE() for WIFEXITED and WIFSIGNALLED (tyhicks)
>> - adding Reviewed-bys from tyhicks
>>



--peTf77wmCW3fHb6HavI2SwNJsIAMbQWsF--

--iPwxKXFt3etTNUMKI3qVXv2i4RttEPQ7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZi3GYAAoJENaSAD2qAscKOlkQALHKMHmyfv1k6oFOLuYCHSiw
03/eOYhNKtQ62COETMVF6kuOVwot4xZuf1jdd2ifWDUh94M8y/GqKFYg8EJToK1J
8UMIIjjZ8l1BGMCgE6QYavcXd2cseYUYHCkTGQLivyud3XvwbG/CJV1UlKN62yvf
4dCuGZfDzpL88mGce1vC6rZikxFj9IfqaujWqA3DxnBchEygKLI9sUThyr348DKn
R5gplgAVC/UBPfsiUG0CokR+JCvWSXIcdE0oyw9Tu2W8T35nCvmU8V8kwQscO8FR
yLjvztP/q4tAqswJxMlAsZgLSbnE/RWdZyWA8iRVS0NcAnVghctx69V5EdHDw8aO
WassosdGCab/+PmSJOL7AsgVyLvrejm740nRHD8WEjgMynFUaYSZBv7UMTjWXDEJ
UKO4RTGn95qILZxv8VF7ChhMs2KkSr9ziZ1aa/01T8w9zAbD5GRgS+2quGmu349D
/GOsOj6zTqAJKL8zMNFj8zm0kUtLpL7ykLpyFpMn9RqXrDk4+nnfjbj1y1L4eyf8
7eaIhW+UkNRTcgFTCdrt5aZ4lESd4L+L7l1WuFuIuCZ/chRXvWiLx6V7zJ2njcKs
UqVueP1gJ4O9JMhitYlY0efZf+X81mCB0XzD5GS0eidZU/nXnMWHxPvnVLrqRGos
4zcF2vazmZNRfm/tSaEa
=yDCn
-----END PGP SIGNATURE-----

--iPwxKXFt3etTNUMKI3qVXv2i4RttEPQ7j--
