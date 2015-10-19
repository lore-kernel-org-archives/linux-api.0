From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Mon, 19 Oct 2015 10:24:59 -0400
Message-ID: <5624FD3B.2050401@gmail.com>
References: <5622700C.9090107@miglix.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050601070406060903030707"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5622700C.9090107-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050601070406060903030707
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-17 11:58, Tobias Markus wrote:
> Add capability CAP_SYS_USER_NS.
> Tasks having CAP_SYS_USER_NS are allowed to create a new user namespace=

> when calling clone or unshare with CLONE_NEWUSER.
>
> Rationale:
>
> Linux 3.8 saw the introduction of unpriviledged user namespaces,
> allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" roo=
t
> inside a separate user namespace. Before that, any namespace creation
> required CAP_SYS_ADMIN (or, in practice, the user had to be root).
> Unfortunately, there have been some security-relevant bugs in the
> meantime. Because of the fairly complex nature of user namespaces, it i=
s
> reasonable to say that future vulnerabilties can not be excluded. Some
> distributions even wholly disable user namespaces because of this.
>
> Both options, user namespaces with and without CAP_SYS_ADMIN, can be
> said to represent the extreme end of the spectrum. In practice, there i=
s
> no reason for every process to have the abilitiy to create user
> namespaces. Indeed, only very few and specialized programs require user=

> namespaces. This seems to be a perfect fit for the (file) capability
> system: Priviledged users could manually allow only a certain executabl=
e
> to be able to create user namespaces by setting a certain capability,
> I'd suggest the name CAP_SYS_USER_NS. Executables completely unrelated
> to user namespaces should and can not create them.
>
> The capability should only be required in the "root" user namespace (th=
e
> user namespace with level 0) though, to allow nested user namespaces to=

> work as intended. If a user namespace has a level greater than 0, the
> original process must have had CAP_SYS_USER_NS, so it is "trusted" anyw=
ay.
>
> One question remains though: Does this break userspace executables that=

> expect being able to create user namespaces without priviledge? Since
> creating user namespaces without CAP_SYS_ADMIN was not possible before
> Linux 3.8, programs should already expect a potential EPERM upon callin=
g
> clone. Since creating a user namespace without CAP_SYS_USER_NS would
> also cause EPERM, we should be on the safe side.

Potentially stupid counter proposal:
Make it CAP_SYS_NS, make it allow access to all namespace types for=20
non-root/CAP_SYS_ADMIN users, and teach the stuff that's using userns=20
just to get to mount/pid/net/ipc namespaces to use those instead when=20
it's something that doesn't really need to think it's running as root.

While this would still add a new capability (which is arguably not a=20
good thing), the resultant capability would be significantly more useful =

for many of the use cases.

Potentially more flame resistant counter proposal:
Write a simple LSM to allow selective usage of namespaces (IIRC, working =

LSM stacking is in mainline now).  While this is more complicated than=20
just adding a capability, it is also a lot more resilient from a long=20
term prospective.


--------------ms050601070406060903030707
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE5MTQyNDU5WjBPBgkq
hkiG9w0BCQQxQgRAkN2m27MfcpVHMJ8XfyLY0CraKvCc746GyzRf9M96ydKpz/2lLkkzDw3u
n+YvgRA3brWSnZE99t3K+p3lzo0BmjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAA75tsOQccI47r0ZfCYxBkKdS1NyCbmuH49SM6TOYmj8aKsqKM
yQCfsN58GymTm4k6uH7AQH96aRUR7/wdJEvhyc2O9ymRie0MkpY6mK9qSJjWv5BeimU5LU2x
ECBi9+9BlJyB3FU045nXQnaMCxaa9okQZIlMN0FRlXIjvRwsBkZ5GY86eWExuehyQQDUQQ5I
jKHNfzmaANk0GqbpDBm9UOkG79zgqY8M3ulM//EMQZsdr/Q8ALSxDXYGkbIBtpsULK78J4Lg
xqeyM2Q4CNoVOL7FpAnHX+jFXX/5y2m6wXTTyjuV7hKwncFfqz1JnFCpSe/aUfyeXxISOprK
7XXUDEfKFc1mNmUiUHvpn6dHoOCkTxM6JZooYRRKez/Kxe2kMdcHwemCLhijvL+hXyMWzS5F
SCBNMwAu39+Guysy35JNpGbX5ogCeegx11OnIBD8Erqz6f/1eXh7H5IDjvD6e3j+i0Po3pD+
+PO4ghaVaru9CPgCGVa6SpUv9BoT4eiZqtfqjUmbo9TqW1ACZC70ro65Z99tIUZW5xukIogo
cWv5e/t+CMPSEKgh2vEX3pgPh2WYyLkvV6GRtA3cn53xc/9Hz6AJdy6/adKJcl+dCSuuwygW
Hv9vF7VkloSUu6AnsxWJnU3U+bhPlrFP94KWnrimqCF5UWkYv46MD7sjZwAAAAAAAA==
--------------ms050601070406060903030707--
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
