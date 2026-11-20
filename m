Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795190156;
	b=j8WJZrzULd/0L4t08pV9aQFeB8nqhEt7TOxrlYKSU9WqevteBYaomMRARSQTwgvquIBz
	 cJxBzNfimw1fyQv94wzefsHttd6Yzo5PEUG3LuA2hvfqi8/cu0mEnhC/yJzFeqXewk9hB
	 4wcjYEY0nvUuk30KtE94TVUdLoCaY3KdWw1LqqdgpCqrgyEkQtQ3EleFnkRzxSKIi1xQe
	 uQzTADeWXXYx9ysqLBIAwSVa05pL03kPhx93kBGro4xotwRUuSU4bPjaJOkWy4Hnc7AcW
	 NDZlwEDLIf/mFADHNEdmG9KiSqiNfuH+rz3LWCNVyurGzzeZZgE055qZdeB49PDdI1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190156;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
	b=KW80oHWelw0ixb41ms5be0nXlaaMLTrNhRVA+q248UqkN6vQ5Cu0++m/icTHuE77R70r
	 vDChVtB0hH3FOQ8eDeitqsDDFTrh+3FMWTwk8zASkrI8tvvtuKZJ0KBkklRjKdkx54Tpi
	 928XO850JtDmJ0/4EQyZW5ZTAp2AgjmB3y+xzktIg4FWv1+RzlN7igbVuJXjJJ4R4gGDj
	 xO5mXPca89xAUyxwiIAcJlNrbo6NeUr8w12l1WWpUGuXitI6gzLJPe4cXJk2xL5zO6OKV
	 MLG0zE+sDSBkMvirfqbFc/Vtnvvb2R+kKMJ61O9EAhI+iF3XmCcbyQfR72HByw3QiJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZNI+Voqp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73741606C881
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 15:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73741606C881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZNI+Voqp
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b894a5ce3dso1369742a12.2
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 07:55:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795190155; cv=none;
        d=google.com; s=arc-20260327;
        b=LJxUaKKhZNeumLwuw1JOCkWKyDq8fvfgGnlQxQcFjdokX5zwQ6FtUi+9BZ08NgRmkL
         uNIGR74L/uyuLf7vEQA98xgerbDSW0gKrLfhAUZ6+Rt8UcEf4MUx3cYEuve21YIIoDzq
         4l791QGbXzormXWyyZMcpM56rlazy2ci2AXSkL2gpRrSTktzfSQvEYLYl1HIAJ/Oq5g6
         B3r1Uj4RVOXVLSKi/UIGGzMsit/fwtgZAs+1zheaapAYPDEkmV+1D2QpenYgfO7GNFSV
         LlldW0j1e5Ig8pqwSbZ860f2jTiev6jvJZXi/FHYbkQFwo34eus76fCQ4WbCV7HpY+Qm
         tKdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
        fh=s/t9B729skL5vm5pW7+tVZyCB+j/MCEWXj10LnTRdLg=;
        b=FBpV3GDLpLc926Kx1UBbz1JVJxLP5iFbs5TxEhjVrwAZnLzTKvD/gWFX5/oCcm0c1O
         6ECRe5NaDFRziSyUCCVDvHHvXSZKsFfL7TexZXBxrK3e3h9eWIV/HRJ8kb4vxGdLu1+p
         Z/INRrnSEPzfSq/SP6Y4BrcSFzf3j1i9ORLxzaWRPVhXoFAcuriFlTJtye+jEv3nDZmU
         El2ZIGqzRAiFEopzMwSVLoYXw78/ZLjo1Id5g0PAH9QVr3h4sVV1ovAaOFdvxQ7Lvoyp
         xpszjVaIOIPNTD4YiqdRaLMoRFwy/SDb7QpcL2ZUSuAPlhYo99r3D3vLidubyDLM7vOs
         v9fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795190155; x=1795794955; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
        b=ZNI+Voqp8joIQNd2/S11wM6N7/ik5CmAYrFMVM+Yezub5AkrTn1W1ItJezV7UbbAF1
         5qTQfLyNRLQFmS0PqIsUOEfiN3mYBul5KsnIdNx5wI0SCbycars+m1azTZjYLu+DKlmo
         Hu6or5Lgq+6NY9K06NcSL4fiU0xWdN3OjQWZOJU028iCUeNevcp8LSNvbtsBZ7JPfHVj
         IkgHTK2wMJRpRfwaNuD0mIWFr2ZG2tjV2DUx6xxHn2cczUQNiFHkwb9qKdElOtzJkptp
         TGA+t+9OLus+S3udC+294Te6jQ0G8YMIu5iVcDCoz7Y4srkrRJ2MGUSTOds8OnFUqK11
         SOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795190155; x=1795794955;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKN0WqYQTyAXEuN5uWRqYydRHORdhfTbdGPGVmgWZ74=;
        b=MQBrpY4bgZKDCU/9nmLWFpzOAf4/EntXZFA6wlHt5V3fCmOxCJ3AZKO/Dru5g1l5oi
         QRoQt3V2B7nIO7agkxboCc93IH4VO4U5CqQQBzpOmeKHR0qcPMOPc7mB7XSx+1QsM1wf
         QGd1+2pbrB6eJEObC8UneIkf4fERjlR4RalATJhf2AUYpt3LfQ89jmEuvR8Ta3W/L4fY
         d6w4Xl9aYZAOUaFxQpO6XvNSP0bbkT/XIZ7EIJhuXUd96QAPcKGoUJQw0KVnyTelBOsc
         3Wb8gWqQoDwlH3gwKxL0KjS4sILL3NVHPuWgKf0zZcgQAR7y/wzdQY2IP78xNnKXIKf1
         UWQg==
X-Forwarded-Encrypted: i=1; AL+hErGPoYagdYRfXrl2qvda/zvMSQgX6zb63ya9hLXC59+uorSBwCL27YWYLfoc2TibFub10EN1kEQ/Wmg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+HiWxwfyYpxf0FW9UNjd+SGR3UAs4bKCmkQCKqws9g3fB7nOab
	H4osWaG1XxgT8GH7lEP/02eJRDvsTli5td3JGDvG4vhIHyCvERyhj+JTMwt4SpJu5eQsrFo1bV0
	xt6sJIt2Aym092eRAb0etVkbRL6hfjPk=
X-Gm-Gg: AZFdTZdNrdv5fCA+QlIan5u1kDnZI7602RewdMXeB4Hw0cZObofFi7Dz3Y9Pu0glGxN
	nPG98n4YZFnPfR0QyOGP1Wvxo4bZ/K5NF7VxBIeRzOIUcL3t0SsS7b/vygm8ij2HQl6LpzazU/u
	yHQL8hlV9XQsumwAiS2fUkIOQ5LEJvjH3O3aX8vtrXu4afX+iyClI49JBow88+Pv0WYKCbquPVV
	EpTFx0Y1W4Kq3zRmc8FDRu1jwCw4mk+Pug653AZkpdJuSvH9EC5hVvdJpK4kfK6N7iJIr7BeQvs
	xsWd1/goEjE9ZAMzaAPFsNg3ixlQ6gcfKudqdB40m6ohOIN/1Lbifds5ueNCQ7cig67BIYk8DuU
	OhPWjwQBV1a++zRKESNZ7sbnHCIPveMJKVY5x3YM4UNavLzj8kuRfDhoxqMxuznjqeP9zMQ==
X-Received: by 2002:a05:6402:448e:b0:6b8:7769:ffea with SMTP id
 4fb4d7f45d1cf-6ba37ece3efmr2700126a12.45.1795190154705; Fri, 20 Nov 2026
 07:55:54 -0800 (PST)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-11-koray.fra@gmail.com>
 <CAOQ4uxg2gpC99ohuvKm-SgPzuffJy1fSvXorbuBnYZ=OFSxT3w@mail.gmail.com>
 <DMZIZ05H7MMB.1WYNR4X44BPGR@gmail.com> <CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com>
 <DN03GJ80ZWNZ.9GM35HM4T48N@gmail.com>
In-Reply-To: <DN03GJ80ZWNZ.9GM35HM4T48N@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 16:55:42 +0100
X-Gm-Features: Aa3M54qwBZfUZmZq7N4IJA8RoZGlQgYi2IqZuG6tNGKYRI28yA1oVD8H7wW_Hfk
Message-ID: <CAOQ4uxiEX1wO3vRM2UMNrACR8AfxDbrP=oB9w6L-B-twmD3D4g@mail.gmail.com>
Subject: Re: [RFC PATCH v4 10/10] cifs: add provenance time (ptime) and map it
 to SMB's CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 3:05=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> > To reduce the scope of your patch set this may be better.
> >
> >> >>
> >> >> -       /*
> >> >> -        * chattr writes back all flags returned by fileattr_get().=
 Accept
> >> >> -        * FS_CASEFOLD_FL only when it reflects the share's casefol=
d state.
> >> >> -        */
> >> >> -       if (fa->flags & FS_CASEFOLD_FL) {
> >> >> -               rc =3D cifs_fileattr_get(dentry, &current_fa);
> >> >> -               if (rc)
> >> >> -                       return rc;
> >> >> -               if (current_fa.flags & FS_CASEFOLD_FL)
> >> >> -                       allowed |=3D FS_CASEFOLD_FL;
> >> >> -       }
> >> >> -       if (fa->flags & ~allowed)
> >> >> +       if (fa->fsx_xflags_mask & ~CIFS_SUPPORTED_XFLAGS)
> >> >>                 return -EOPNOTSUPP;
> >> >>
> >> >> -       enable_compression =3D fa->flags & FS_COMPR_FL;
> >> >> -       compression_state =3D enable_compression ? COMPRESSION_FORM=
AT_DEFAULT :
> >> >> -                                                COMPRESSION_FORMAT=
_NONE;
> >> >> +       if (fa->flags_valid) {
> >> >> +               /*
> >> >> +                * chattr writes back all flags returned by fileatt=
r_get(). Accept
> >> >> +                * FS_CASEFOLD_FL only when it reflects the share's=
 casefold state.
> >> >> +                */
> >> >> +               if (fa->flags & FS_CASEFOLD_FL) {
> >> >> +                       rc =3D cifs_fileattr_get(dentry, &current_f=
a);
> >> >> +                       if (rc)
> >> >> +                               return rc;
> >> >> +                       if (current_fa.flags & FS_CASEFOLD_FL)
> >> >> +                               allowed |=3D FS_CASEFOLD_FL;
> >> >> +               }
> >> >> +               if (fa->flags & ~allowed)
> >> >> +                       return -EOPNOTSUPP;
> >> >
> >> > This whole mess could be sorted out by switching the cifs
> >> > implementation to the new API
> >>
> >> ("new API" you mean _mask right?)
> >>
> >
> > Yes and ro_mask, but it probably also means converting all the
> > read-only CASEFOLD fs to new api, so that FS_XFLAG_CASEFOLD
> > could be taken out of FS_XFLAG_RDONLY_MASK
>
> Can all flags currently in FS_XFLAG_RDONLY_MASK be rw for some
> filesystems or only some?

No. CASEFOLD is the only one which is MODIFIABLE/SETTABLE
in the old setflags ioctl.

Its twin xflag FS_XFLAG_CASEFOLD was recently added along with
FS_XFLAG_CASENONPRESERVING for a bunch of fs (e.g. nfs) which
advertise it as rdonly attribute.

> Should they all be removed from FS_XFLAG_RDONLY_MASK and left to each
> filesystem to define them as ro (to put in _ro_mask)?
>

No need to do this.

One flag at a time per demand.

You *need* to get FS_XFLAG_CASEFOLD out when some
fs will want to set it via xflags API.

You *may* get a flag out of FS_XFLAG_RDONLY_MASK
only after *all* of the fs which support it have been converted
to the new xflags_*_mask api.

> >> > and implementing a generic vfs
> >> > helper which does something like the above code to handle the
> >> > old ioctls.
> >> > FS_XFLAG_CASEFOLD would then be removed from
> >> > FS_XFLAG_RDONLY_MASK and set explicitly in xflags_ro_mask
> >> > by fs which don't allow to set if (e.g. nfs) and added to
> >> > FS_COMMON_FL/FS_XFLAG_COMMON
> >> >
> >> > cifs would advertise FS_XFLAG_CASEFOLD in its ro_mask
> >> > and then the generic helper would mask it and the new syscall
> >> > will not allow it.
> >> >
> >> >> +       }
> >> >> [...]
> >> >> +               cifs_dbg(FYI, "set compress flag rc %d\n", rc);
> >> >
> >> > I think that the roadmap should be to slowly define all the old FS_*=
_FL
> >> > flags as FS_XFLAGS_* and let the generic helpers deal with the conve=
rsion.
> >>
> >> > But it is not so hard to convert one filesystem at a time in a way t=
hat
> >> > fa->fsx_valid will have to be true, because, for example, here
> >> > all the relevant flags would be supported by the new xflags API.
> >>
> >> So, something like what fileattr_fill_{x,}flags() do now, but for
> >> file_attr_to_fileattr()?
> >>
> >
> > Yes, something like this (maybe)
> >
> >  void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
> >  {
> >         fa->flags_valid =3D true;
> > +       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
> > +       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
> >         fa->flags =3D flags;
>
> So, for the filesystems that switch to the new API, these new/changed
> helpers should handle giving userspace the legacy FS_*_FL flags (if
> userspace uses FS_IOC_GETFLAGS) by converting them from the FS_XFLAG_*
> reported by the filesystem?
>

I did not look at the implementation details but when you make the
vfs API rich enough with the masks, the should be no problem to
describe in the API what the old ioctls do
"get a subset of attributes"
"set a subset of attributes"

Where "subset" differs depending on the ioctl.

> But did you write this
> > +       fa->fsx_valid =3D !(flags & ~FS_COMMON_FL);
> > +       fa->fsx_xflags_mask =3D FS_XFLAG_COMMON;
> while thinking about FS_IOC_SETFLAGS, so from userspace to filesystem,
> and this would be needed because that filesystem wouldn't know what
> FS_*_FL are, so it will use the _mask and the converted xflags?
>
> But why the opposite of (flags & ~FS_COMMON_FL) as fsx_valid?
>
> Why fsx_valid =3D 0 if the passed flags also contain non-FS_COMMON_FL
> flags and fsx_valid =3D 1 if the passed flags contain only FS_COMMON_FL
> flags?
> (if I understood correctly)
>

My interpretation of fsx_valid (for the set side) is:
fs may completely ignore ->flags and get all the information from fsx_*
similarly for flags_valid fs does not need to look at fsx_*

In the case that all requested flags are common, both
fsx_valid and flags_valid can be true.

But what I wrote is nonsense, because the old ioctls have no request_mask
so unset flag does not mean it is not being set.

I think what is needed is something like this helper to be called from
filesystems:

bool fileattr_prepare_xflags(struct file_kattr *fa, u32 xflags, u32 support=
ed)
{
        if (fa->flags_valid) {
                fa->fsx_valid =3D !(fa->flags & supported & ~FS_COMMON_FL);
                fa->fsx_xflags_mask =3D supported & FS_XFLAG_COMMON;
        }
        return fa->fsx_valid;
}

Then cifs_fileattr_set() starts with:

        if (!fileattr_prepare_xflags(fa, CIFS_SUPPORTED_XFLAGS))
                return -EOPNOTSUPP;

And from here on, talk only xflags and xflags_*mask

For cifs that means to add vfs support for FS_XFLAG_COMPR
<-> FS_COMR_FL conversion in helpers.

FS_COMR_FL is also rdonly flag in some fs and rw in others.

> > But in this model FS_XFLAG_COMMON are only the ones that
> > are mutable from the old ioctl.
> >
> > We would need to define FS_READONLY_FL to deal with the
> > group of read-only legacy flags, if some fs needs them and wants
> > to use the new API.
>
> So the those filesystems can put it in _ro_mask on GET you mean?
>

Actually, I meant that the old setflags ioctls could be translates to the
new xflags_mask dialect, for example:

bool fileattr_prepare_xflags(struct file_kattr *fa, u32 xflags, u32 support=
ed)
{
        if (fa->flags_valid) {
                fa->fsx_valid =3D !(fa->flags & supported & ~FS_COMMON_FL);
                fa->fsx_xflags_rw_mask =3D supported & FS_XFLAG_COMMON &
                                                          ~FS_XFLAG_RDONLY_=
MASK;
                fa->fsx_xflags_ro_mask =3D supported & FS_XFLAG_COMMON &
                                                          FS_XFLAG_RDONLY_M=
ASK;
        }
        return fa->fsx_valid;
}

so it will work correctly for example with fs/ntfs which supports
readonly ENCRYPT|COMPR

Thanks,
Amir.
