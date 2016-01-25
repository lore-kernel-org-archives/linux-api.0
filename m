From: "Singhal, Maneesh" <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
Subject: RE: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Mon, 25 Jan 2016 10:16:30 +0000
Message-ID: <82807C73E0BDBB498164AAE7B8F6A1481C61B01A@MX105CL01.corp.emc.com>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
 <20160119160421.GM2742@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C6181A4@MX105CL01.corp.emc.com>
 <20160125092612.GB29561@c203.arch.suse.de>
 <82807C73E0BDBB498164AAE7B8F6A1481C61AE33@MX105CL01.corp.emc.com>
 <20160125100831.GC29561@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160125100831.GC29561-3LAbnSA0sDC4fIQPS+WK3rNAH6kLmebB@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "JBottomley-wo1vFcy6AUs@public.gmane.org" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks a lot for detailed information. Appreciate it !

Regards
Maneesh

> -----Original Message-----
> From: Johannes Thumshirn [mailto:jthumshirn-l3A5Bk7waGM@public.gmane.org]
> Sent: Monday, January 25, 2016 3:39 PM
> To: Singhal, Maneesh
> Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> JBottomley-wo1vFcy6AUs@public.gmane.org; martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; linux-
> api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client
> driver implementation for EMC-Symmetrix GuestOS emulated Cut-
> Through Device
>=20
> On Mon, Jan 25, 2016 at 09:30:47AM +0000, Singhal, Maneesh wrote:
> > Thanks Johannes for generously reviewing my patch. It indeed is
> going to improve the thing a lot. I agree with all your comments so f=
ar,
> and will submit a newer patch soon.
> > Since this is my first patch, I have couple of questions regarding
> submitting the patch:
> >
> > 1.  Is there a page/place where I can see the review comments
> rather neatly ?, finding out all the comments and infact reading to
> entire code on text file is cumbersome. If there is no way, then its
> fine,... I can live with it.
>=20
> Nope unfortunately not. That's why it's nice when people trim their e=
-
> mails
> ;-)
>=20
> > 2. When I address the review comments and want to resubmit the
> patch, do I need to submit the incremental patch or the entire code
> patch again ? git-format-patch gives me incremental patch only.
>=20
> Ususally you change your code and do a git commit --amend. This
> modifies your commit instead of creating a new one. If you already
> have a new commit than you can use git rebase -i <version befor
> commit to amend> and squash the commit's into one (git gives you a
> nice readme when doing rebase -i). Afterwards you do a git format-
> patch -1 -v 2, this creates a v2-0001-your-patch-name.patch for git
> send-email which has an updated [PATCH V2] in the subject.
>=20
> At least, the above is the way I do it (i.e. there are more than one =
ways
> to do it).
>=20
>=20
> --
> Johannes Thumshirn                                          Storage
> jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton HRB 21284 (AG
> N=FCrnberg) Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 96=
9D
> 2D76 0850
