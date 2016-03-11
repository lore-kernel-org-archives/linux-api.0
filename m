From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Fri, 11 Mar 2016 09:45:32 +0100
Message-ID: <56E285AC.1030803@suse.de>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org>
 <046fc2d00e51f331a6bbc00553cc1f9c.squirrel@us.codeaurora.org>
 <201603101818.33826.arnd@arndb.de> <201603102019.32467.arnd@arndb.de>
 <yq1io0tn604.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1io0tn604.fsf-+q57XtR/GgMb6DWv4sQWN6xOck334EZe@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>, "Matthew R. Ochs" <mrochs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wen Xiong <wenxiong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/11/2016 02:43 AM, Martin K. Petersen wrote:
>>>>>> "Arnd" =3D=3D Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> writes:
>=20
> Arnd> Looking through what other drivers do, I've found a couple of
> Arnd> patterns now. n particular, most use the SG_IO ioctl to pass do=
wn
> Arnd> commands from user space into a device specific command
> Arnd> queue. Have you looked at that interface in the past to see if =
it
> Arnd> would fit your use case?
>=20
> Arnd> There is also a 'bsg' API that some drivers implement, which I
> Arnd> think would be another alternative.
>=20
> Arnd> Could any of the SCSI experts comment on what they expect a dri=
ver
> Arnd> to use out of those three alternatives (if any):
>=20
> My preference is that if you want to expose any information that a us=
er
> or admin would care about, put it in sysfs where it is easily accessi=
ble
> and can be scripted.
>=20
> For things that need to directly send commands to the hardware (to
> configure vendor specific settings or inspect parameters for developm=
ent
> purposes) use the sg or bsg interfaces like we do for both ATA and
> SCSI. bsg is newer and supports more features like bidirectional
> commands. But for this particular use case I don't think it offers an=
y
> particular advantages over SG_IO. Both interfaces take the same
> descriptors so it really doesn't matter much.
>=20
> See:
>=20
> 	http://sg.danny.cz/sg/
>=20
And indeed I would expose this 'special' UFS RPMB as a 'generic'
SCSI device and add the required fields in sysfs, much like Greg KH
suggested.
Plus adding a 'bsg' interface for sending 'raw' UFS commands sounds
much more appealing; that's what we do for SAS and FC, too.

But then, none of the above can be done if there is no hardware
available. At the same time, you wouldn't be able to test any
proposed fixes to the original ioctl patch.
So I guess you'll have to retract this patch or get hold of the
hardware to actually _test_ something there.

Or send me some, I'll be happy to help out here :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
