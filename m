From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Mon, 25 Jan 2016 11:08:31 +0100
Message-ID: <20160125100831.GC29561@c203.arch.suse.de>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
 <20160119160421.GM2742@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C6181A4@MX105CL01.corp.emc.com>
 <20160125092612.GB29561@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C61AE33@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C61AE33@MX105CL01.corp.emc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 25, 2016 at 09:30:47AM +0000, Singhal, Maneesh wrote:
> Thanks Johannes for generously reviewing my patch. It indeed is going=
 to improve the thing a lot. I agree with all your comments so far, and=
 will submit a newer patch soon.=20
> Since this is my first patch, I have couple of questions regarding su=
bmitting the patch:
>=20
> 1.  Is there a page/place where I can see the review comments rather =
neatly ?, finding out all the comments and infact reading to entire cod=
e on text file is cumbersome. If there is no way, then its fine,... I c=
an live with it.

Nope unfortunately not. That's why it's nice when people trim their e-m=
ails
;-)

> 2. When I address the review comments and want to resubmit the patch,=
 do I need to submit the incremental patch or the entire code patch aga=
in ? git-format-patch gives me incremental patch only.

Ususally you change your code and do a git commit --amend. This modifie=
s your
commit instead of creating a new one. If you already have a new commit =
than
you can use git rebase -i <version befor commit to amend> and squash th=
e
commit's into one (git gives you a nice readme when doing rebase -i). A=
fterwards
you do a git format-patch -1 -v 2, this creates a v2-0001-your-patch-na=
me.patch
for git send-email which has an updated [PATCH V2] in the subject.

At least, the above is the way I do it (i.e. there are more than one wa=
ys to
do it).


--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
