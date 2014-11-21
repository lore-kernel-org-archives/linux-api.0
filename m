From: Eric Blake <eblake@redhat.com>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 14:18:16 -0700
Message-ID: <546FAC18.5020200@redhat.com>
References: <546F4981.8080907@draigBrady.com> <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com> <546F86F5.6070305@draigBrady.com> <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com> <546FA51F.40503@draigBrady.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uRkcOSr1JaGfMjNr5BRgJNqVnNTvswS1n"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <546FA51F.40503@draigBrady.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigbrady.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uRkcOSr1JaGfMjNr5BRgJNqVnNTvswS1n
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/21/2014 01:48 PM, P=C3=A1draig Brady wrote:
> On 21/11/14 19:55, Andy Lutomirski wrote:
>> On Fri, Nov 21, 2014 at 10:39 AM, P=C3=A1draig Brady <P@draigbrady.com=
> wrote:
>>> On 21/11/14 18:09, Andy Lutomirski wrote:
>>>> On Fri, Nov 21, 2014 at 6:17 AM, P=C3=A1draig Brady <P@draigbrady.co=
m> wrote:
>>>>> If 'a' and 'b' are hardlinks, then the command `mv a b & mv b a`
>>>>> can result in both being removed as mv needs to emulate the
>>>>> move with an unlink of the source file.  This can only be done
>>>>> without races in the kernel and so mv was recently changed
>>>>> to not allow this operation at all.  mv could safely reintroduce
>>>>> this feature by leveraging a new flag for renameat() for which
>>>>> an illustrative/untested patch is attached.
>>>>
>>>> ISTM the issue is that rename(2) does nothing if the source and dest=

>>>> are hardlinks to each other.  Is that intentional?  I don't see that=

>>>> behavior as required in the POSIX rename docs.

Yes, POSIX unfortunately requires that behavior:

http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html

"If the old argument and the new argument resolve to either the same
existing directory entry or different directory entries for the same
existing file, rename() shall return successfully and perform no other
action."

>>>
>>> It's surprising and annoying that existing systems do this,
>>> but they're conforming to the wording of POSIX I thinkg as
>>> it says that rename() does nothing when the source and dest
>>> _file_ is the same. What POSIX really meant I suppose was _file name_=
=2E
>>> Eric, perhaps an adjustment could be proposed to POSIX, as I can't
>>> see anything relying on the current behavior?

The POSIX wording describes existing practice of all implementations,
and as annoying as it is, requiring all implementations to change would
be too invasive, and going against that wording without the use of an
extension to renameat would catch software off-guard that is expecting
the baked-in POSIX semantics.

That said, would you still like me to take a stab at a proposal to the
POSIX folks that would relax the requirements to allow
implementation-defined behavior when the two arguments to rename
describe the same file but via different directory entries?  Note that I
am NOT proposing a change to rename("a", "a") which must always succeed
(true even when two spellings are different but still resolve to the
same directory entry, as in rename("a", "./a")).  Rather, this is only a
question about the behavior of rename("a", "b") when they are two
different hardlinks resolving to the same file.

At any rate, regardless of what POSIX says, I'm totally in favor of a
renameat flag that gives us fine-tune control over the behavior; we can
implement it now as an extension, and once it hits mainline kernel, I
would have no problems proposing that flag for POSIX standardization
(the POSIX folks have a thing for preferring existing implementations,
after all)

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


--uRkcOSr1JaGfMjNr5BRgJNqVnNTvswS1n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg

iQEcBAEBCAAGBQJUb6wYAAoJEKeha0olJ0NqWugH/Rw9R9Xscy6kSEBASgVVf+ou
hgr1VE75iWoqYvYjLB20dGAgc9qdvWkQ3eNb4Q3a06tDC+XTUe/IE+TXkVlbGXbS
4ErJJ9YbJgxgeEwEj0GEyJo5f/+RUaPFJ5a1nzH4b3br7G+tXAToXYmlAsV5JlcR
DFt50c4CWjo/sHJj/rEEp1hIFPCldEF6CqqjeQeNLClZHGTvg1bPvSeslwkXFYyl
jYTRPXaXoS8RDAIkzzS1zvmfjO7BQUP79cqw54lEH03WVejYbXylEpTU4z+7veI1
rzVWm6yryNz8k1TRsXDKnP+QtCDjfXpFldKCf9QvIYvLP9XzzhSydXzRmVJfuLs=
=rsQI
-----END PGP SIGNATURE-----

--uRkcOSr1JaGfMjNr5BRgJNqVnNTvswS1n--
