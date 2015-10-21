From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Wed, 21 Oct 2015 15:13:23 -0400
Message-ID: <5627E3D3.1070407@gmail.com>
References: <5622700C.9090107@miglix.eu> <5624FD3B.2050401@gmail.com>
 <CALCETrWfZ9hXvLPtJnZhU-ZdoUbYNo-QSydMPvP6Q7Rp0oCQaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010409010104060407090907"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWfZ9hXvLPtJnZhU-ZdoUbYNo-QSydMPvP6Q7Rp0oCQaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010409010104060407090907
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-21 14:53, Andy Lutomirski wrote:
> On Oct 19, 2015 7:25 AM, "Austin S Hemmelgarn" <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>
>> On 2015-10-17 11:58, Tobias Markus wrote:
>>>
>>> Add capability CAP_SYS_USER_NS.
>>> Tasks having CAP_SYS_USER_NS are allowed to create a new user namespa=
ce
>>> when calling clone or unshare with CLONE_NEWUSER.
>>>
>>> Rationale:
>>>
>>> Linux 3.8 saw the introduction of unpriviledged user namespaces,
>>> allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" r=
oot
>>> inside a separate user namespace. Before that, any namespace creation=

>>> required CAP_SYS_ADMIN (or, in practice, the user had to be root).
>>> Unfortunately, there have been some security-relevant bugs in the
>>> meantime. Because of the fairly complex nature of user namespaces, it=
 is
>>> reasonable to say that future vulnerabilties can not be excluded. Som=
e
>>> distributions even wholly disable user namespaces because of this.
>>>
>>> Both options, user namespaces with and without CAP_SYS_ADMIN, can be
>>> said to represent the extreme end of the spectrum. In practice, there=
 is
>>> no reason for every process to have the abilitiy to create user
>>> namespaces. Indeed, only very few and specialized programs require us=
er
>>> namespaces. This seems to be a perfect fit for the (file) capability
>>> system: Priviledged users could manually allow only a certain executa=
ble
>>> to be able to create user namespaces by setting a certain capability,=

>>> I'd suggest the name CAP_SYS_USER_NS. Executables completely unrelate=
d
>>> to user namespaces should and can not create them.
>>>
>>> The capability should only be required in the "root" user namespace (=
the
>>> user namespace with level 0) though, to allow nested user namespaces =
to
>>> work as intended. If a user namespace has a level greater than 0, the=

>>> original process must have had CAP_SYS_USER_NS, so it is "trusted" an=
yway.
>>>
>>> One question remains though: Does this break userspace executables th=
at
>>> expect being able to create user namespaces without priviledge? Since=

>>> creating user namespaces without CAP_SYS_ADMIN was not possible befor=
e
>>> Linux 3.8, programs should already expect a potential EPERM upon call=
ing
>>> clone. Since creating a user namespace without CAP_SYS_USER_NS would
>>> also cause EPERM, we should be on the safe side.
>>
>>
>> Potentially stupid counter proposal:
>> Make it CAP_SYS_NS, make it allow access to all namespace types for no=
n-root/CAP_SYS_ADMIN users, and teach the stuff that's using userns just =
to get to mount/pid/net/ipc namespaces to use those instead when it's som=
ething that doesn't really need to think it's running as root.
>>
>> While this would still add a new capability (which is arguably not a g=
ood thing), the resultant capability would be significantly more useful f=
or many of the use cases.
>
> Then you'd have to come up with some argument that it could possibly
> be safe.  You'd need *at least* no_new_privs forced on.  You would
> also have fun defining the privilege to own such a namespace once
> created.
Excellent point about the privileges, although wouldn't that also apply=20
to just using a capability for non-root/CAP_SYS_ADMIN access to userns?


--------------ms010409010104060407090907
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIxMTkxMzIzWjBPBgkq
hkiG9w0BCQQxQgRAihNLo4qsvHnDS++F5QpmRLJbiEXgR6FqOHXAsT69y3TpZlRPrvy/lenw
9rz9A6j/l0TM2GRnmxQ1w62TlRW+zTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB/a3+QKUlVrvISA+wQHOa/HzvLORqb1aUeEEbp3biEUDI5H0am
tIPeh3ig/TRN4k2hmbf1vwiCJGs66ZIy5IrIoKIgUYt/wUc8K9HM8SJNbGwonpXE6d26IqNB
NOmkXKalIW4mod3Q46BR2gBWYeWZZzjPlppBhM5ygEvD4M5oX1neSBmv33ulg5zjn1FSYSNM
baLvCbYkhwOHkCZkpZ7W88SyE2oOKfEn9n/ajhXDHf488hPgcxDLZZGCUFNasIuYOPVdLxJO
Kjgke7h5JEdDFyY9WC1Lo65q2jBV58WPMRjIuHqNDvNY2Iv3FFH4ZTOtzt05089b4JGmcUE5
BpZIwIWbYKbpplku8TLaWCLtvI3FT5a+i3e3bXLrkr+DnFPquQqSE7qoMguX917O5L7b6cls
4py9V295W/vueKceipU84wv8X0IT5jNXRZbdrmvGZOZSuwVbsyUhY9Q/IORTGtzrY3l2su7Q
hRuRxj2sHn1BqnZ357c96fOI8GlW7TLiX52IFw0EL5qdqS0+dDXfmNVt4wmBZZhLniT9hu75
ThCXwhLN/2jzCr2xY713zYBn49SZK6vZogvDyE6SLSuz7aQ6/CY2jI2Eoi/FD7miLNq5Szfo
OafUDzYNCPA7Bd/iTb4CkNkHN6VqJqR5B+EfMY0hAlRGb98Db00+uxRg2AAAAAAAAA==
--------------ms010409010104060407090907--
