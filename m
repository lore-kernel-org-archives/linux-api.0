From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
Date: Wed, 29 May 2019 08:53:34 -0700
Message-ID: <312a138c-e5b2-4bfb-b50b-40c82c55773f@schaufler-ca.com>
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
 <14347.1559127657@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cNkJJFaLGPzGj0MrH4stT0km9ovmzGP9Z"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <14347.1559127657@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module <linux-security-module@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cNkJJFaLGPzGj0MrH4stT0km9ovmzGP9Z
Content-Type: multipart/mixed; boundary="CGJ0IeN7E9pxspTs8jkc4kNwow51RM68Y";
 protected-headers="v1"
From: Casey Schaufler <casey@schaufler-ca.com>
To: David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org,
 keyrings@vger.kernel.org,
 linux-security-module <linux-security-module@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
Message-ID: <312a138c-e5b2-4bfb-b50b-40c82c55773f@schaufler-ca.com>
Subject: Re: [PATCH 3/7] vfs: Add a mount-notification facility
References: <CAG48ez2rRh2_Kq_EGJs5k-ZBNffGs_Q=vkQdinorBgo58tbGpg@mail.gmail.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905933492.7587.6968545866041839538.stgit@warthog.procyon.org.uk>
 <14347.1559127657@warthog.procyon.org.uk>
In-Reply-To: <14347.1559127657@warthog.procyon.org.uk>

--CGJ0IeN7E9pxspTs8jkc4kNwow51RM68Y
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

On 5/29/2019 4:00 AM, David Howells wrote:
> Jann Horn <jannh@google.com> wrote:
>
>>> +void post_mount_notification(struct mount *changed,
>>> +                            struct mount_notification *notify)
>>> +{
>>> +       const struct cred *cred =3D current_cred();
>> This current_cred() looks bogus to me. Can't mount topology changes
>> come from all sorts of places? For example, umount_mnt() from
>> umount_tree() from dissolve_on_fput() from __fput(), which could
>> happen pretty much anywhere depending on where the last reference gets=

>> dropped?
> IIRC, that's what Casey argued is the right thing to do from a security=
 PoV.
> Casey?

You need to identify the credential of the subject that triggered
the event. If it isn't current_cred(), the cred needs to be passed
in to post_mount_notification(), or derived by some other means.

> Maybe I should pass in NULL creds in the case that an event is being ge=
nerated
> because an object is being destroyed due to the last usage[*] being rem=
oved.

You should pass the cred of the process that removed the
last usage. If the last usage was removed by something like
the power being turned off on a disk drive a system cred
should be used. Someone or something caused the event. It can
be important who it was.

>  [*] Usage, not ref - Superblocks are a bit weird in their accounting.
>
> David


--CGJ0IeN7E9pxspTs8jkc4kNwow51RM68Y--

--cNkJJFaLGPzGj0MrH4stT0km9ovmzGP9Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEC+9tH1YyUwIQzUIeOKUVfIxDyBEFAlzuqwkACgkQOKUVfIxD
yBEWag//SJA6JpQHXqyOeXOtCod82vVguKxz7q2fheSMMS+T8bB0rX2XTO4rho9D
t5wUt9c1+HtGk8HBvbS7vOnjhXso6RshvI2uUEfE0MOQ/Y1FBIqXwrTzpSs8/FVE
tv3YFqCWlcaLOfnh/Gl0GvK+o5DGMVFDVsv0j3ke5VihJ4enHnn18AncowE5nVu3
n9GahTQcWaRIgYIHJ9Wr0olwAQsa2TQpj/0wJR3I5ni1hY10wknm9jCIw2L612xU
l5rZ73EqvgIjqsq9m1rgZqjH3QypYvTgdDCd9I/AdZmAI8QJ3JISRzZlKGw2o6GL
ZIExEzQCVMzGyqEDkTxQQlXjczfF7jHCWQ9+iyyz747JMRrx1Kr6LqZlTJsfQCc0
F+Ytx0D8RVkwkpkrzIQz5eS/R2ib2lYH7Jtk9RhreDagrzkieeyZ3A3Y0feYqIb3
O7tGYBfQVWx5dVjB5nZ7v/aUw7Wc929yiONfiHLxSg8U4xlj0mFSa0HFOYC4DzaG
C0NSVb7xvoDfpyt6m9Wv1mF7cJKkLFffeMfqUREZAcNEdiYrg90Ho6cJ5tZVreSu
rVgR81R7SSVANygbfauj9X3N3D4fsWxu+D81zz0B9CBgy8GP+p/kWrL45hRC4CLN
hG3yC60hUm54xq2H3YT775eyGBcDixyPsh5qmTXQ21MtLLm3W1c=
=qEff
-----END PGP SIGNATURE-----

--cNkJJFaLGPzGj0MrH4stT0km9ovmzGP9Z--
