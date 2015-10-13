From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Tue, 13 Oct 2015 16:25:29 -0400
Message-ID: <561D68B9.8030209@Netapp.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <87vbai6sud.fsf@notabene.neil.brown.name> <5617A1E9.1080509@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5617A1E9.1080509-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>, Neil Brown <nfbrown-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/09/2015 07:15 AM, P=C3=A1draig Brady wrote:
> On 08/10/15 02:40, Neil Brown wrote:
>> Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> writes:
>>
>>> @@ -1338,34 +1362,26 @@ ssize_t vfs_copy_file_range(struct file *fi=
le_in, loff_t pos_in,
>>>  			    struct file *file_out, loff_t pos_out,
>>>  			    size_t len, unsigned int flags)
>>>  {
>>> -	struct inode *inode_in;
>>> -	struct inode *inode_out;
>>>  	ssize_t ret;
>>> =20
>>> -	if (flags)
>>> +	/* Flags should only be used exclusively. */
>>> +	if ((flags & COPY_FR_COPY) && (flags & ~COPY_FR_COPY))
>>> +		return -EINVAL;
>>> +	if ((flags & COPY_FR_REFLINK) && (flags & ~COPY_FR_REFLINK))
>>> +		return -EINVAL;
>>> +	if ((flags & COPY_FR_DEDUP) && (flags & ~COPY_FR_DEDUP))
>>>  		return -EINVAL;
>>> =20
>>
>> Do you also need:
>>
>>    if (flags & ~(COPY_FR_COPY | COPY_FR_REFLINK | COPY_FR_DEDUP))
>>    	return -EINVAL;
>>
>> so that future user-space can test if the kernel supports new flags?
>=20
> Seems like a good idea, yes.
>=20
> Also that got me thinking about COPY_FR_SPARSE.
> What's the current behavior when copying a sparse range?
> Is the hole propagated by default (good), or is it expanded?

I haven't tried it, but I think the hole would be expanded :(.  I'm hav=
ing splice() handle the pagecache copy part, and (as far as I know) spl=
ice() doesn't know anything about sparse files.  I might be able to put=
 in some kind of fallocate() / splice() loop to copy the range in multi=
ple pieces.

I don't want to add COPY_FR_SPARSE_AUTO, because then the kernel will h=
ave to determine how best to interpret "auto".  I'm more inclined to ad=
d a single COPY_FR_SPARSE flag to enable creating sparse files, and the=
n have the application tell us what to do for any given range.

Anna

>=20
> Note cp(1) has --sparse=3D{never,auto,always}. Auto is the default,
> so it would be good I think if that was the default mode for copy_fil=
e_range().
> With other sparse modes, we'd have to avoid copy_file_range() unless
> there was control possible with COPY_FR_SPARSE_{AUTO,NONE,ALWAYS}.
> Note currently cp --sparse=3Dalways will detect runs of zeros and als=
o
> avoid speculative preallocation by using fallocate (fd, FALLOC_FL_PUN=
CH_HOLE, ...)
>=20
> thanks,
> P=C3=A1draig.
>=20
