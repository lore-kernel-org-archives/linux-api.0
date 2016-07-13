From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH review 08/12] quota: Ensure qids map to the filesystem
Date: Wed, 13 Jul 2016 07:43:59 +0200
Message-ID: <20160713054358.GB28635@pc.thejh.net>
References: <874m82bptc.fsf@x220.int.ebiederm.org>
	<20160706181212.16267-1-ebiederm@xmission.com>
	<20160706181212.16267-8-ebiederm@xmission.com>
	<20160711101424.GH12410@quack2.suse.cz>
	<878tx8dowu.fsf@x220.int.ebiederm.org>
	<20160713013436.GM1922@dastard>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3310907122790532993=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160713013436.GM1922@dastard>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--===============3310907122790532993==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2016 at 11:34:36AM +1000, Dave Chinner wrote:
> On Mon, Jul 11, 2016 at 01:12:49PM -0500, Eric W. Biederman wrote:
> > The place where I am concerned about thorough review and testing is
> > someone poisoning quota files and then the kernel trying to use them.
> > In the preliminary work we have done in other places in the kernel and
> > for other filesystems there almost always winds up being some way to
> > confuse the kernel and get it to misbave if you can poison the disk
> > based inputs.  As poison disk based inputs is not something filesystems
> > are stronlgy concerned about.  In most cases the disk the filesystem
> > resides on is in the box and therefore under control of the OS at all
> > times.  Dave Chinner has even said he will never consider handling
> > poisoned disk based inputs for XFS as the run time cost is too high.
>=20
> I didn't say that. I said that comprehensive checks to catch all
> possible malicious inputs is too expensive to consider a viable
> solution for allowing user-mounts of arbitrary filesystem images
> through the kernel.
>=20
[...]
>=20
> To bring this back to quota files, the only way to validate that a
> quota file has not been tampered with is to run a quotacheck on the
> filesystem once it has been mounted. This requires visiting every
> inode in the filesystem, so it an expensive operation. Only XFS has
> this functionality in kernel, so for untrusted mounts we could
> simply run it on every mount that has quotas enabled. Of course,
> users won't care that mounting their filesystem now takes several
> minutes (hours, even, when we have millions of inodes in the fs)
> while these checks are run...
>=20
> Detecting malicious corruptions that specifically manipulate the
> on-disk structure within the bounds of format validity are difficult
> to detect and costly to protect against. We'd need to move large
> parts of fsck into the kernel and run it to validate every piece of
> metadata read into the kernel. Then we've got a much larger attack
> surface in the kernel (all the validity checking code needs to be
> robust against invalid structures, too!), a lot more complexity
> (more bugs!) and a lot of additional runtime overhead (slow
> filesystem =3D unhappy users!). It's just not a practical solution to
> the problem.

And ideally, you'd want to also guard against an evil disk that
suddenly changes its contents after you've run fsck on it, and you
can't easily do that without making things complicated.

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXhdUeAAoJED4KNFJOeCOoreUP/23k8/qqmks0+x+HClArdBXt
66KSAofgRbqWDnjsAB+XjmoLPzfAOv9QBD/9zyAHTfgqFJ5Fmeur+LxK8w2aysyZ
EwBTU7fbuEqtBlIH4Dtt5YRM5us7ImTyfryAzr2U5gzIuc/vn3Bt8127coCFBGT+
gDS/ija6j/emH3u0WOAiTAZV6mzm2x7bes3e5YRk9SY1A0tZqKmtSnjgWNuYLfpL
Ljq24SqiYOv6ekAscpmKV4Fc9/RsSKNwHsBkCRuu4nBSxB9ISawYsNDG4yW+Ssnq
ctnQDPzYcvZQuv+UgnCHUNoRkkLRTw4+47VlW2mUP02poTjxUb+1DkBJz2lSccFq
51LDgz1MH02wOwWCQ2LFRO62+j+xRBolRAKaVMzNktWB1nwk7BWD4VkOuhgOCieZ
DNAUn0bfArwLYfOwFd9FUlnYCszRJlyL1WNkoc/UOdFm9uWo9HwgI9fiq2M/JEGq
6DCmVcoJ5FMXKhrnYOV5KCM3WlCdhlnviA8GjY+5nEh++lwhlukIvjFZvflAQ23X
cIpjAhh+so11P9GCaimYHC+hiiaqvGN+lBUiNmUMABTWoXwhLitcIRmmSGSNKllS
+D66ziG5Yg2mm7iGNJkimP6aDeFsHKrjwWI4sEkfoTIeMuDB1r5/T7gxZPfrmduN
uveCGM9adO66s2bmw0IU
=tfly
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--

--===============3310907122790532993==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============3310907122790532993==--
