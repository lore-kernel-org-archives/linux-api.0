From: NeilBrown <neilb-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 4/6] vfs: add the RWF_HIPRI flag for preadv2/pwritev2
Date: Mon, 09 May 2016 07:47:04 +1000
Message-ID: <874ma8usrr.fsf@notabene.neil.brown.name>
References: <1457017443-17662-1-git-send-email-hch@lst.de> <1457017443-17662-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457017443-17662-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
Cc: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 04 2016, Christoph Hellwig wrote:

> This adds a flag that tells the file system that this is a high priority
> request for which it's worth to poll the hardware.  The flag is purely
> advisory and can be ignored if not supported.

Here you say the flag is "advice".

>=20=20
> +/* flags for preadv2/pwritev2: */
> +#define RWF_HIPRI			0x00000001 /* high priority request, poll if possibl=
e */

This text makes it sound like a firm "request" ("if possible").

In the man page posted separately it says:

+.BR RWF_HIPRI " (since Linux 4.6)"
+High priority read/write.  Allows block based filesystems to use polling o=
f the
+device, which provides lower latency, but may use additional ressources.  =
(Currently
+only usable on a file descriptor opened using the
+.BR O_DIRECT " flag)."

So now it "allows", which is different again.

The differences may be subtle, but consistency is nice.

Also in that man page fragment:

> provides lower latency, but may use additional ressources

Is this a "latency vs throughput" trade-off, or something more subtle?
It would be nice to make the decision process as obvious as possible for
the developer considering the use of this flag.

(and s/ressources/resources/)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXL7PYAAoJEDnsnt1WYoG5wE8P+gOn2RRXDO0ZyV5HO5yrL0xA
BnUEZvK+iCjsggVDem+lsoawdx0RxjL8XIom8MqwaNsvTQKO2qsOEq+aMgbx0gyS
u+FTZu8xnJ2AHgcPq2Rvcqh8KMq4e59H7XyEJi6cMiw3fhlI0JXx1ze4ldR0Juk/
XSbDzh9Gjj/g4A7xY6caGLyBEN0kssWsqfDD2K06pLRgo+yUwoNLS9UAH+sc6Nnk
oymT/f7tvwLusEbNnJEi+B0SEtbLaTiyRaiNBUpCQOQjb/Sb+XpYFIiE3jUW5wII
ZSu8GKcJzQko1+DRmLsgg6yTEPTBuP4y4sNslZBM0Zw46rqHZw3XuF7v9P4pZous
rPM/mSr7OeolraKIQ17jbgaxT5oCXOb1pS6lyrrRoGZWFDq/5HnOJpDIWH/dN8I3
+JdtH9WD+Bw92WTWHtJkYgIxVWgZpyNy6cUF3MKWoSIKjTxIQLDvMRBNcKpnTmbl
7iA9JvIG94tUfmSuhl+Q8NphFR+UngoFsDA6EmBwRFAmdkdynyEY26Q1v3mGfLWY
2ZkY85m+puD2lr8lz//Ni1Nn5QcCqz+cHiKCcPoLNdWCjWIKv2a73FE+ntNpF7BH
bungow73ZD5LcCYEQ7GZxKTS4leVDXj7SjmFd7sr/+tZ+yG272Lt6Nz4koAAKjqG
JfacBkwOQYvZn+AppQRX
=xLQf
-----END PGP SIGNATURE-----
--=-=-=--
