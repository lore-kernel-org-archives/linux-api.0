From: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Fri, 9 Oct 2015 12:15:53 +0100
Message-ID: <5617A1E9.1080509@draigBrady.com>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <87vbai6sud.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87vbai6sud.fsf@notabene.neil.brown.name>
Sender: linux-btrfs-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On 08/10/15 02:40, Neil Brown wrote:
> Anna Schumaker <Anna.Schumaker@netapp.com> writes:
>=20
>> @@ -1338,34 +1362,26 @@ ssize_t vfs_copy_file_range(struct file *fil=
e_in, loff_t pos_in,
>>  			    struct file *file_out, loff_t pos_out,
>>  			    size_t len, unsigned int flags)
>>  {
>> -	struct inode *inode_in;
>> -	struct inode *inode_out;
>>  	ssize_t ret;
>> =20
>> -	if (flags)
>> +	/* Flags should only be used exclusively. */
>> +	if ((flags & COPY_FR_COPY) && (flags & ~COPY_FR_COPY))
>> +		return -EINVAL;
>> +	if ((flags & COPY_FR_REFLINK) && (flags & ~COPY_FR_REFLINK))
>> +		return -EINVAL;
>> +	if ((flags & COPY_FR_DEDUP) && (flags & ~COPY_FR_DEDUP))
>>  		return -EINVAL;
>> =20
>=20
> Do you also need:
>=20
>    if (flags & ~(COPY_FR_COPY | COPY_FR_REFLINK | COPY_FR_DEDUP))
>    	return -EINVAL;
>=20
> so that future user-space can test if the kernel supports new flags?

Seems like a good idea, yes.

Also that got me thinking about COPY_FR_SPARSE.
What's the current behavior when copying a sparse range?
Is the hole propagated by default (good), or is it expanded?

Note cp(1) has --sparse=3D{never,auto,always}. Auto is the default,
so it would be good I think if that was the default mode for copy_file_=
range().
With other sparse modes, we'd have to avoid copy_file_range() unless
there was control possible with COPY_FR_SPARSE_{AUTO,NONE,ALWAYS}.
Note currently cp --sparse=3Dalways will detect runs of zeros and also
avoid speculative preallocation by using fallocate (fd, FALLOC_FL_PUNCH=
_HOLE, ...)

thanks,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
